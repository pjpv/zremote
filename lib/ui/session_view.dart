import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device.dart';
import '../services/event_observer.dart';
import '../services/link_builder.dart';
import '../services/notifier.dart';
import '../state/app_lifecycle.dart';
import '../state/event_feed.dart';
import '../state/notification_prefs.dart';
import '../state/session_pool.dart';
import '../state/session_status.dart';
import '../theme.dart';
import 'unread_badge.dart';

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

  final StateDiffer _stateDiffer = StateDiffer();

  String? _activeSessionId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _statusNotifier ??= ref.read(sessionStatusProvider.notifier);
    _feedNotifier ??= ref.read(eventFeedProvider.notifier);
  }

  void _report(SessionStatus status) =>
      _statusNotifier?.report(widget.device.id, status);

  void _goHome() => ref
      .read(activeTabProvider.notifier)
      .set(ref.read(deviceListProvider).length);

  void _onBridgeMessage(String body) {
    if (!mounted) return;
    final activeSession = ActiveSessionExtractor.parse(body);
    if (activeSession != null) _activeSessionId = activeSession;

    final events = <ObservedEvent>[
      ...EventParser.parseMessage(body),
      ..._stateDiffer.apply(SessionStateExtractor.parse(body)),
    ];
    if (events.isEmpty) return;
    final devices = ref.read(deviceListProvider);
    final active = ref.read(activeTabProvider);
    final visibleId = active < devices.length ? devices[active].id : null;
    final appForeground =
        ref.read(appLifecycleProvider) == AppLifecycleState.resumed;
    final prefs = ref.read(notificationPrefsProvider);
    for (final event in events) {
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
      NotifierService.instance.notifyFrom(widget.device, event);
    }
  }

  URLRequest _freshRequest() =>
      URLRequest(url: WebUri(LinkBuilder.buildUrl(widget.device).toString()));

  Future<void> _manualReload() async {
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
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: ZT.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: ZT.hairline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              for (final d in devices)
                ListTile(
                  leading: _Led(status: ref.read(sessionStatusProvider)[d.id]),
                  title: Text(
                    d.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UnreadBadge(feed: ref.read(eventFeedProvider)[d.id]),
                      if (d.id == widget.device.id) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check, color: ZT.accent, size: 20),
                      ],
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    final index = ref.read(deviceListProvider).indexOf(d);
                    ref.read(activeTabProvider.notifier).set(index);
                  },
                ),
              const Divider(indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.tune, color: ZT.textLo),
                title: const Text('设备管理'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _goHome();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _statusNotifier?.forget(widget.device.id);
    _feedNotifier?.forget(widget.device.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(sessionStatusProvider)[widget.device.id];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.tune),
          tooltip: '设备管理',
          onPressed: _goHome,
        ),
        title: Tooltip(
          message: '切换设备',
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _showSwitcher,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Led(status: status),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.device.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 22, color: ZT.textLo),
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
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '刷新（重铸链接时间戳）',
            onPressed: _manualReload,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_errorShown)
            Container(
              width: double.infinity,
              color: ZT.danger.withValues(alpha: 0.10),
              padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: ZT.danger,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '连接异常',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: ZT.danger,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '自动重载未恢复；若持续失败，电脑端身份可能已轮换，请重新扫码导入',
                          style: TextStyle(fontSize: 12, color: ZT.textLo),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: ZT.textLo, size: 20),
                    tooltip: '重试',
                    onPressed: _manualReload,
                  ),
                ],
              ),
            ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: _freshRequest(),
              initialUserScripts: UnmodifiableListView([
                UserScript(
                  source: EventObserver.hookScript,
                  injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                ),
              ]),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                supportZoom: false,
                useHybridComposition: false,
              ),
              onWebViewCreated: (controller) {
                _controller = controller;
                controller.addJavaScriptHandler(
                  handlerName: 'zrEvents',
                  callback: (args) {
                    final body = args.isNotEmpty ? args.first : null;
                    if (body is String) _onBridgeMessage(body);
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
                }
              },
              onLoadStop: (_, _) {
                if (mounted) {
                  setState(() => _loading = false);
                  _report(SessionStatus.live);
                }
              },
              onReceivedError: (controller, request, error) async {
                if (mounted) setState(() => _loading = false);
                await _onLoadError();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Led extends StatelessWidget {
  const _Led({required this.status});

  final SessionStatus? status;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ZT.statusColor(status),
      ),
    );
  }
}
