import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/claim.dart';
import '../models/device.dart';
import '../models/device_label.dart';
import '../services/rpc_bridge.dart';
import '../state/claim_entry.dart';
import '../state/session_status.dart';
import '../theme.dart';
import 'bevel_card.dart';
import 'hw_chip.dart';
import 'claim_ticket_dialog.dart';
import 'showcase_bits.dart';
import 'status_led.dart';
import 'tactile_button.dart';

class ClaimPage extends ConsumerStatefulWidget {
  const ClaimPage({super.key, required this.device, required this.bridge});

  final RemoteDevice device;
  final RpcBridge bridge;

  @override
  ConsumerState<ClaimPage> createState() => _ClaimPageState();
}

enum _ClaimPhase { loading, ready, error }

enum _ClaimErrorKind { notReady, remote }

class _ClaimPageState extends ConsumerState<ClaimPage> {
  _ClaimPhase _phase = _ClaimPhase.loading;
  _ClaimErrorKind _errorKind = _ClaimErrorKind.notReady;
  String _errorMessage = '';
  bool _refreshing = false;
  List<ClaimPreview> _previews = const [];

  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _refresh() async {
    if (_refreshing) return;
    _refreshing = true;
    if (mounted) setState(() {});
    try {
      final r = await _callWithRetry(
        'getManualClaimPlanPreviews',
        tag: 'refresh',
      );
      final obj = r.firstObject;
      final rawPlans = obj?['plans'];
      final previews = <ClaimPreview>[
        if (rawPlans is List)
          for (final p in rawPlans)
            if (p is Map<String, dynamic>) ?ClaimPreview.fromJson(p),
      ];
      previews.sort((a, b) {
        final byPriority = b.priority.compareTo(a.priority);
        return byPriority != 0 ? byPriority : a.planId.compareTo(b.planId);
      });
      if (!mounted) return;
      setState(() {
        _previews = previews;
        _phase = _ClaimPhase.ready;
      });
      debugPrint('[claim] refresh ok plans=${previews.length}');
      ref
          .read(claimEntryProvider.notifier)
          .report(widget.device.id, previews.isNotEmpty);
    } on RpcRemoteException catch (e) {
      debugPrint('[claim] refresh remote error: ${e.message}');
      if (!mounted) return;
      setState(() {
        _phase = _ClaimPhase.error;
        _errorKind = _ClaimErrorKind.remote;
        _errorMessage = e.message;
      });
    } on RpcNotReadyException {
      debugPrint('[claim] refresh notReady after retries');
      _toNotReady();
    } on RpcTimeoutException {
      debugPrint('[claim] refresh timeout after retries');
      _toNotReady();
    } catch (e) {
      debugPrint('[claim] refresh unexpected error $e');
      _toNotReady();
    } finally {
      _refreshing = false;
      if (mounted) setState(() {});
    }
  }

  Future<RpcResponse> _callWithRetry(
    String method, {
    required String tag,
  }) async {
    var attempt = 0;
    while (true) {
      attempt++;
      try {
        return await widget.bridge.call(
          'coding-plan-subscription',
          method,
          timeout: const Duration(seconds: 10),
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
      debugPrint('[claim] $tag retry #$attempt in 2s');
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }

  void _toNotReady() {
    if (!mounted) return;
    setState(() {
      _phase = _ClaimPhase.error;
      _errorKind = _ClaimErrorKind.notReady;
      _errorMessage = '';
    });
  }

  Future<void> _claim(ClaimPreview plan) async {
    final l10n = AppLocalizations.of(context)!;
    if (_busy.isNotEmpty) return;
    if (ref.read(sessionStatusProvider)[widget.device.id] !=
        SessionStatus.live) {
      return;
    }
    setState(() => _busy.add(plan.planId));
    try {
      final CaptchaConfig cfg;
      try {
        final r = await widget.bridge.call(
          'coding-plan-subscription',
          'getCaptchaConfig',
        );
        cfg = CaptchaConfig.fromJson(r.firstObject ?? const {});
      } catch (e) {
        debugPrint('[claim] captchaConfig error $e');
        if (mounted) _snack('${l10n.claimFailedGeneric}${_msgOf(e)}');
        return;
      }
      if (!cfg.enabled || cfg.sceneId.isEmpty) {
        if (mounted) _snack(l10n.claimUnavailable);
        return;
      }

      final String verifyParam;
      try {
        final r = await widget.bridge.call(
          'zr-captcha',
          'verify',
          params: {
            'sceneId': cfg.sceneId,
            'prefix': cfg.prefix,
            'region': cfg.region,
            'timeoutMs': 8000,
          },
          timeout: const Duration(seconds: 20),
        );
        final v = r.firstObject;
        final param = v?['param'];
        if (v == null || v['ok'] != true || param is! String || param.isEmpty) {
          await _fallbackDialog();
          return;
        }
        verifyParam = param;
      } catch (e) {
        debugPrint('[claim] captcha verify error $e');
        await _fallbackDialog();
        return;
      }

      final ClaimOutcome outcome;
      try {
        final r = await widget.bridge.call(
          'coding-plan-subscription',
          'claimManualPlan',
          params: {
            'planId': plan.planId,
            'captchaVerifyParam': verifyParam,
            if (cfg.region.isNotEmpty) 'captchaRegion': cfg.region,
          },
        );
        outcome = ClaimOutcome.fromJson(r.firstObject ?? const {});
      } catch (e) {
        debugPrint('[claim] claimManualPlan error $e');
        if (mounted) _snack('${l10n.claimFailedGeneric}${_msgOf(e)}');
        return;
      }
      if (!mounted) return;

      if (outcome.success) {
        debugPrint('[claim] claim ok plan=${plan.planId}');
        if (mounted) setState(() => _busy.clear());
        await showClaimTicketDialog(context, plan: plan, outcome: outcome);
        if (mounted) await _refresh();
      } else {
        debugPrint('[claim] claim fail code=${outcome.code}');
        await _failureDialog(outcome);
      }
    } finally {
      if (mounted) setState(() => _busy.clear());
    }
  }

  static String _msgOf(Object e) =>
      e is RpcRemoteException && e.message.isNotEmpty ? '（${e.message}）' : '';

  Future<void> _fallbackDialog() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.claimCaptchaFallbackTitle),
        content: Text(l10n.claimCaptchaFallbackBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.claimGotIt),
          ),
        ],
      ),
    );
  }

  Future<void> _failureDialog(ClaimOutcome outcome) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final code = outcome.code;
    final mapped = code == null ? null : _codeMessage(l10n, code);
    final main = mapped ??
        (outcome.message.isNotEmpty
            ? outcome.message
            : l10n.claimFailedGeneric);

    String? retry;
    if (code == 1005) {
      final at = outcome.failureEndsAt;
      if (at != null) {
        final now = DateTime.now();
        final sameDay =
            at.year == now.year && at.month == now.month && at.day == now.day;
        retry = sameDay
            ? l10n.claimRetryAt(ClaimFormat.dateTime(at, locale))
            : l10n.claimRetryTomorrow;
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.claimFailedTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(main),
            if (retry != null) ...[
              const SizedBox(height: 8),
              Text(
                retry,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.claimGotIt),
          ),
        ],
      ),
    );
  }

  static String? _codeMessage(AppLocalizations l10n, int code) =>
      switch (code) {
        1001 => l10n.claimCode1001,
        1002 => l10n.claimCode1002,
        1003 => l10n.claimCode1003,
        1004 => l10n.claimCode1004,
        1005 => l10n.claimCode1005,
        3001 => l10n.claimCode3001,
        3007 => l10n.claimCode3007,
        401 => l10n.claimCode401,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = ref.watch(sessionStatusProvider)[widget.device.id];
    final offline = status != SessionStatus.live;

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
          if (_refreshing || _busy.isNotEmpty)
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
              tooltip: l10n.claimRefresh,
              onPressed: _refresh,
            ),
        ],
        bottom:
            offline
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
                            l10n.claimDeviceNotReady,
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
        _ClaimPhase.loading => const Center(child: CircularProgressIndicator()),
        _ClaimPhase.error => _errorView(l10n, offline),
        _ClaimPhase.ready =>
          _previews.isEmpty
              ? _emptyView(l10n)
              : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  _scopeRow(l10n, status),
                  for (final plan in _previews) _planCard(l10n, plan, offline),
                ],
              ),
      },
    );
  }

  Widget _scopeRow(AppLocalizations l10n, SessionStatus? status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ZrScopeDock(
        label: l10n.claimScopeLabel,
        name: widget.device.displayName(l10n),
        dotColor: status == SessionStatus.live
            ? context.zt.live
            : context.zt.danger,
      ),
    );
  }

  Widget _errorView(AppLocalizations l10n, bool offline) {
    final remote = _errorKind == _ClaimErrorKind.remote;
    final notReadyText =
        offline ? l10n.claimDeviceNotReady : l10n.claimServiceUnavailable;
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
              remote ? l10n.claimFailedGeneric : notReadyText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.zt.textHi,
              ),
            ),
            if (remote && _errorMessage.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                _errorMessage,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: context.zt.textLo),
              ),
            ],
            const SizedBox(height: 16),
            TactileButton(label: l10n.claimRefresh, onPressed: _refresh),
          ],
        ),
      ),
    );
  }

  Widget _emptyView(AppLocalizations l10n) {
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
                color: context.zt.accentSubtle,
                border: Border.all(color: context.zt.accentBorder, width: 1.2),
              ),
              child: Icon(Icons.redeem_outlined, size: 32, color: context.zt.accent),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.claimEmpty,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.zt.textHi,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.claimEmptyHint,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: context.zt.textLo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard(AppLocalizations l10n, ClaimPreview plan, bool offline) {
    final busyThis = _busy.contains(plan.planId);
    final disabled = offline || _busy.isNotEmpty || _refreshing;
    final quotaUnits = _tokenUnits(plan);
    final zt = context.zt;

    return BevelCard(
      accent: true,
      radius: 20,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HwChip(
                text: plan.planId.toUpperCase(),
                color: zt.accent,
                icon: Icon(Icons.verified_outlined, size: 12, color: zt.accent),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.claimLimitedTag,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: zt.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            plan.name.isEmpty ? plan.planId : plan.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.15,
              color: zt.textHi,
            ),
          ),
          const SizedBox(height: 14),
          if (quotaUnits != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  quotaUnits,
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    fontFamily: kMonoFamily,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    letterSpacing: -1.2,
                    color: zt.accent,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'TOKENS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    fontFamily: kMonoFamily,
                    color: zt.textLo,
                  ),
                ),
              ],
            ),
          ] else if (plan.description.isNotEmpty) ...[
            Text(
              plan.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, height: 1.4, color: zt.textLo),
            ),
          ],
          if (quotaUnits != null && plan.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              plan.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.5, height: 1.4, color: zt.textLo),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TactileButton(
              variant: TactileVariant.primary,
              height: 44,
              icon: busyThis
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: zt.onAccent,
                      ),
                    )
                  : const Icon(Icons.card_giftcard, size: 18),
              label: busyThis ? l10n.claimActionBusy : l10n.claimAction,
              onPressed: disabled ? null : () => _claim(plan),
            ),
          ),
        ],
      ),
    );
  }

  static String? _tokenUnits(ClaimPreview plan) {
    var total = 0;
    var found = false;
    for (final e in plan.entitlements) {
      if (e.unitType == 'token' &&
          e.meter == 'model_usage' &&
          e.units != null) {
        total += e.units!.toInt();
        found = true;
      }
    }
    if (!found) return null;
    final digits = total.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remain = digits.length - 1 - i;
      if (remain > 0 && remain % 3 == 0) buffer.write(',');
    }
    return buffer.toString();
  }
}
