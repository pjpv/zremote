import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/device.dart';
import '../services/event_observer.dart';
import '../services/link_builder.dart';
import '../services/notifier.dart';
import '../services/rpc_bridge.dart';
import '../services/rpc_codec.dart';
import '../services/rpc_dispatch.dart';
import '../services/resume_health.dart';
import '../services/service_probe.dart';
import '../services/session_jump.dart';
import '../services/web_theme.dart';
import '../state/active_session.dart';
import '../state/app_lifecycle.dart';
import '../state/automation.dart';
import '../state/claim_entry.dart';
import '../state/event_feed.dart';
import '../state/notification_prefs.dart';
import '../state/session_index.dart';
import '../state/session_pool.dart';
import '../state/session_status.dart';
import '../theme.dart';
import '../models/device_label.dart';
import 'automation_page.dart';
import 'claim_page.dart';
import 'session_panel.dart';
import 'sheet_shell.dart';
import 'status_led.dart';
import 'toolbox_sheet.dart';
import 'unread_badge.dart';
import 'usage_page.dart';

class SessionView extends ConsumerStatefulWidget {
  final RemoteDevice device;

  const SessionView({super.key, required this.device});

  @override
  ConsumerState<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends ConsumerState<SessionView> {
  InAppWebViewController? _controller;
  bool _loading = true;
  bool _errorShown = false;
  DateTime _lastAutoReload = DateTime.fromMillisecondsSinceEpoch(0);

  SessionStatusNotifier? _statusNotifier;
  EventFeedNotifier? _feedNotifier;
  SessionIndexNotifier? _sessionIndexNotifier;
  ActiveSessionNotifier? _activeSessionNotifier;
  AutomationNotifier? _automationNotifier;
  ClaimEntryNotifier? _claimEntryNotifier;

  bool _claimEntryProbed = false;

  RpcBridge? _rpcBridge;

  LoopbackDispatchServer? _dispatchServer;
  int? _dispatchPort;

  final ResumeWatch _resumeWatch = ResumeWatch();
  bool _rendererGone = false;
  DateTime _lastWsActivity = DateTime.now();
  Timer? _resumeGrace;

  final StateDiffer _stateDiffer = StateDiffer();

  String? _activeSessionId;

  bool _probeArmed = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool? _appliedWebDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _statusNotifier ??= ref.read(sessionStatusProvider.notifier);
    _feedNotifier ??= ref.read(eventFeedProvider.notifier);
    _sessionIndexNotifier ??= ref.read(sessionIndexProvider.notifier);
    _activeSessionNotifier ??= ref.read(activeSessionProvider.notifier);
    _automationNotifier ??= ref.read(automationProvider.notifier);
    _claimEntryNotifier ??= ref.read(claimEntryProvider.notifier);
    _startDispatch();
  }

  void _startDispatch() {
    if (_dispatchServer != null) return;
    final server = LoopbackDispatchServer();
    _dispatchServer = server;
    server
        .start()
        .then((_) {
          if (!mounted) {
            server.dispose();
            return;
          }
          setState(() => _dispatchPort = server.port);
        })
        .catchError((Object e) {
          debugPrint('[zr-diag] dispatch server bind failed: $e');
        });
  }

  @override
  void didUpdateWidget(covariant SessionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldDev = oldWidget.device;
    final newDev = widget.device;
    if (oldDev.id == newDev.id &&
        (oldDev.baseUrl != newDev.baseUrl ||
            !mapEquals(oldDev.params, newDev.params))) {
      _manualReload();
    }
  }

  void _report(SessionStatus status) =>
      _statusNotifier?.report(widget.device.id, status);

  void _onWsEvent(String body) {
    if (!mounted) return;
    _lastWsActivity = DateTime.now();
    try {
      final event = jsonDecode(body);
      if (event is Map<String, dynamic>) {
        final status = RelayLedPolicy.onWsEvent(event);
        if (event['s'] == 'closed') {
          debugPrint('[zr-resume] ws closed r=${event['r']} -> $status');
        }
        if (status != null) _report(status);
      }
    } catch (_) {}
  }

  void _onAppResume() {
    final now = DateTime.now();
    final status = ref.read(sessionStatusProvider)[widget.device.id];
    final wsIdle = now.difference(_lastWsActivity);
    final signal = _resumeWatch.onResumed(
      now: now,
      rendererGone: _rendererGone,
      live: status == SessionStatus.live,
      sinceWsActivity: wsIdle,
    );
    debugPrint(
      '[zr-resume] check rendererGone=$_rendererGone status=$status '
      'wsIdle=${wsIdle.inSeconds}s -> $signal',
    );
    switch (signal) {
      case ResumeSignal.none:
      case ResumeSignal.keepGrace:
        break;
      case ResumeSignal.reloadNow:
        _rendererGone = false;
        _manualReload('resume-renderer-gone');
      case ResumeSignal.armGrace:
        _resumeGrace?.cancel();
        _resumeGrace = Timer(ResumeHealthPolicy.grace, () {
          _resumeGrace = null;
          _resumeWatch.clearGrace();
          if (!mounted) return;
          final nowStatus = ref.read(sessionStatusProvider)[widget.device.id];
          final healthy =
              nowStatus == SessionStatus.live &&
              DateTime.now().difference(_lastWsActivity) <
                  ResumeHealthPolicy.quietThreshold;
          debugPrint(
            '[zr-resume] grace end status=$nowStatus '
            'wsIdle=${DateTime.now().difference(_lastWsActivity).inSeconds}s '
            'healthy=$healthy',
          );
          if (!healthy) _manualReload('resume-grace-expired');
        });
    }
  }

  void _goHome() => ref
      .read(activeTabProvider.notifier)
      .set(ref.read(deviceListProvider).length);

  void _onBridgeMessage(String body) {
    if (!mounted) return;
    _lastWsActivity = DateTime.now();
    dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      root = null;
    }
    final frameLed = RelayLedPolicy.onFrameRoot(root);
    if (frameLed != null) _report(frameLed);
    if (frameLed == SessionStatus.live && _probeArmed) {
      _probeArmed = false;
      unawaited(_runServiceProbe());
    }

    final activeSession = ActiveSessionExtractor.parseRoot(root);
    if (activeSession != null) {
      _activeSessionId = activeSession;
      _activeSessionNotifier?.report(widget.device.id, activeSession);
    }
    final states = SessionStateExtractor.parseRoot(root);
    final removed = [
      ...SessionStateExtractor.parseRemovedRoot(root),
      ...TaskIndexExtractor.parseRemovedRoot(root),
      ...TaskIndexExtractor.parseArchivedRoot(root),
    ];
    _sessionIndexNotifier?.upsertAll(widget.device.id, states);
    _sessionIndexNotifier?.removeSessions(widget.device.id, removed);
    final snapshotTasks = TaskIndexExtractor.parseSnapshotRoot(root);
    if (snapshotTasks != null) {
      _sessionIndexNotifier?.replaceTasks(widget.device.id, snapshotTasks);
    } else {
      final taskEntries = TaskIndexExtractor.parseRoot(root);
      _sessionIndexNotifier?.upsertTasks(widget.device.id, taskEntries);
    }
    final resultTasks = TaskIndexExtractor.parseResultTasksRoot(root);
    if (resultTasks != null && resultTasks.isNotEmpty) {
      if (TaskIndexExtractor.isBootstrapResult(root)) {
        _sessionIndexNotifier?.replaceTasks(
          widget.device.id,
          resultTasks,
          preservePinned: true,
        );
      } else {
        _sessionIndexNotifier?.upsertTasks(widget.device.id, resultTasks);
      }
    }

    final codingPlan = CodingPlanSignalExtractor.parseRoot(root);
    if (codingPlan != null) {
      _automationNotifier?.reportSubscribed(widget.device.id, true);
    }
    final automationInputs = root != null
        ? <dynamic>[root]
        : body.startsWith('{')
        ? RpcCodec.parseConcatenatedJsonText(body)
        : const <dynamic>[];
    final offPeakFeed = AutomationFeed.offPeakOf(automationInputs);
    if (offPeakFeed.snapshot) {
      _automationNotifier?.replaceOffPeak(widget.device.id, offPeakFeed.tasks);
    } else if (offPeakFeed.tasks.length == 1) {
      _automationNotifier?.upsertOffPeak(
        widget.device.id,
        offPeakFeed.tasks.single,
      );
    }
    final autosFeed = AutomationFeed.automationsOf(automationInputs);
    if (autosFeed.snapshot) {
      _automationNotifier?.replaceAutomations(
        widget.device.id,
        autosFeed.automations,
      );
    } else if (autosFeed.automations.length == 1) {
      _automationNotifier?.upsertAutomation(
        widget.device.id,
        autosFeed.automations.single,
      );
    }
    final projects = RecentProjectsExtractor.parseRoot(root);
    if (projects != null) {
      _automationNotifier?.reportProjects(widget.device.id, projects);
    }

    final events = <ObservedEvent>[
      ...EventParser.parseRoot(root),
      ..._stateDiffer.apply(states, removed: removed),
    ];
    if (events.isEmpty) return;
    final devices = ref.read(deviceListProvider);
    final active = ref.read(activeTabProvider);
    final visibleId = active < devices.length ? devices[active].id : null;
    final appForeground =
        ref.read(appLifecycleProvider) == AppLifecycleState.resumed;
    final prefs = ref.read(notificationPrefsProvider);
    for (final event in events) {
      if (event.type == 'resolved') {
        final taskId = event.taskId;
        if (taskId != null) {
          NotifierService.instance.cancelPending(widget.device, taskId);
        }
        _feedNotifier?.ingest(widget.device.id, event);
        continue;
      }
      if (!prefs.enabled(event.type)) continue;
      final notify = NotificationGate.shouldNotify(
        appForeground: appForeground,
        visibleDeviceId: visibleId,
        eventDeviceId: widget.device.id,
        activeSessionId: _activeSessionId,
        eventSessionId: event.taskId,
      );
      if (!notify) continue;
      _feedNotifier?.ingest(widget.device.id, event);
      NotifierService.instance.notifyFrom(
        widget.device,
        event,
        l10n: AppLocalizations.of(context),
      );
    }
  }

  Future<void> _runServiceProbe() async {
    final bridge = _rpcBridge;
    if (bridge == null) return;
    try {
      await ServiceProbe.run(bridge);
    } catch (_) {}
  }

  void _onViewStateSync(String body) {
    if (!mounted) return;
    final r = MobileViewStateSync.parse(body);
    if (!r.valid) return;
    _activeSessionId = r.taskId;
    _activeSessionNotifier?.report(widget.device.id, r.taskId);
  }

  URLRequest _freshRequest() =>
      URLRequest(url: WebUri(LinkBuilder.buildUrl(widget.device).toString()));

  UnmodifiableListView<UserScript> _userScripts(bool dark) =>
      UnmodifiableListView([
        UserScript(
          source: EventObserver.hookScriptFor(
            _dispatchPort ?? 0,
            _dispatchServer?.token ?? '',
          ),
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        ),
        UserScript(
          source: WebTheme.seedScript(dark),
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        ),
      ]);

  Future<void> _syncWebTheme(bool dark) async {
    _appliedWebDark = dark;
    final controller = _controller;
    if (controller == null) return;
    try {
      await controller.evaluateJavascript(source: WebTheme.applyScript(dark));
    } catch (_) {}
    try {
      await controller.removeAllUserScripts();
      await controller.addUserScripts(userScripts: _userScripts(dark));
    } catch (_) {}
  }

  Future<void> _manualReload([String via = 'manual']) async {
    debugPrint('[zr-resume] reload via=$via');
    setState(() {
      _loading = true;
      _errorShown = false;
    });
    _report(SessionStatus.loading);
    await _controller?.loadUrl(urlRequest: _freshRequest());
  }

  Future<void> _onLoadError() async {
    final now = DateTime.now();
    if (now.difference(_lastAutoReload).inSeconds >= 30) {
      _lastAutoReload = now;
      _report(SessionStatus.loading);
      await _controller?.loadUrl(urlRequest: _freshRequest());
      return;
    }
    if (mounted) {
      setState(() => _errorShown = true);
      _report(SessionStatus.error);
    }
  }

  Future<void> _showSwitcher() async {
    final devices = ref.read(deviceListProvider);
    final l10n = AppLocalizations.of(context)!;
    await showZrSheet<void>(
      context: context,
      builder: (sheetContext) {
        final zt = sheetContext.zt;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final d in devices) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: d.id == widget.device.id
                        ? zt.accentSubtle
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: d.id == widget.device.id
                        ? Border.all(color: zt.accentBorder)
                        : null,
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    leading: _Led(status: ref.read(sessionStatusProvider)[d.id]),
                    title: Text(
                      d.displayName(l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: d.id == widget.device.id
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: d.id == widget.device.id ? zt.accent : zt.textHi,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UnreadBadge(feed: ref.read(eventFeedProvider)[d.id]),
                        if (d.id == widget.device.id) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.check, color: zt.accent, size: 20),
                        ],
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      final index = ref.read(deviceListProvider).indexOf(d);
                      ref.read(activeTabProvider.notifier).set(index);
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 6),
            Divider(indent: 16, endIndent: 16, color: zt.hairline),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: Icon(Icons.tune, color: zt.textLo),
              title: Text(
                l10n.manageTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: zt.textLo,
                ),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _goHome();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSessionPanel() async {
    await showZrSheet<void>(
      context: context,
      isScrollControlled: true,
      maxHeightFactor: 0.72,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final sessionsMap = ref.watch(
              sessionIndexProvider,
            )[widget.device.id];
            final sorted =
                (sessionsMap?.values.toList() ?? <SessionState>[])
                  ..sort(SessionRanking.compareSessions);
            final activeId = ref.watch(
              activeSessionProvider,
            )[widget.device.id];
            return SessionPanelSheet(
              sessions: sorted,
              activeSessionId: activeId,
              deviceName: widget.device.displayName(
                AppLocalizations.of(context)!,
              ),
              onClose: () => Navigator.pop(sheetContext),
              onSessionTap: (sessionId) {
                Navigator.pop(sheetContext);
                _jumpToSession(sessionId);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _jumpToSession(String sessionId) async {
    final controller = _controller;
    if (controller == null) return;
    final workspace = ref
        .read(sessionIndexProvider)[widget.device.id]?[sessionId]
        ?.workspace;
    try {
      await controller.evaluateJavascript(
        source: SessionJump.jumpScript(sessionId, workspace: workspace),
      );
    } catch (_) {}
  }

  Future<void> _openAutomation() async {
    final bridge = _rpcBridge;
    if (bridge == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AutomationPage(device: widget.device, bridge: bridge),
      ),
    );
  }

  Future<void> _openClaim() async {
    final bridge = _rpcBridge;
    if (bridge == null || !mounted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.claimUnavailable),
          ),
        );
      }
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ClaimPage(device: widget.device, bridge: bridge),
      ),
    );
  }

  Future<void> _openUsage() async {
    final bridge = _rpcBridge;
    if (bridge == null || !mounted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.usageServiceUnavailable),
          ),
        );
      }
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UsagePage(device: widget.device, bridge: bridge),
      ),
    );
  }

  Future<void> _probeClaimEntry() async {
    final bridge = _rpcBridge;
    if (bridge == null) {
      debugPrint('claimEntry: probe skip（bridge 未就绪）');
      return;
    }
    debugPrint('claimEntry: probe start');
    bool visible = false;
    for (var attempt = 1; attempt <= 15; attempt++) {
      try {
        final r = await bridge.call(
          'coding-plan-subscription',
          'getManualClaimPlanPreviews',
          timeout: const Duration(seconds: 5),
        );
        final plans = r.firstObject?['plans'];
        visible = plans is List && plans.isNotEmpty;
        debugPrint(
          'claimEntry: probe done visible=$visible '
          'plans=${plans is List ? plans.length : plans}',
        );
        break;
      } catch (e) {
        debugPrint('claimEntry: probe error (#$attempt) $e');
        final s = e.toString();
        final retryable =
            s.contains('no-services') ||
            s.contains('no-method') ||
            e is RpcTimeoutException;
        if (!retryable || attempt == 15) break;
        await Future<void>.delayed(const Duration(seconds: 2));
        if (!mounted) return;
      }
    }
    if (!mounted) return;
    _claimEntryNotifier?.report(widget.device.id, visible);
  }

  @override
  void dispose() {
    _statusNotifier?.forget(widget.device.id);
    _feedNotifier?.forget(widget.device.id);
    _sessionIndexNotifier?.forget(widget.device.id);
    _activeSessionNotifier?.forget(widget.device.id);
    _automationNotifier?.forget(widget.device.id);
    _claimEntryNotifier?.forget(widget.device.id);
    _rpcBridge?.dispose();
    _dispatchServer?.dispose();
    _resumeGrace?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(sessionStatusProvider)[widget.device.id];
    final l10n = AppLocalizations.of(context)!;
    ref.listen(appLifecycleProvider, (prev, next) {
      if (next == prev) return;
      debugPrint('[zr-resume] lifecycle $prev -> $next');
      _resumeWatch.onState(next, DateTime.now());
      if (next == AppLifecycleState.resumed &&
          prev != AppLifecycleState.resumed) {
        _onAppResume();
      }
    });
    if (!_claimEntryProbed &&
        status == SessionStatus.live &&
        _rpcBridge != null) {
      _claimEntryProbed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _probeClaimEntry();
      });
    }
    final webDark = Theme.of(context).brightness == Brightness.dark;
    if (_appliedWebDark != webDark) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncWebTheme(webDark);
      });
    }

    final devices = ref.watch(deviceListProvider);
    final activeTab = ref.watch(activeTabProvider);
    final isActive =
        activeTab < devices.length && devices[activeTab].id == widget.device.id;

    return PopScope(
      canPop: !isActive,
      onPopInvokedWithResult: (didPop, _) {
        if (!isActive || didPop) return;
        final scaffoldState = _scaffoldKey.currentState;
        if (scaffoldState != null && scaffoldState.isEndDrawerOpen) {
          scaffoldState.closeEndDrawer();
          return;
        }
        if (scaffoldState != null && scaffoldState.isDrawerOpen) {
          scaffoldState.closeDrawer();
          return;
        }
        ref
            .read(activeTabProvider.notifier)
            .set(ref.read(deviceListProvider).length);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.tune),
          tooltip: l10n.manageTitle,
          onPressed: _goHome,
        ),
        title: Tooltip(
          message: l10n.sessionTitleTooltip(widget.device.displayName(l10n)),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _showSwitcher,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Led(status: status),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.device.displayName(l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        color: context.zt.textHi,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.expand_more,
                    size: 20,
                    color: context.zt.textLo,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: _loading
              ? const LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: Colors.transparent,
                )
              : const SizedBox(height: 2, width: double.infinity),
        ),
        actions: [
          _ToolboxEntryButton(
            device: widget.device,
            onAutomationPressed: _openAutomation,
            onClaimPressed: _openClaim,
            onUsagePressed: _openUsage,
          ),
          IconButton(
            icon: const Icon(Icons.article_outlined),
            tooltip: l10n.sessionsPanelTooltip,
            onPressed: _showSessionPanel,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refreshTooltip,
            onPressed: _manualReload,
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            child: _errorShown
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.zt.danger.withValues(alpha: 0.10),
                      border: Border(
                        left: BorderSide(color: context.zt.danger, width: 3),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 20,
                          color: context.zt.danger,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.statusError,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: context.zt.danger,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.errorBannerDetail,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.zt.textLo,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        _ErrorRetryButton(onPressed: _manualReload),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: ColoredBox(
              color: context.zt.bg,
              child: _dispatchPort == null
                  ? const SizedBox.expand()
                  : InAppWebView(
                      initialUrlRequest: _freshRequest(),
                      initialUserScripts: _userScripts(webDark),
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                        domStorageEnabled: true,
                        supportZoom: false,
                        transparentBackground: true,
                        useHybridComposition: false,
                      ),
                      onRenderProcessGone: (_, detail) {
                        debugPrint('[zr-resume] rendererGone detail=$detail');
                        _rendererGone = true;
                        if (!mounted) return;
                        if (ref.read(appLifecycleProvider) ==
                            AppLifecycleState.resumed) {
                          _rendererGone = false;
                          _manualReload();
                        }
                      },
                      onWebViewCreated: (controller) {
                        _controller = controller;
                        if (kDebugMode) {
                          InAppWebViewController.setWebContentsDebuggingEnabled(
                            true,
                          );
                          debugPrint(
                            '[zr-diag] webview created dev=${widget.device.id}',
                          );
                        }
                        _rpcBridge = RpcBridge(
                          deviceId: widget.device.id,
                          dispatch: _dispatchServer!,
                        );
                        controller.addJavaScriptHandler(
                          handlerName: 'zrEvents',
                          callback: (args) {
                            final body = args.isNotEmpty ? args.first : null;
                            if (body is String) _onBridgeMessage(body);
                            return null;
                          },
                        );
                        controller.addJavaScriptHandler(
                          handlerName: 'zrViewState',
                          callback: (args) {
                            final body = args.isNotEmpty ? args.first : null;
                            if (body is String) _onViewStateSync(body);
                            return null;
                          },
                        );
                        controller.addJavaScriptHandler(
                          handlerName: 'zrWs',
                          callback: (args) {
                            final body = args.isNotEmpty ? args.first : null;
                            if (body is String) _onWsEvent(body);
                            return null;
                          },
                        );
                        controller.addJavaScriptHandler(
                          handlerName: 'zrSvcResult',
                          callback: (args) {
                            final body = args.isNotEmpty ? args.first : null;
                            if (body is String) _rpcBridge?.onSvcResult(body);
                            return null;
                          },
                        );
                      },
                      onLoadStart: (_, _) {
                        if (mounted) {
                          setState(() {
                            _loading = true;
                            _errorShown = false;
                          });
                          _report(SessionStatus.loading);
                        _automationNotifier?.reportSubscribed(
                          widget.device.id,
                          false,
                        );
                        _rpcBridge?.resetOffPeakProbe();
                        _probeArmed = true;
                        _claimEntryProbed = false;
                        _claimEntryNotifier?.reset(widget.device.id);
                        }
                      },
                      onLoadStop: (_, _) {
                        if (mounted) {
                          setState(() => _loading = false);
                          _syncWebTheme(
                            Theme.of(context).brightness == Brightness.dark,
                          );
                        }
                      },
                      onReceivedError: (controller, request, error) async {
                        if (!mounted) return;
                        if (!PageLoadPolicy.isMainDocFailure(
                          request.isForMainFrame,
                        )) {
                          return;
                        }
                        setState(() => _loading = false);
                        await _onLoadError();
                      },
                      onReceivedHttpError:
                          (controller, request, errorResponse) async {
                            if (!mounted) return;
                            if (!PageLoadPolicy.isHttpFailure(
                              request.isForMainFrame,
                              errorResponse.statusCode,
                            )) {
                              return;
                            }
                            setState(() => _loading = false);
                            await _onLoadError();
                          },
                    ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _Led extends StatelessWidget {
  const _Led({required this.status});

  final SessionStatus? status;

  @override
  Widget build(BuildContext context) {
    return StatusLed(status: status, size: 8, showGlow: true);
  }
}
class _ToolboxEntryButton extends ConsumerWidget {
  const _ToolboxEntryButton({
    required this.device,
    required this.onAutomationPressed,
    required this.onClaimPressed,
    required this.onUsagePressed,
  });

  final RemoteDevice device;
  final VoidCallback onAutomationPressed;
  final VoidCallback onClaimPressed;
  final VoidCallback onUsagePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoBoard = ref.watch(automationProvider)[device.id];
    final claimReady = ref.watch(claimEntryProvider)[device.id] == true;
    final hasActiveNotice =
        (autoBoard?.queuedCount ?? 0) > 0 || claimReady;

    return IconButton(
      icon: Badge(
        isLabelVisible: hasActiveNotice,
        smallSize: 8,
        backgroundColor: context.zt.danger,
        child: const Icon(Icons.grid_view_rounded, size: 20),
      ),
      tooltip: AppLocalizations.of(context)!.toolboxTitle,
      onPressed: () => showToolboxSheet(
        context: context,
        device: device,
        onAutomationPressed: onAutomationPressed,
        onClaimPressed: onClaimPressed,
        onUsagePressed: onUsagePressed,
      ),
    );
  }
}

class ClaimEntryButton extends ConsumerWidget {
  const ClaimEntryButton({
    super.key,
    required this.deviceId,
    required this.onPressed,
  });

  final String deviceId;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(claimEntryProvider)[deviceId] == true;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: visible
          ? IconButton(
              key: const ValueKey('claim-entry-on'),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 36, height: 36),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Badge(
                backgroundColor: context.zt.accent,
                child: const Icon(Icons.card_giftcard, size: 20),
              ),
              tooltip: AppLocalizations.of(context)!.claimEntryTooltip,
              onPressed: onPressed,
            )
          : const SizedBox.shrink(key: ValueKey('claim-entry-off')),
    );
  }
}

class _ErrorRetryButton extends StatelessWidget {
  const _ErrorRetryButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: zt.danger.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: zt.danger.withValues(alpha: 0.30)),
        ),
        child: Text(
          AppLocalizations.of(context)!.retry,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: zt.danger,
          ),
        ),
      ),
    );
  }
}
