import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/device.dart';
import '../models/device_label.dart';
import '../models/model_draft.dart';
import '../models/provider_settings.dart';
import '../services/event_observer.dart';
import '../services/rpc_bridge.dart';
import '../state/resume_reload.dart';
import '../state/service_readiness.dart';
import '../state/session_index.dart';
import '../state/session_status.dart';
import '../theme.dart';
import 'bevel_card.dart';
import 'hw_chip.dart';
import 'section_label.dart';
import 'sheet_shell.dart';
import 'showcase_bits.dart';
import 'status_led.dart';
import 'tactile_button.dart';

Map<String, dynamic> _asMap(Object? raw) =>
    raw is Map<String, dynamic> ? raw : const {};

class ModelSettingsPage extends ConsumerStatefulWidget {
  const ModelSettingsPage({
    super.key,
    required this.device,
    required this.bridge,
  });

  final RemoteDevice device;
  final RpcBridge bridge;

  @override
  ConsumerState<ModelSettingsPage> createState() => _ModelSettingsPageState();
}

enum _ModelPhase { loading, ready, error }

enum _ModelErrorKind { notReady, remote }

class _ModelSettingsPageState extends ConsumerState<ModelSettingsPage> {
  _ModelPhase _phase = _ModelPhase.loading;
  _ModelErrorKind _errorKind = _ModelErrorKind.notReady;
  String _errorMessage = '';
  bool _refreshing = false;

  ProviderSettingsView? _view;
  ZrConnectionSettings? _settings;
  bool _settingsFailed = false;
  UsageEntitlement? _entitlement;
  bool _entitlementFailed = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<RpcResponse> _callWithRetry(
    String channel,
    String method, {
    Object? params,
    Duration timeout = const Duration(seconds: 25),
  }) async {
    var attempt = 0;
    while (true) {
      attempt++;
      try {
        return await widget.bridge.call(
          channel,
          method,
          params: params,
          timeout: timeout,
        );
      } on RpcRemoteException catch (e) {
        final transient =
            e.message.contains('no-services') ||
            e.message.contains('no-method');
        if (!transient || attempt >= 3) rethrow;
      } on RpcNotReadyException {
        if (attempt >= 3) rethrow;
      } on RpcTimeoutException {
        if (attempt >= 3) rethrow;
      }
      debugPrint('[model] retry #$attempt for $channel.$method in 4s');
      await Future<void>.delayed(const Duration(seconds: 4));
    }
  }

  int _loadEpoch = 0;

  bool _awaitRecovery = false;

  Future<void> _refresh() async {
    if (_refreshing) return;
    _refreshing = true;
    final epoch = _loadEpoch;
    if (mounted) setState(() {});
    try {
      final r = await _callWithRetry('provider-settings', 'getView');
      final view = ProviderSettingsView.fromJson(r.firstObject ?? const {});
      if (!mounted || epoch != _loadEpoch) return;
      if (view == null) {
        setState(() {
          _phase = _ModelPhase.error;
          _errorKind = _ModelErrorKind.remote;
          _errorMessage = '';
        });
        return;
      }
      _view = view;
      setState(() => _phase = _ModelPhase.ready);
      debugPrint(
        '[model] getView ok (${view.providers.length} providers, '
        'rev=${view.revision})',
      );
      await _fetchSupporting(epoch);
    } on RpcRemoteException catch (e) {
      debugPrint('[model] getView remote error: ${e.message}');
      if (!mounted || epoch != _loadEpoch) return;
      if (e.message.contains('no-services')) {
        _toNotReady(epoch);
        return;
      }
      setState(() {
        _phase = _ModelPhase.error;
        _errorKind = _ModelErrorKind.remote;
        _errorMessage = e.message;
      });
    } on RpcNotReadyException {
      debugPrint('[model] getView notReady after retries');
      _toNotReady(epoch);
    } on RpcTimeoutException {
      debugPrint('[model] getView timeout after retries');
      _toNotReady(epoch);
    } catch (e) {
      debugPrint('[model] getView unexpected error $e');
      _toNotReady(epoch);
    } finally {
      if (epoch == _loadEpoch) {
        _refreshing = false;
        if (mounted) setState(() {});
      }
    }
  }

  void _restart() {
    _loadEpoch++;
    _refreshing = false;
    _refresh();
  }

  Future<void> _fetchSupporting(int epoch) async {
    try {
      final r = await _callWithRetry('setting', 'get');
      final j = r.firstObject;
      if (!mounted || epoch != _loadEpoch) return;
      setState(() {
        if (j != null) {
          _settings = ZrConnectionSettings.fromJson(j);
          _settingsFailed = false;
        } else {
          _settings = null;
          _settingsFailed = true;
        }
      });
    } catch (e) {
      debugPrint('[model] setting.get degraded: $e');
      if (mounted && epoch == _loadEpoch) {
        setState(() {
          _settings = null;
          _settingsFailed = true;
        });
      }
    }
    if (epoch != _loadEpoch) return;
    await _fetchEntitlement(epoch);
    try {
      final r = await _callWithRetry('model-selection', 'getView');
      if (epoch != _loadEpoch) return;
      final sel = ModelSelectionView.fromJson(r.firstObject ?? const {});
      debugPrint(
        '[model] selection getView '
        '${sel != null ? 'ok (${sel.providerIds.length} providers)' : 'empty'}',
      );
    } catch (e) {
      debugPrint('[model] selection getView degraded: $e');
    }
  }

  Future<void> _fetchEntitlement(int epoch) async {
    final view = _view;
    if (view == null) return;
    final provider = _pickEntitlementProvider();
    if (provider == null) {
      if (mounted && epoch == _loadEpoch) {
        setState(() { _entitlement = null; _entitlementFailed = false; });
      }
      return;
    }
    final access = provider.effectiveConfig!.access!;
    final params = {
      'includeSubscription': true,
      'preferredProviderId': provider.providerId,
      'accountAccess': <String, dynamic>{
        'type': access.type,
        if (access.accountType != null) 'accountType': access.accountType,
        if (access.mode != null) 'mode': access.mode,
        if (access.entitled != null) 'entitled': access.entitled,
      },
      'allowDisabledPreferredProvider': true,
      'requirePreferredProvider': true,
      'allowEnvApiKey': false,
    };
    try {
      final r = await _callWithRetry('usage-stats', 'getEntitlementSnapshot', params: params);
      final ent = UsageEntitlement.fromJson(r.firstObject ?? const {});
      if (!mounted || epoch != _loadEpoch) return;
      setState(() {
        _entitlement = ent;
        _entitlementFailed = ent == null;
      });
      debugPrint(
        '[model] entitlement '
        '${ent != null ? 'ok (${ent.limits.length} limits, plan=${ent.planName ?? "?"})' : 'empty'}',
      );
    } catch (e) {
      debugPrint('[model] entitlement degraded: $e');
      if (mounted && epoch == _loadEpoch) {
        setState(() { _entitlement = null; _entitlementFailed = true; });
      }
    }
  }

  ZrProvider? _pickEntitlementProvider() {
    final view = _view;
    if (view == null) return null;
    final entitled = view.entitledAccountProviders;
    if (entitled.isEmpty) return null;
    for (final family in _connFamilies()) {
      final current = _currentKind(family.family);
      if (current == null) continue;
      for (final opt in family.options) {
        if (opt.kind == current &&
            opt.provider.effectiveConfig?.access?.entitled == true) {
          return opt.provider;
        }
      }
    }
    return entitled.first;
  }

  void _toNotReady(int epoch) {
    if (!mounted || epoch != _loadEpoch) return;
    setState(() {
      _phase = _ModelPhase.error;
      _errorKind = _ModelErrorKind.notReady;
      _errorMessage = '';
    });
  }

  String? get _workspacePath {
    final sessions = ref.read(sessionIndexProvider)[widget.device.id];
    if (sessions != null && sessions.isNotEmpty) {
      SessionState? best;
      for (final s in sessions.values) {
        if (s.workspacePath == null || s.workspacePath!.isEmpty) continue;
        final bestAt = best?.lastActivityAt ?? best?.createdAt;
        final at = s.lastActivityAt ?? s.createdAt;
        if (best == null || (at ?? 0) >= (bestAt ?? 0)) best = s;
      }
      if (best?.workspacePath != null) return best!.workspacePath;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = ref.watch(sessionStatusProvider)[widget.device.id];
    final offline = status != SessionStatus.live;
    ref.listen(resumeReloadEpochProvider, (prev, next) {
      if (prev != next && mounted) _awaitRecovery = true;
    });
    ref.listen(sessionStatusProvider, (prev, next) {
      if (!mounted || prev?[widget.device.id] == next[widget.device.id]) {
        return;
      }
      if (next[widget.device.id] != SessionStatus.live) return;
      final stalled =
          _awaitRecovery ||
          (_phase == _ModelPhase.error && _errorKind == _ModelErrorKind.notReady);
      if (stalled) {
        _awaitRecovery = false;
        debugPrint('[model] live after reload -> restart');
        _restart();
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusLed(status: status, size: 8, showGlow: true),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.device.displayName(l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (_refreshing)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: l10n.modelRefresh,
              onPressed: _refresh,
            ),
        ],
        bottom: offline
            ? PreferredSize(
                preferredSize: const Size.fromHeight(36),
                child: Container(
                  width: double.infinity,
                  color: context.zt.danger.withValues(alpha: 0.10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 18,
                        color: context.zt.danger,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.modelDeviceNotReady,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.zt.textLo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: switch (_phase) {
        _ModelPhase.loading => const Center(child: CircularProgressIndicator()),
        _ModelPhase.error => _errorView(l10n, offline),
        _ModelPhase.ready => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _connectionsSection(l10n),
            const SizedBox(height: 16),
            _providersSection(l10n),
          ],
        ),
      },
    );
  }

  List<_ConnFamily> _connFamilies() {
    final view = _view;
    if (view == null) return const [];
    final families = <String, _ConnFamily>{};
    for (final p in view.providers) {
      final access = p.effectiveConfig?.access;
      if (access?.isAccount != true) continue;
      final family = access!.accountType;
      final mode = access.mode;
      if (family == null || family.isEmpty) continue;
      if (mode == null || mode.isEmpty) continue;
      if (access.entitled != true) continue;
      final fam = families.putIfAbsent(family, () => _ConnFamily(family));
      fam.options.add(_ConnOption(provider: p, family: family, kind: mode));
    }
    return families.values.toList();
  }

  String? _currentKind(String family) => _settings?.selections[family]?.kind;

  Widget _connectionsSection(AppLocalizations l10n) {
    final zt = context.zt;
    final families = _connFamilies();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(l10n.modelConnSectionTitle),
        if (_entitlement != null && !_entitlement!.noPlan)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _planCard(l10n),
          )
        else if (_entitlementFailed)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              l10n.modelPlanLoadFailed,
              style: TextStyle(fontSize: 11, color: zt.textTertiary),
            ),
          ),
        BevelCard(
          radius: 18,
          child: Column(
            children: [
              if (families.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.modelConnNone,
                      style: TextStyle(fontSize: 12, color: zt.textTertiary),
                    ),
                  ),
                )
              else
                for (var i = 0; i < families.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      color: zt.hairline,
                      indent: 14,
                      endIndent: 14,
                    ),
                  _familyTile(l10n, families[i]),
                ],
            ],
          ),
        ),
        if (_settingsFailed)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.modelConnLoadFailed,
              style: TextStyle(fontSize: 11, color: zt.textTertiary),
            ),
          ),
      ],
    );
  }

  Widget _familyTile(AppLocalizations l10n, _ConnFamily fam) {
    final zt = context.zt;
    final current = _currentKind(fam.family);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _familyLabel(fam.family),
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: zt.textHi,
                ),
              ),
              const SizedBox(width: 8),
              if (current == null && _settings != null)
                Text(
                  l10n.modelConnNone,
                  style: TextStyle(fontSize: 11, color: zt.textTertiary),
                ),
            ],
          ),
          const SizedBox(height: 4),
          for (final opt in fam.options) _connOptionRow(l10n, opt, current),
        ],
      ),
    );
  }

  Widget _connOptionRow(
    AppLocalizations l10n,
    _ConnOption opt,
    String? current,
  ) {
    final zt = context.zt;
    final unavailable = opt.provider.accountState?.unavailable ?? false;
    final isCurrent = current == opt.kind;
    final hasModels = opt.provider.models.isNotEmpty;

    return InkWell(
      onTap: hasModels ? () => _openProviderDetail(opt.provider) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _kindLabel(l10n, opt.kind),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: zt.textHi,
                ),
              ),
            ),
            if (hasModels)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  l10n.modelProviderModelsCount(opt.provider.models.length),
                  style: TextStyle(fontSize: 11, color: zt.textTertiary),
                ),
              ),
            if (isCurrent)
              HwChip(text: l10n.modelConnCurrent, color: zt.live)
            else if (unavailable)
              HwChip(text: l10n.modelConnUnavailable, color: zt.danger),
            if (hasModels) Icon(Icons.chevron_right, size: 18, color: zt.textLo),
          ],
        ),
      ),
    );
  }

  static String _familyLabel(String family) => switch (family) {
    'zai' => 'Z.ai',
    'bigmodel' => 'BigModel',
    _ => family,
  };

  String _kindLabel(AppLocalizations l10n, String kind) => switch (kind) {
    'individual-coding-plan' => l10n.modelConnPersonal,
    'team-coding-plan' => l10n.modelConnTeam,
    'start-plan' => l10n.modelConnStart,
    'off-peak' => l10n.modelConnOffPeak,
    _ => kind,
  };

  Widget _planCard(AppLocalizations l10n) {
    final zt = context.zt;
    final ent = _entitlement!;
    final rows = <_PlanQuotaRow>[
      for (final limit in ent.limits.take(6))
        _PlanQuotaRow(
          label: _limitLabel(l10n, limit),
          remainingPercent: limit.percentage == null
              ? null
              : (100 - limit.percentage!).clamp(0, 100),
          resetAt: limit.nextResetTime,
        ),
      if (ent.mcpUsedPercentage != null)
        _PlanQuotaRow(
          label: l10n.modelQuotaMcp,
          remainingPercent: (100 - ent.mcpUsedPercentage!).clamp(0, 100),
        ),
    ];
    return BevelCard(
      key: const Key('model-plan-card'),
      radius: 18,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ent.planName ?? l10n.modelPlanActive,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: zt.textHi,
                    ),
                  ),
                ),
                if (ent.quotaLevel != null)
                  HwChip(text: ent.quotaLevel!.toUpperCase(), color: zt.accent),
              ],
            ),
            if (rows.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (var i = 0; i < rows.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: i == rows.length - 1 ? 0 : 12),
                  child: _quotaRow(zt, rows[i]),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _quotaRow(ZTPalette zt, _PlanQuotaRow row) {
    final p = row.remainingPercent;
    final text = p == null
        ? '--'
        : p >= 10
        ? '${p.toStringAsFixed(0)}%'
        : '${p.toStringAsFixed(1)}%';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                row.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: zt.textLo),
              ),
            ),
            const SizedBox(width: 10),
            if (row.resetAt != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  _shortDate(row.resetAt!),
                  style: zrMono(fontSize: 10.5, color: zt.textTertiary),
                ),
              ),
            Text(
              text,
              style: zrMono(
                fontSize: 12.5,
                weight: FontWeight.w600,
                color: zt.textHi,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: p == null ? zt.hairline : zt.hairline.withValues(alpha: 0.6),
            ),
            child: p == null
                ? null
                : Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: (p / 100).clamp(0.0, 1.0),
                      heightFactor: 1.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: _quotaColor(zt, p),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  static Color _quotaColor(ZTPalette zt, num p) =>
      p >= 50 ? zt.live : p >= 20 ? zt.warn : zt.danger;

  String _limitLabel(AppLocalizations l10n, ZrQuotaLimit limit) {
    final type = limit.type ?? limit.meter ?? '';
    if (type.contains('TOKENS') && limit.number == 5) {
      return l10n.modelQuotaFiveHour;
    }
    if (type.contains('TOKENS') && limit.unit == 6) {
      return l10n.modelQuotaWeek;
    }
    if (type.contains('TIME')) return l10n.modelQuotaToolCalls;
    return type.isEmpty ? l10n.modelQuotaOther : type;
  }

  static String _shortDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$m-$day';
  }

  List<ZrProvider> _listProviders() {
    final view = _view;
    if (view == null) return const [];
    final list = [
      for (final p in view.providers)
        if (p.effectiveConfig?.access?.isAccount != true) p,
    ];
    list.sort((a, b) {
      final c = (b.enabled ? 1 : 0).compareTo(a.enabled ? 1 : 0);
      if (c != 0) return c;
      return a.displayName.compareTo(b.displayName);
    });
    return list;
  }

  Widget _providersSection(AppLocalizations l10n) {
    final zt = context.zt;
    final providers = _listProviders();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(l10n.modelProvidersSectionTitle),
        BevelCard(
          radius: 18,
          child: Column(
            children: [
              if (providers.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      l10n.modelProvidersEmpty,
                      style: TextStyle(fontSize: 13, color: zt.textLo),
                    ),
                  ),
                )
              else
                for (var i = 0; i < providers.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      color: zt.hairline,
                      indent: 58,
                      endIndent: 14,
                    ),
                  _providerTile(l10n, providers[i]),
                ],
              Divider(height: 1, color: zt.hairline, indent: 14, endIndent: 14),
              _addProviderTile(l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _providerTile(AppLocalizations l10n, ZrProvider p) {
    final zt = context.zt;
    final unavailable = p.accountState?.unavailable ?? false;
    final dimmed = !p.enabled && !unavailable;
    return InkWell(
      onTap: () => _openProviderDetail(p),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: dimmed
                    ? zt.textTertiary.withValues(alpha: 0.08)
                    : zt.accent.withValues(alpha: 0.10),
              ),
              child: Icon(
                p.isCustom ? Icons.tune_rounded : Icons.bolt_outlined,
                size: 16,
                color: dimmed ? zt.textTertiary : zt.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: dimmed ? zt.textTertiary : zt.textHi,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.modelProviderModelsCount(p.models.length),
                    style: TextStyle(
                      fontSize: 11.5,
                      color: dimmed ? zt.textTertiary : zt.textLo,
                    ),
                  ),
                ],
              ),
            ),
            if (unavailable)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: HwChip(
                  text: l10n.modelProviderUnavailable,
                  color: zt.danger,
                ),
              )
            else if (!p.enabled)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: HwChip(
                  text: l10n.modelProviderDisabled,
                  color: zt.textTertiary,
                ),
              ),
            Icon(Icons.chevron_right, color: zt.textLo),
          ],
        ),
      ),
    );
  }

  void _openProviderDetail(ZrProvider p) {
    showZrSheet<void>(
      context: context,
      builder: (_) => _ProviderDetailSheet(
        provider: p,
        bridge: widget.bridge,
        workspacePath: _workspacePath,
        revision: _view?.revision ?? 0,
        onViewUpdate: (view) {
          if (mounted) setState(() => _view = view);
        },
        onRefresh: _refresh,
      ),
    );
  }

  Widget _addProviderTile(AppLocalizations l10n) {
    final zt = context.zt;
    return InkWell(
      key: const Key('model-add-provider'),
      onTap: _openAddProvider,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: zt.accent.withValues(alpha: 0.10),
              ),
              child: Icon(Icons.add_rounded, size: 18, color: zt.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.modelProviderAdd,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: zt.textHi,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: zt.textLo),
          ],
        ),
      ),
    );
  }

  void _openAddProvider() {
    showZrSheet<void>(
      context: context,
      builder: (_) => _AddProviderSheet(
        bridge: widget.bridge,
        templates: _view?.providerTemplates ?? const [],
        onCreated: (view) {
          if (!mounted) return;
          if (view != null) {
            setState(() => _view = view);
          } else {
            _refresh();
          }
        },
      ),
    );
  }

  Widget _errorView(AppLocalizations l10n, bool offline) {
    final remote = _errorKind == _ModelErrorKind.remote;
    final readiness =
        ref.watch(serviceReadinessProvider)[widget.device.id] ??
        ServiceReadiness.unknown;
    final notReadyText = readiness == ServiceReadiness.unavailable
        ? l10n.sessionNotReadyHint
        : (offline ? l10n.modelDeviceNotReady : l10n.modelServiceUnavailable);
    final zt = context.zt;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: zt.accentSubtle,
                border: Border.all(color: zt.accentBorder, width: 1.2),
              ),
              child: Icon(
                remote ? Icons.error_outline : Icons.cloud_off_outlined,
                size: 32,
                color: zt.accent,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              remote ? l10n.modelLoadFailed : notReadyText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: zt.textHi,
              ),
            ),
            if (remote && _errorMessage.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                _errorMessage,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: zt.textLo),
              ),
            ],
            const SizedBox(height: 16),
            TactileButton(label: l10n.modelRefresh, onPressed: _refresh),
          ],
        ),
      ),
    );
  }
}

class _ConnFamily {
  _ConnFamily(this.family);

  final String family;
  final List<_ConnOption> options = [];
}

class _ConnOption {
  const _ConnOption({
    required this.provider,
    required this.family,
    required this.kind,
  });

  final ZrProvider provider;
  final String family;

  final String kind;
}

class _PlanQuotaRow {
  const _PlanQuotaRow({
    required this.label,
    required this.remainingPercent,
    this.resetAt,
  });

  final String label;
  final num? remainingPercent;
  final String? resetAt;
}

class _ProviderDetailSheet extends StatefulWidget {
  const _ProviderDetailSheet({
    required this.provider,
    required this.bridge,
    required this.workspacePath,
    required this.revision,
    required this.onViewUpdate,
    required this.onRefresh,
  });

  final ZrProvider provider;
  final RpcBridge bridge;
  final String? workspacePath;

  final int revision;

  final ValueChanged<ProviderSettingsView> onViewUpdate;

  final VoidCallback onRefresh;

  @override
  State<_ProviderDetailSheet> createState() => _ProviderDetailSheetState();
}

enum _TestOutcome { busy, ok, fail }

class _ProviderDetailSheetState extends State<_ProviderDetailSheet> {
  final Map<String, _TestOutcome> _tests = {};
  final Set<String> _toggleBusy = {};

  final Set<String> _rowBusy = {};
  String? _failMessage;

  late ZrProvider _provider = widget.provider;

  late int _revision = widget.revision;

  bool get _editable =>
      _provider.effectiveConfig?.access?.isApiKey == true;

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _applyReceipt(ProviderSettingsView view) {
    final receipt = view.byId(_provider.providerId);
    if (receipt != null) _provider = receipt;
    _revision = view.revision;
    widget.onViewUpdate(view);
  }

  Future<void> _addModel() async {
    final l10n = AppLocalizations.of(context)!;
    await showZrSheet<void>(
      context: context,
      builder: (_) => _ModelDraftSheet(
        provider: _provider,
        bridge: widget.bridge,
        model: null,
        revision: _revision,
        onSaved: (view) => _applyModelReceipt(view, l10n, l10n.modelModelAdded),
      ),
    );
  }

  Future<void> _editModel(ZrProviderModel m) async {
    final l10n = AppLocalizations.of(context)!;
    await showZrSheet<void>(
      context: context,
      builder: (_) => _ModelDraftSheet(
        provider: _provider,
        bridge: widget.bridge,
        model: m,
        revision: _revision,
        onSaved: (view) =>
            _applyModelReceipt(view, l10n, l10n.modelProviderSaved),
      ),
    );
  }

  void _applyModelReceipt(
    ProviderSettingsView view,
    AppLocalizations l10n,
    String okMessage,
  ) {
    if (view.byId(_provider.providerId) == null) {
      debugPrint('[model] modelDraft receipt unusable -> refresh');
      widget.onRefresh();
      if (mounted) _toast(l10n.modelModelSaveFailed);
      return;
    }
    if (!mounted) {
      widget.onViewUpdate(view);
      return;
    }
    setState(() => _applyReceipt(view));
    _toast(okMessage);
  }

  Future<void> _deleteModel(ZrProviderModel m) async {
    final l10n = AppLocalizations.of(context)!;
    if (_rowBusy.contains(m.modelId)) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.modelModelDeleteTitle),
        content: Text(l10n.modelModelDeleteBody(m.modelId)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.modelModelDeleteAction),
          ),
        ],
      ),
    );
    if (!mounted || ok != true) return;
    setState(() => _rowBusy.add(m.modelId));
    try {
      final r = await widget.bridge.callArgs(
        'provider-settings',
        'deletePersonalModel',
        args: [_provider.providerId, m.modelId],
      );
      debugPrint('[model] modelDelete ${_provider.providerId}/${m.modelId} ok');
      final view = ProviderSettingsView.fromJson(r.firstObject ?? const {});
      if (view == null || view.byId(_provider.providerId) == null) {
        debugPrint('[model] modelDelete receipt unusable');
        if (mounted) _toast(l10n.modelModelDeleteFailed);
        return;
      }
      if (!mounted) {
        widget.onViewUpdate(view);
        return;
      }
      setState(() => _applyReceipt(view));
      _toast(l10n.modelModelDeleted);
    } on RpcRemoteException catch (e) {
      debugPrint('[model] modelDelete fail: ${e.message}');
      if (mounted) _toast(l10n.modelModelDeleteFailed);
    } catch (e) {
      debugPrint('[model] modelDelete error $e');
      if (mounted) _toast(l10n.modelModelDeleteFailed);
    } finally {
      if (mounted) setState(() => _rowBusy.remove(m.modelId));
    }
  }

  void _openEditor() {
    showZrSheet<void>(
      context: context,
      builder: (_) => _EditProviderSheet(
        provider: _provider,
        bridge: widget.bridge,
        onSaved: (view) {
          if (!mounted) {
            widget.onViewUpdate(view);
            return;
          }
          setState(() => _applyReceipt(view));
          _toast(AppLocalizations.of(context)!.modelProviderSaved);
        },
        onDeleted: (view) {
          if (mounted) Navigator.pop(context);
          widget.onViewUpdate(view);
        },
      ),
    );
  }

  Future<void> _test(ZrProviderModel m) async {
    final ws = widget.workspacePath;
    if (ws == null || ws.isEmpty) return;
    if (_tests[m.modelId] == _TestOutcome.busy) return;
    setState(() {
      _tests[m.modelId] = _TestOutcome.busy;
      _failMessage = null;
    });
    try {
      final r = await widget.bridge.call(
        'provider-settings',
        'testModelConnectivity',
        params: {
          'workspacePath': ws,
          'providerId': widget.provider.providerId,
          'modelId': m.modelId,
        },
      );
      debugPrint(
        '[model] connectivity ${widget.provider.providerId}/'
        '${m.modelId} ok (${(r.values).length} values)',
      );
      if (mounted) setState(() => _tests[m.modelId] = _TestOutcome.ok);
    } on RpcRemoteException catch (e) {
      debugPrint('[model] connectivity fail: ${e.message}');
      if (mounted) {
        setState(() {
          _tests[m.modelId] = _TestOutcome.fail;
          _failMessage = e.message;
        });
      }
    } catch (e) {
      debugPrint('[model] connectivity error $e');
      if (mounted) {
        setState(() {
          _tests[m.modelId] = _TestOutcome.fail;
          _failMessage = '$e';
        });
      }
    }
  }

  Future<void> _toggleModel(ZrProviderModel m, bool enabled) async {
    if (_toggleBusy.contains(m.modelId)) return;
    setState(() {
      _toggleBusy.add(m.modelId);
      _failMessage = null;
      _provider = _withModelEnabled(_provider, m.modelId, enabled);
    });
    void toast(String msg) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg)));
    }

    final l10n = AppLocalizations.of(context)!;
    try {
      final r = await widget.bridge.callArgs(
        'provider-settings',
        'setPersonalModelEnabled',
        args: [widget.provider.providerId, m.modelId, enabled],
      );
      debugPrint(
        '[model] modelEnabled ${widget.provider.providerId}/'
        '${m.modelId}=$enabled ok (${r.values.length} values)',
      );
      final view = ProviderSettingsView.fromJson(r.firstObject ?? const {});
      final receipt = view?.byId(widget.provider.providerId);
      if (view == null || receipt == null) {
        debugPrint(
          '[model] modelEnabled receipt unusable '
          '(${view == null ? 'view unparseable' : 'provider missing'})',
        );
        if (mounted) {
          setState(() {
            _provider = _withModelEnabled(_provider, m.modelId, !enabled);
            _toggleBusy.remove(m.modelId);
          });
          toast(l10n.modelModelToggleFailed);
        }
        return;
      }
      widget.onViewUpdate(view);
      if (!mounted) return;
      setState(() {
        _provider = receipt;
        _toggleBusy.remove(m.modelId);
      });
    } on RpcRemoteException catch (e) {
      debugPrint('[model] modelEnabled fail: ${e.message}');
      if (mounted) {
        setState(() {
          _provider = _withModelEnabled(_provider, m.modelId, !enabled);
          _toggleBusy.remove(m.modelId);
        });
        toast(l10n.modelModelToggleFailed);
      }
    } catch (e) {
      debugPrint('[model] modelEnabled error $e');
      if (mounted) {
        setState(() {
          _provider = _withModelEnabled(_provider, m.modelId, !enabled);
          _toggleBusy.remove(m.modelId);
        });
        toast(l10n.modelModelToggleFailed);
      }
    }
  }

  static ZrProvider _withModelEnabled(
    ZrProvider p,
    String modelId,
    bool enabled,
  ) {
    final models = [
      for (final m in p.models)
        if (m.modelId == modelId)
          ZrProviderModel(
            modelId: m.modelId,
            kind: m.kind,
            builtin: m.builtin,
            selectable: m.selectable,
            executable: m.executable,
            enabled: enabled,
          )
        else
          m,
    ];
    return p.withModels(models);
  }

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final l10n = AppLocalizations.of(context)!;
    final p = _provider;
    final access = p.effectiveConfig?.access;
    final keySuffix = access?.apiKeySuffix;
    final wsReady =
        widget.workspacePath != null && widget.workspacePath!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    p.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: zt.textHi,
                    ),
                  ),
                ),
                if (p.accountState?.unavailable ?? false)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: HwChip(
                      text: l10n.modelProviderUnavailable,
                      color: zt.danger,
                    ),
                  )
                else if (!p.enabled)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: HwChip(
                      text: l10n.modelProviderDisabled,
                      color: zt.textTertiary,
                    ),
                  ),
                _SheetCloseButton(onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
          if (p.effectiveConfig?.baseUrl != null)
            _metaRow(
              l10n.modelDetailBaseUrl,
              _hostOf(p.effectiveConfig!.baseUrl!),
            ),
          if (keySuffix != null)
            _metaRow(l10n.modelDetailKeySuffix, '·$keySuffix'),
          if (_editable) ...[
            const SizedBox(height: 2),
            _editTile(l10n),
          ],
          const SizedBox(height: 6),
          if (!wsReady)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.modelTestNoWorkspace,
                style: TextStyle(fontSize: 11, color: zt.textTertiary),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.modelDetailModels,
                      style: zrMono(
                        fontSize: 11,
                        weight: FontWeight.w600,
                        color: zt.textLo,
                      ),
                    ),
                  ),
                  if (_failMessage != null)
                    Expanded(
                      flex: 2,
                      child: Text(
                        _failMessage!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 10, color: zt.danger),
                      ),
                    ),
                ],
              ),
            ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final m in p.models) _modelRow(l10n, m, wsReady),
                  if (p.models.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        l10n.modelProvidersEmpty,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: zt.textTertiary,
                        ),
                      ),
                    ),
                  if (_editable) _addModelRow(l10n),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    final zt = context.zt;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 11.5, color: zt.textTertiary)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: zrMono(fontSize: 11.5, color: zt.textLo),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editTile(AppLocalizations l10n) {
    final zt = context.zt;
    return InkWell(
      key: const Key('model-edit-provider'),
      onTap: _openEditor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Icon(Icons.tune_rounded, size: 15, color: zt.textLo),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.modelEditProvider,
                style: TextStyle(fontSize: 12.5, color: zt.textLo),
              ),
            ),
            Icon(Icons.chevron_right, size: 16, color: zt.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _addModelRow(AppLocalizations l10n) {
    final zt = context.zt;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: InkWell(
        key: const Key('model-add-model'),
        onTap: _addModel,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, size: 16, color: zt.accent),
              const SizedBox(width: 6),
              Text(
                l10n.modelAddModel,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: zt.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modelRow(AppLocalizations l10n, ZrProviderModel m, bool wsReady) {
    final zt = context.zt;
    final outcome = _tests[m.modelId];
    final toggling = _toggleBusy.contains(m.modelId);
    final dimmed = m.selectable == false || !m.enabled;
    final hint = m.issueMessage ??
        (m.configIncomplete ? l10n.modelModelIncomplete : null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
        children: [
          Expanded(
            child: Text(
              m.modelId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: zrMono(
                fontSize: 12,
                color: dimmed ? zt.textTertiary : zt.textHi,
              ),
            ),
          ),
          if (m.contextWindow != null) ...[
            const SizedBox(width: 6),
            HwChip(
              text: l10n.modelDraftContextWindowBadge(
                _compactCount(m.contextWindow!),
              ),
              color: zt.textTertiary,
            ),
          ],
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            height: 32,
            child: Center(
              child: switch (outcome) {
                _TestOutcome.busy => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                _TestOutcome.ok => HwChip(
                  text: l10n.modelTestOk,
                  color: zt.live,
                ),
                _TestOutcome.fail => HwChip(
                  text: l10n.modelTestFail,
                  color: zt.danger,
                ),
                null => SizedBox(
                  width: 76,
                  child: TactileButton(
                    label: l10n.modelTestConnection,
                    height: 32,
                    onPressed: wsReady && !dimmed ? () => _test(m) : null,
                  ),
                ),
              },
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 52,
            height: 32,
            child: Center(
              child: toggling
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Switch(
                      value: m.enabled,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (v) => _toggleModel(m, v),
                    ),
            ),
          ),
          if (_editable)
            SizedBox(
              width: 30,
              height: 32,
              child: Center(
                child: InkWell(
                  key: Key('model-edit-${m.modelId}'),
                  customBorder: const CircleBorder(),
                  onTap: () => _editModel(m),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.tune_rounded,
                      size: 16,
                      color: zt.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
          if (_editable && m.builtin != true)
            SizedBox(
              width: 30,
              height: 32,
              child: Center(
                child: _rowBusy.contains(m.modelId)
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : InkWell(
                        key: Key('model-del-${m.modelId}'),
                        customBorder: const CircleBorder(),
                        onTap: () => _deleteModel(m),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.delete_outline,
                            size: 17,
                            color: zt.textTertiary,
                          ),
                        ),
                      ),
              ),
            ),
        ],
          ),
          if (hint != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.5, color: zt.danger),
              ),
            ),
        ],
      ),
    );
  }

  static String _hostOf(String url) {
    final uri = Uri.tryParse(url);
    final host = uri?.host ?? '';
    return host.isNotEmpty ? host : url;
  }

  static String _compactCount(int value) {
    if (value >= 1000000) {
      final m = value / 1000000;
      return '${m == m.roundToDouble() ? m.round() : m.toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      final k = value / 1000;
      return '${k == k.roundToDouble() ? k.round() : k.toStringAsFixed(1)}K';
    }
    return '$value';
  }
}

class _SheetCloseButton extends StatelessWidget {
  const _SheetCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : zt.surfaceHover,
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : zt.hairline,
            width: 0.8,
          ),
        ),
        child: Icon(Icons.close_rounded, size: 15, color: zt.textLo),
      ),
    );
  }
}

class _AddProviderSheet extends StatefulWidget {
  const _AddProviderSheet({
    required this.bridge,
    required this.templates,
    required this.onCreated,
  });

  final RpcBridge bridge;

  final List<ZrProviderTemplate> templates;

  final ValueChanged<ProviderSettingsView?> onCreated;

  @override
  State<_AddProviderSheet> createState() => _AddProviderSheetState();
}

class _AddProviderSheetState extends State<_AddProviderSheet> {
  final TextEditingController _name = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _create({String? templateId}) async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context)!;
    final name = _name.text.trim();
    if (templateId == null && name.isEmpty) {
      setState(() => _error = l10n.modelProviderNameRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final localeTag = switch (Localizations.localeOf(context).languageCode) {
      'zh' => 'zh-CN',
      _ => 'en-US',
    };
    try {
      final r = await widget.bridge.call(
        'provider-settings',
        'createPersonalProvider',
        params: {
          'templateId': ?templateId,
          if (templateId == null) 'providerName': name,
          'locale': localeTag,
        },
      );
      debugPrint(
        '[model] provider create '
        '${templateId != null ? 'template=$templateId' : 'custom'} ok',
      );
      final map = r.firstObject ?? const {};
      final view = ProviderSettingsView.fromJson(
        map['view'] is Map<String, dynamic>
            ? map['view'] as Map<String, dynamic>
            : const {},
      );
      if (mounted) Navigator.pop(context);
      widget.onCreated(view);
    } on RpcRemoteException catch (e) {
      debugPrint('[model] provider create fail: ${e.message}');
      if (mounted) {
        setState(() {
          _busy = false;
          _error = e.message;
        });
      }
    } catch (e) {
      debugPrint('[model] provider create error $e');
      if (mounted) {
        setState(() {
          _busy = false;
          _error = '$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final l10n = AppLocalizations.of(context)!;
    final zhipu = [
      for (final t in widget.templates)
        if (t.isZhipuFamily) t,
    ];
    final others = [
      for (final t in widget.templates)
        if (!t.isZhipuFamily) t,
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.modelProviderAdd,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: zt.textHi,
                      ),
                    ),
                  ),
                  _SheetCloseButton(onTap: () => Navigator.pop(context)),
                ],
              ),
            ),
            TextField(
              key: const Key('model-provider-name'),
              controller: _name,
              enabled: !_busy,
              style: const TextStyle(fontSize: 13.5),
              decoration: zrInputDecoration(
                context,
                hint: l10n.modelProviderNameHint,
              ),
              onSubmitted: (_) => _create(),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(fontSize: 11.5, color: zt.danger),
                ),
              ),
            const SizedBox(height: 10),
            TactileButton(
              key: const Key('model-provider-create'),
              label: l10n.modelProviderCreateAction,
              onPressed: _busy ? null : () => _create(),
            ),
            if (zhipu.isNotEmpty) ...[
              const SizedBox(height: 16),
              _groupLabel(l10n.modelTemplateGroupZhipu),
              for (final t in zhipu) _templateTile(zt, t),
            ],
            if (others.isNotEmpty) ...[
              const SizedBox(height: 10),
              _groupLabel(l10n.modelTemplateGroupOther),
              for (final t in others) _templateTile(zt, t),
            ],
          ],
        ),
      ),
    );
  }

  Widget _groupLabel(String text) {
    final zt = context.zt;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: zrMono(fontSize: 11, weight: FontWeight.w600, color: zt.textLo),
      ),
    );
  }

  Widget _templateTile(ZTPalette zt, ZrProviderTemplate t) {
    return InkWell(
      key: Key('model-template-${t.templateId}'),
      onTap: _busy ? null : () => _create(templateId: t.templateId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Icon(Icons.bolt_outlined, size: 16, color: zt.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.displayName(
                  Localizations.localeOf(context).languageCode == 'zh'
                      ? 'zh-CN'
                      : 'en-US',
                ),
                style: TextStyle(fontSize: 13, color: zt.textHi),
              ),
            ),
            Icon(Icons.chevron_right, size: 16, color: zt.textTertiary),
          ],
        ),
      ),
    );
  }
}

const _apiFormats = <String, String>{
  'anthropic-messages': 'Anthropic Messages',
  'openai-chat-completions': 'OpenAI Chat Completions',
  'openai-responses': 'OpenAI Responses',
};

class _EditProviderSheet extends StatefulWidget {
  const _EditProviderSheet({
    required this.provider,
    required this.bridge,
    required this.onSaved,
    required this.onDeleted,
  });

  final ZrProvider provider;
  final RpcBridge bridge;

  final ValueChanged<ProviderSettingsView> onSaved;

  final ValueChanged<ProviderSettingsView> onDeleted;

  @override
  State<_EditProviderSheet> createState() => _EditProviderSheetState();
}

class _EditProviderSheetState extends State<_EditProviderSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.provider.displayName,
  );
  final TextEditingController _key = TextEditingController();
  late final TextEditingController _baseUrl = TextEditingController(
    text: widget.provider.effectiveConfig?.baseUrl ?? '',
  );
  late String _format =
      widget.provider.effectiveConfig?.apiType ?? 'anthropic-messages';
  bool _keyVisible = false;
  bool _busy = false;
  bool _deleting = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _key.dispose();
    _baseUrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context)!;
    final p = widget.provider;
    final cfg = p.effectiveConfig;
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.modelProviderNameRequired);
      return;
    }
    final key = _key.text.trim();
    final baseUrl = _normalizeBaseUrl(_baseUrl.text);
    final nameChanged = name != p.displayName;
    final keyChanged = key.isNotEmpty;
    final formatChanged = _format != (cfg?.apiType ?? 'anthropic-messages');
    final baseUrlChanged = baseUrl != (cfg?.baseUrl ?? '');
    if (!nameChanged && !keyChanged && !formatChanged && !baseUrlChanged) {
      Navigator.pop(context);
      return;
    }
    final overlay = Map<String, dynamic>.from(p.personalConfig);
    if (keyChanged) {
      final prevAccess = overlay['access'];
      overlay['access'] = <String, dynamic>{
        ...(prevAccess is Map<String, dynamic> ? prevAccess : const {}),
        'type': cfg!.access!.type,
        'apiKey': key,
      };
    }
    if (formatChanged || baseUrlChanged) {
      final prevApi = overlay['api'];
      final api = <String, dynamic>{
        ...(prevApi is Map<String, dynamic> ? prevApi : const {}),
      };
      if (baseUrlChanged) {
        if (baseUrl.isEmpty) {
          api.remove('baseUrl');
        } else {
          api['baseUrl'] = baseUrl;
        }
      }
      if (formatChanged || (baseUrlChanged && cfg?.apiType == null)) {
        api['type'] = _format;
      }
      overlay['api'] = api;
    }
    final meta = <String, dynamic>{if (nameChanged) 'providerName': name};
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final r = await widget.bridge.callArgs(
        'provider-settings',
        'savePersonalProviderOverlay',
        args: meta.isEmpty ? [p.providerId, overlay] : [p.providerId, overlay, meta],
      );
      debugPrint('[model] providerOverlay ${p.providerId} ok');
      final view = ProviderSettingsView.fromJson(r.firstObject ?? const {});
      if (view == null || view.byId(p.providerId) == null) {
        debugPrint('[model] providerOverlay receipt unusable');
        if (mounted) {
          setState(() {
            _busy = false;
            _error = l10n.modelProviderSaveFailed;
          });
        }
        return;
      }
      if (mounted) Navigator.pop(context);
      widget.onSaved(view);
    } on RpcRemoteException catch (e) {
      debugPrint('[model] providerOverlay fail (${e.label})');
      if (mounted) {
        setState(() {
          _busy = false;
          _error = l10n.modelProviderSaveFailed;
        });
      }
    } catch (e) {
      debugPrint('[model] providerOverlay error ${e.runtimeType}');
      if (mounted) {
        setState(() {
          _busy = false;
          _error = l10n.modelProviderSaveFailed;
        });
      }
    }
  }

  static String _normalizeBaseUrl(String raw) {
    final trimmed = raw.trim().replaceAll(RegExp(r'/+$'), '');
    if (trimmed.isEmpty) return '';
    final uri = Uri.tryParse(trimmed);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return trimmed;
    }
    final authority = uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
    final origin = '${uri.scheme}://$authority';
    final second = trimmed.indexOf(origin, origin.length);
    if (second < 0) return trimmed;
    final head = trimmed.substring(0, second).replaceAll(RegExp(r'/+$'), '');
    final tail = trimmed.substring(second).replaceAll(RegExp(r'/+$'), '');
    return head == tail ? head : trimmed;
  }

  Future<void> _delete() async {
    if (_deleting) return;
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.modelProviderDeleteTitle),
        content: Text(
          l10n.modelProviderDeleteBody(widget.provider.displayName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.modelProviderDeleteAction),
          ),
        ],
      ),
    );
    if (!mounted || ok != true) return;
    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      final r = await widget.bridge.callArgs(
        'provider-settings',
        'deletePersonalProvider',
        args: [widget.provider.providerId],
      );
      debugPrint('[model] providerDelete ${widget.provider.providerId} ok');
      final view = ProviderSettingsView.fromJson(r.firstObject ?? const {});
      if (view == null) {
        debugPrint('[model] providerDelete receipt unusable');
        if (mounted) {
          setState(() {
            _deleting = false;
            _error = l10n.modelProviderDeleteFailed;
          });
        }
        return;
      }
      if (mounted) Navigator.pop(context);
      widget.onDeleted(view);
    } on RpcRemoteException catch (e) {
      debugPrint('[model] providerDelete fail: ${e.message}');
      if (mounted) {
        setState(() {
          _deleting = false;
          _error = e.message;
        });
      }
    } catch (e) {
      debugPrint('[model] providerDelete error $e');
      if (mounted) {
        setState(() {
          _deleting = false;
          _error = '$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.modelEditProvider,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: zt.textHi,
                      ),
                    ),
                  ),
                  _SheetCloseButton(onTap: () => Navigator.pop(context)),
                ],
              ),
            ),
            TextField(
              key: const Key('model-edit-name'),
              controller: _name,
              enabled: !_busy && !_deleting,
              style: const TextStyle(fontSize: 13.5),
              decoration: zrInputDecoration(
                context,
                hint: l10n.modelProviderNameHint,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              key: const Key('model-edit-key'),
              controller: _key,
              enabled: !_busy && !_deleting,
              obscureText: !_keyVisible,
              autocorrect: false,
              enableSuggestions: false,
              style: zrMono(fontSize: 12.5),
              decoration: zrInputDecoration(
                context,
                hint: l10n.modelProviderKeyHint,
              ).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _keyVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: zt.textTertiary,
                  ),
                  onPressed: () => setState(() => _keyVisible = !_keyVisible),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              key: const Key('model-edit-baseurl'),
              controller: _baseUrl,
              enabled: !_busy && !_deleting,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.url,
              style: zrMono(fontSize: 12.5),
              decoration: zrInputDecoration(
                context,
                hint: l10n.modelProviderBaseUrlHint,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.modelProviderApiFormat,
              style: zrMono(
                fontSize: 11,
                weight: FontWeight.w600,
                color: zt.textLo,
              ),
            ),
            const SizedBox(height: 4),
            for (final entry in _apiFormats.entries)
              InkWell(
                key: Key('model-format-${entry.key}'),
                onTap: (_busy || _deleting)
                    ? null
                    : () => setState(() => _format = entry.key),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      Icon(
                        _format == entry.key
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 16,
                        color: _format == entry.key
                            ? zt.accent
                            : zt.textTertiary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(fontSize: 12.5, color: zt.textHi),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(fontSize: 11.5, color: zt.danger),
                ),
              ),
            const SizedBox(height: 12),
            TactileButton(
              key: const Key('model-edit-save'),
              label: l10n.commonSave,
              onPressed: (_busy || _deleting) ? null : _save,
            ),
            const SizedBox(height: 8),
            InkWell(
              key: const Key('model-provider-delete'),
              onTap: (_busy || _deleting) ? null : _delete,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _deleting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.delete_outline, size: 16, color: zt.danger),
                    const SizedBox(width: 6),
                    Text(
                      l10n.modelProviderDeleteAction,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: zt.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelDraftSheet extends StatefulWidget {
  const _ModelDraftSheet({
    required this.provider,
    required this.bridge,
    required this.model,
    required this.revision,
    required this.onSaved,
  });

  final ZrProvider provider;
  final RpcBridge bridge;

  final ZrProviderModel? model;

  final int revision;

  final ValueChanged<ProviderSettingsView> onSaved;

  @override
  State<_ModelDraftSheet> createState() => _ModelDraftSheetState();
}

class _ModelDraftSheetState extends State<_ModelDraftSheet> {
  late ZrModelDraft _draft;
  late final TextEditingController _id;
  late final TextEditingController _cw;
  late final TextEditingController _mo;
  late final TextEditingController _map;
  late final List<TextEditingController> _levels;
  late final TextEditingController _newLevel;

  String? get _originalModelId =>
      (!_isAdd && _draft.useRecommendedConfig && !_draft.clearPersonalConfig)
      ? widget.model!.modelId
      : null;

  String? _resolvedId;
  String? _resolvingId;
  Future<void>? _resolveInFlight;
  bool _resolving = false;
  bool _saving = false;
  String? _error;

  bool get _isAdd => widget.model == null;

  @override
  void initState() {
    super.initState();
    _draft = _isAdd
        ? ZrModelDraft.candidate()
        : ZrModelDraft.forModel(widget.model!);
    _id = TextEditingController(text: _draft.modelId);
    _cw = TextEditingController(text: _draft.contextWindow);
    _mo = TextEditingController(text: _draft.maxOutputTokens);
    _map = TextEditingController(text: _draft.reasoningLevelMap);
    _levels = [
      for (final lv in _draft.reasoningLevels) TextEditingController(text: lv),
    ];
    _newLevel = TextEditingController();
  }

  @override
  void dispose() {
    _id.dispose();
    _cw.dispose();
    _mo.dispose();
    _map.dispose();
    _newLevel.dispose();
    for (final c in _levels) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _resolve() {
    final id = _id.text.trim();
    if (id.isEmpty || !_draft.useRecommendedConfig) return Future.value();
    if (_originalModelId != null && id == _originalModelId) return Future.value();
    if (id == _resolvedId) return Future.value();
    final inFlight = _resolveInFlight;
    if (inFlight != null && _resolvingId == id) return inFlight;
    return _resolveInFlight = _fetchRecommended(id);
  }

  Future<void> _fetchRecommended(String id) async {
    setState(() {
      _resolving = true;
      _resolvingId = id;
    });
    try {
      final r = await widget.bridge.call(
        'provider-settings',
        'resolveModelConfig',
        params: {'providerId': widget.provider.providerId, 'modelId': id},
      );
      final obj = r.firstObject;
      final inherited = obj == null ? null : obj['inheritedConfig'];
      if (!mounted) return;
      if (inherited is! Map<String, dynamic>) {
        debugPrint('[model] resolveModelConfig no inheritedConfig');
        return;
      }
      final issues = obj?['issues'];
      debugPrint(
        '[model] resolveModelConfig $id ok '
        '(${issues is List ? issues.length : 0} issues)',
      );
      setState(() {
        _resolvedId = id;
        _draft = _draft.resolved(inherited);
        _applyDraft();
      });
    } catch (e) {
      debugPrint('[model] resolveModelConfig error ${e.runtimeType}');
    } finally {
      _resolveInFlight = null;
      _resolvingId = null;
      if (mounted) setState(() => _resolving = false);
    }
  }

  void _syncLevels() {
    while (_levels.length > _draft.reasoningLevels.length) {
      _levels.removeLast().dispose();
    }
    while (_levels.length < _draft.reasoningLevels.length) {
      _levels.add(TextEditingController());
    }
    for (var i = 0; i < _levels.length; i++) {
      _levels[i].text = _draft.reasoningLevels[i];
    }
  }

  void _pullDraft() {
    _draft = _draft.copyWith(
      modelId: _id.text,
      contextWindow: _cw.text,
      maxOutputTokens: _mo.text,
      reasoningLevelMap: _map.text,
      reasoningLevels: [for (final c in _levels) c.text],
    );
  }

  void _onField(void Function() mutate) {
    setState(() {
      _pullDraft();
      mutate();
      _error = null;
    });
  }

  void _applyDraft() {
    _cw.text = _draft.contextWindow;
    _mo.text = _draft.maxOutputTokens;
    _map.text = _draft.reasoningLevelMap;
    _syncLevels();
  }

  void _toggleSmart(bool on) => _onField(() {
    _draft = _draft.withSmartConfig(on);
    _applyDraft();
  });

  Future<void> _save() async {
    if (_saving) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _pullDraft();
      _error = null;
      _saving = true;
    });
    final pendingId = _draft.modelId.trim();
    final needsResolve =
        _draft.useRecommendedConfig &&
        pendingId.isNotEmpty &&
        (_originalModelId == null || pendingId != _originalModelId);
    if (needsResolve && pendingId != _resolvedId) {
      await _resolve();
      if (!mounted) return;
      setState(() => _pullDraft());
    }
    final field = _draft.validate();
    if (field != null) {
      debugPrint('[model] modelDraft invalid: $field');
      setState(() {
        _error = _messageFor(l10n, field);
        _saving = false;
      });
      return;
    }
    if (!_isAdd && _draft.isNoopAgainst(widget.model!)) {
      Navigator.pop(context);
      return;
    }
    try {
      final overlay = _draft.buildPersonalConfig();
      final modelId = _draft.modelId.trim();
      final r = _isAdd
          ? await widget.bridge.callArgs(
              'provider-settings',
              'addPersonalModel',
              args: [
                widget.provider.providerId,
                modelId,
                overlay,
                _draft.useRecommendedConfig,
              ],
            )
          : await widget.bridge.call(
              'provider-settings',
              'savePersonalModelDraft',
              params: {
                'providerId': widget.provider.providerId,
                'originalModelId': widget.model!.modelId,
                'nextModelId': modelId,
                'personalConfig': overlay,
                'useRecommendedConfig': _draft.useRecommendedConfig,
                'basedOnRevision': widget.revision,
              },
            );
      debugPrint(
        '[model] modelDraft ${_isAdd ? 'add' : 'save'} '
        '${widget.provider.providerId}/$modelId ok',
      );
      final view = ProviderSettingsView.fromJson(r.firstObject ?? const {});
      if (view == null) {
        debugPrint('[model] modelDraft receipt unusable');
        if (mounted) {
          setState(() {
            _saving = false;
            _error = l10n.modelModelSaveFailed;
          });
        }
        return;
      }
      if (mounted) Navigator.pop(context);
      widget.onSaved(view);
    } on RpcRemoteException catch (e) {
      debugPrint('[model] modelDraft fail: ${e.message}');
      if (mounted) {
        setState(() {
          _saving = false;
          _error = l10n.modelModelSaveFailed;
        });
      }
    } catch (e) {
      debugPrint('[model] modelDraft error ${e.runtimeType}');
      if (mounted) {
        setState(() {
          _saving = false;
          _error = l10n.modelModelSaveFailed;
        });
      }
    }
  }

  static String _messageFor(AppLocalizations l10n, String field) =>
      switch (ZrModelDraft.errorFieldKey(field)) {
        'id' => l10n.modelDraftInvalidId,
        'contextWindow' => l10n.modelDraftInvalidContextWindow,
        'maxOutputTokens' => l10n.modelDraftInvalidMaxOutputTokens,
        'inputModalities' => l10n.modelDraftInvalidInputModalities,
        'reasoningLevelValues' => l10n.modelDraftInvalidReasoningLevelValues,
        _ => l10n.modelDraftInvalidReasoningLevelMap,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final zt = context.zt;
    final smart = _draft.useRecommendedConfig;
    final inheritedProps = _asMap(_draft.inheritedConfig['properties']);
    final inheritedSpecs = _asMap(_draft.inheritedConfig['optionSpecs']);
    final inheritedMaxOut = _asMap(inheritedSpecs['maxOutputTokens']);
    final inheritedLevels = _asMap(inheritedSpecs['reasoningLevel']);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isAdd ? l10n.modelAddModel : l10n.modelDraftEditTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: zt.textHi,
                      ),
                    ),
                  ),
                  _SheetCloseButton(
                    onTap: () {
                      if (!_saving) Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      key: const Key('model-draft-smart'),
                      onTap: _saving ? null : () => _toggleSmart(!smart),
                      child: Text(
                        l10n.modelDraftSmartConfig,
                        style: TextStyle(fontSize: 12.5, color: zt.textLo),
                      ),
                    ),
                  ),
                  Switch(
                    key: const Key('model-draft-smart-switch'),
                    value: smart,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: _saving ? null : _toggleSmart,
                  ),
                ],
              ),
            ),
            _helpText(l10n.modelDraftSmartConfigHelp),
            const SizedBox(height: 10),
            _fieldLabel(l10n.modelDraftModelId),
            TextField(
              key: const Key('model-draft-id'),
              controller: _id,
              enabled: !_saving,
              readOnly: _draft.builtin,
              autocorrect: false,
              enableSuggestions: false,
              style: zrMono(fontSize: 12.5),
              decoration: zrInputDecoration(
                context,
                hint: l10n.modelDraftModelId,
              ),
              onChanged: (v) => _onField(() {}),
              onEditingComplete: () {
                _onField(() {});
                _resolve();
              },
              onTapOutside: (_) {
                _onField(() {});
                _resolve();
              },
            ),
            const SizedBox(height: 10),
            _fieldLabel(
              l10n.modelDraftContextWindow,
              overridden: _draft.showsOverride('contextWindowValue'),
            ),
            TextField(
              key: const Key('model-draft-context-window'),
              controller: _cw,
              enabled: !_saving,
              keyboardType: TextInputType.number,
              style: zrMono(fontSize: 12.5),
              decoration: zrInputDecoration(
                context,
                hint: smart && inheritedProps['contextWindow'] != null
                    ? '${inheritedProps['contextWindow']}'
                    : '',
              ),
              onChanged: (v) => _onField(() {}),
            ),
            _helpText(l10n.modelDraftContextWindowHelp),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _fieldLabel(
                    l10n.modelDraftMaxOutputTokens,
                    overridden: _draft.showsOverride('maxOutputTokensValue'),
                  ),
                ),
                if (_resolving)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            TextField(
              key: const Key('model-draft-max-output'),
              controller: _mo,
              enabled: !_saving,
              keyboardType: TextInputType.number,
              style: zrMono(fontSize: 12.5),
              decoration: zrInputDecoration(
                context,
                hint: smart && inheritedMaxOut['max'] != null
                    ? '${inheritedMaxOut['max']}'
                    : '',
              ),
              onChanged: (v) => _onField(() {}),
            ),
            _helpText(l10n.modelDraftMaxOutputTokensHelp),
            const SizedBox(height: 12),
            _fieldLabel(l10n.modelDraftInputModalities),
            const SizedBox(height: 2),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _modalityChip(
                  label: l10n.modelModalityText,
                  selected: true,
                  enabled: false,
                  onTap: null,
                ),
                _modalityChip(
                  key: const Key('model-draft-modality-image'),
                  label: l10n.modelModalityImage,
                  selected: _draft.supportsImage,
                  enabled: !_saving,
                  overridden: _draft.showsOverride('inputFormatValue.supportsImage'),
                  onTap: () => _onField(
                    () => _draft = _draft.changed(
                      supportsImage: !_draft.supportsImage,
                    ),
                  ),
                ),
                _modalityChip(
                  key: const Key('model-draft-modality-video'),
                  label: l10n.modelModalityVideo,
                  selected: _draft.supportsVideo,
                  enabled: !_saving,
                  overridden: _draft.showsOverride('inputFormatValue.supportsVideo'),
                  onTap: () => _onField(
                    () => _draft = _draft.changed(
                      supportsVideo: !_draft.supportsVideo,
                    ),
                  ),
                ),
                _modalityChip(
                  key: const Key('model-draft-modality-pdf'),
                  label: l10n.modelModalityPdf,
                  selected: _draft.supportsPdf,
                  enabled: !_saving,
                  overridden: _draft.showsOverride('inputFormatValue.supportsPdf'),
                  onTap: () => _onField(
                    () => _draft = _draft.changed(supportsPdf: !_draft.supportsPdf),
                  ),
                ),
              ],
            ),
            _helpText(l10n.modelDraftInputModalitiesHelp),
            const SizedBox(height: 12),
            _fieldLabel(l10n.modelDraftCapabilities),
            const SizedBox(height: 2),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _modalityChip(
                  key: const Key('model-draft-cap-json-schema'),
                  label: l10n.modelDraftCapabilityJsonSchema,
                  selected: _draft.supportsJsonSchemaOutput,
                  enabled: !_saving,
                  overridden: _draft.showsOverride(
                    'supportsJsonSchemaOutputValue',
                  ),
                  onTap: () => _onField(
                    () => _draft = _draft.changed(
                      supportsJsonSchemaOutput: !_draft.supportsJsonSchemaOutput,
                    ),
                  ),
                ),
                _modalityChip(
                  key: const Key('model-draft-cap-web-search'),
                  label: l10n.modelDraftCapabilityWebSearch,
                  selected: _draft.supportsNativeWebSearch,
                  enabled: !_saving,
                  overridden: _draft.showsOverride(
                    'supportsNativeWebSearchValue',
                  ),
                  onTap: () => _onField(
                    () => _draft = _draft.changed(
                      supportsNativeWebSearch: !_draft.supportsNativeWebSearch,
                    ),
                  ),
                ),
                _modalityChip(
                  key: const Key('model-draft-cap-mid-system'),
                  label: l10n.modelDraftCapabilityMidSystem,
                  selected: _draft.supportsMidConversationSystem,
                  enabled: !_saving,
                  overridden: _draft.showsOverride(
                    'supportsMidConversationSystemValue',
                  ),
                  onTap: () => _onField(
                    () => _draft = _draft.changed(
                      supportsMidConversationSystem:
                          !_draft.supportsMidConversationSystem,
                    ),
                  ),
                ),
              ],
            ),
            _helpText(l10n.modelDraftCapabilitiesHelp),
            const SizedBox(height: 12),
            _fieldLabel(l10n.modelDraftReasoning),
            const SizedBox(height: 4),
            _fieldLabel(
              l10n.modelDraftReasoningLevels,
              overridden: _draft.showsOverride('reasoningLevelValuesValue'),
            ),
            for (var i = 0; i < _levels.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: Key('model-draft-level-$i'),
                        controller: _levels[i],
                        enabled: !_saving,
                        style: zrMono(fontSize: 12),
                        decoration: zrInputDecoration(context, hint: 'low'),
                        onChanged: (v) => _onField(() {}),
                      ),
                    ),
                    InkWell(
                      key: Key('model-draft-level-del-$i'),
                      customBorder: const CircleBorder(),
                      onTap: _saving
                          ? null
                          : () => _onField(() {
                              _levels.removeAt(i).dispose();
                            }),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.remove_circle_outline,
                          size: 16,
                          color: zt.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            InkWell(
              key: const Key('model-draft-level-add'),
              onTap: _saving
                  ? null
                  : () => _onField(() {
                      _levels.add(TextEditingController());
                    }),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.add_rounded, size: 15, color: zt.accent),
                    const SizedBox(width: 4),
                    Text(
                      l10n.modelDraftReasoningLevelAdd,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: zt.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _helpText(l10n.modelDraftReasoningLevelsHelp),
            const SizedBox(height: 8),
            _fieldLabel(
              l10n.modelDraftReasoningMapping,
              overridden: _draft.showsOverride('reasoningLevelMapValue'),
            ),
            TextField(
              key: const Key('model-draft-reasoning-map'),
              controller: _map,
              enabled: !_saving,
              maxLines: 4,
              style: zrMono(fontSize: 11.5),
              decoration: zrInputDecoration(
                context,
                hint: inheritedLevels['map'] is String
                    ? inheritedLevels['map'] as String
                    : '',
              ),
              onChanged: (v) => _onField(() {}),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  key: const Key('model-draft-error'),
                  style: TextStyle(fontSize: 11.5, color: zt.danger),
                ),
              ),
            const SizedBox(height: 12),
            TactileButton(
              key: const Key('model-draft-save'),
              label: l10n.commonSave,
              onPressed: _saving ? null : _save,
            ),
            const SizedBox(height: 6),
            InkWell(
              key: const Key('model-draft-restore'),
              onTap: _saving
                  ? null
                  : () => _onField(() {
                      _draft = _draft.restored();
                      _applyDraft();
                    }),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.modelDraftRestoreDefault,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: zt.textTertiary,
                    decoration: TextDecoration.underline,
                    decorationColor: zt.textTertiary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text, {bool overridden = false}) {
    final zt = context.zt;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 11.5, color: zt.textLo),
          ),
          if (overridden) ...[
            const SizedBox(width: 6),
            HwChip(
              text: AppLocalizations.of(context)!.modelDraftOverridden,
              color: zt.accent,
            ),
          ],
        ],
      ),
    );
  }

  Widget _helpText(String text) {
    final zt = context.zt;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.5, height: 1.35, color: zt.textTertiary),
      ),
    );
  }

  Widget _modalityChip({
    Key? key,
    required String label,
    required bool selected,
    required bool enabled,
    bool overridden = false,
    VoidCallback? onTap,
  }) {
    final zt = context.zt;
    final color = overridden ? zt.accent : zt.textLo;
    return InkWell(
      key: key,
      onTap: enabled ? onTap : null,
      customBorder: const StadiumBorder(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : zt.textTertiary.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: enabled ? color : zt.textTertiary,
          ),
        ),
      ),
    );
  }
}
