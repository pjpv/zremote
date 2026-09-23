import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/device.dart';
import '../models/device_label.dart';
import '../models/usage_stats.dart';
import '../services/rpc_bridge.dart';
import '../state/session_status.dart';
import '../theme.dart';
import 'bevel_card.dart';
import 'claim_ticket_dialog.dart';
import 'inlaid_well.dart';
import 'section_label.dart';
import 'sheet_shell.dart';
import 'status_led.dart';
import 'tactile_button.dart';

class UsagePage extends ConsumerStatefulWidget {
  const UsagePage({super.key, required this.device, required this.bridge});

  final RemoteDevice device;
  final RpcBridge bridge;

  @override
  ConsumerState<UsagePage> createState() => _UsagePageState();
}

enum _UsagePhase { loading, ready, error }

enum _UsageErrorKind { notReady, remote }

const List<Color> kUsageChartColors = [
  Color(0xFF3B82F6),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFF8B5CF6),
  Color(0xFFEF4444),
  Color(0xFF64748B),
];

const int kUsageTrendModels = 6;

class _UsagePageState extends ConsumerState<UsagePage> {
  _UsagePhase _phase = _UsagePhase.loading;
  _UsageErrorKind _errorKind = _UsageErrorKind.notReady;
  String _errorMessage = '';
  bool _refreshing = false;
  bool _rangeBusy = false;
  String _range = '7d';
  late final String? _tz;
  AppUsageSnapshot? _all;
  AppUsageSnapshot? _ranged;
  bool _rangedFailed = false;

  @override
  void initState() {
    super.initState();
    _tz = zrTimeZoneId();
    debugPrint('[usage] tz in=$_tz (${DateTime.now().timeZoneName})');
    _refresh();
  }

  Future<RpcResponse> _callWithRetry(String method, Object? params) async {
    var attempt = 0;
    while (true) {
      attempt++;
      try {
        return await widget.bridge.call(
          'usage-stats',
          method,
          params: params,
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
      debugPrint('[usage] retry #$attempt for $method in 2s');
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }

  Map<String, String> _usageParams(String range) {
    final params = {'range': range};
    final tz = _tz;
    if (tz != null) params['timeZone'] = tz;
    return params;
  }

  Future<void> _refresh() async {
    if (_refreshing) return;
    _refreshing = true;
    if (mounted) setState(() {});
    try {
      final r = await _callWithRetry('getAppUsageSnapshot', _usageParams('all'));
      final all = AppUsageSnapshot.fromJson(r.firstObject ?? const {});
      if (!mounted) return;
      if (all == null) {
        setState(() {
          _phase = _UsagePhase.error;
          _errorKind = _UsageErrorKind.remote;
          _errorMessage = '';
        });
        return;
      }
      _all = all;
      setState(() => _phase = _UsagePhase.ready);
      debugPrint(
        '[usage] all ok (${all.heatmap?.weeks.length ?? 0} weeks, '
        'tz=${all.timeZone ?? "?"})',
      );
      await _fetchRanged();
    } on RpcRemoteException catch (e) {
      debugPrint('[usage] all remote error: ${e.message}');
      if (!mounted) return;
      setState(() {
        _phase = _UsagePhase.error;
        _errorKind = _UsageErrorKind.remote;
        _errorMessage = e.message;
      });
    } on RpcNotReadyException {
      debugPrint('[usage] all notReady after retries');
      _toNotReady();
    } on RpcTimeoutException {
      debugPrint('[usage] all timeout after retries');
      _toNotReady();
    } catch (e) {
      debugPrint('[usage] all unexpected error $e');
      _toNotReady();
    } finally {
      _refreshing = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _fetchRanged() async {
    _rangeBusy = true;
    if (mounted) setState(() {});
    try {
      final r = await _callWithRetry(
        'getAppUsageSnapshot',
        _usageParams(_range),
      );
      final ranged = AppUsageSnapshot.fromJson(r.firstObject ?? const {});
      if (!mounted) return;
      setState(() {
        _ranged = ranged;
        _rangedFailed = ranged == null;
      });
      debugPrint('[usage] ranged $_range ok (${ranged?.models.length ?? 0} models)');
    } catch (e) {
      debugPrint('[usage] ranged $_range failed: $e');
      if (!mounted) return;
      setState(() {
        _ranged = null;
        _rangedFailed = true;
      });
    } finally {
      _rangeBusy = false;
      if (mounted) setState(() {});
    }
  }

  void _changeRange(String range) {
    if (range == _range || _rangeBusy || _refreshing) return;
    _range = range;
    _fetchRanged();
  }

  void _openDayDetail({required String date}) {
    showZrSheet<void>(
      context: context,
      builder: (_) => _DayDetailSheet(
        date: date,
        dates: _usageDates,
        dayOf: _heatmapDay,
        modelsOf: _modelsForDate,
      ),
    );
  }

  List<String> get _usageDates {
    final dates = <String>{
      for (final w in _all?.heatmap?.weeks ?? const <AppUsageWeek>[])
        for (final d in w.days)
          if (d != null) d.date,
      for (final d in _ranged?.dailyModelUsage ?? const <AppDailyModels>[])
        d.date,
    }.toList()..sort();
    return dates;
  }

  List<AppModelTokens>? _modelsForDate(String date) {
    for (final snap in [_ranged, _all]) {
      if (snap == null) continue;
      for (final d in snap.dailyModelUsage) {
        if (d.date != date) continue;
        final sorted = [...d.models]
          ..sort((a, b) => b.totalTokens.compareTo(a.totalTokens));
        return sorted;
      }
    }
    return null;
  }

  AppUsageDay? _heatmapDay(String date) {
    for (final w in _all?.heatmap?.weeks ?? const <AppUsageWeek>[]) {
      for (final d in w.days) {
        if (d?.date == date) return d;
      }
    }
    return null;
  }

  void _toNotReady() {
    if (!mounted) return;
    setState(() {
      _phase = _UsagePhase.error;
      _errorKind = _UsageErrorKind.notReady;
      _errorMessage = '';
    });
  }

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
          if (_refreshing || _rangeBusy)
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
              tooltip: l10n.usageRefresh,
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
                            l10n.usageDeviceNotReady,
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
        _UsagePhase.loading => const Center(child: CircularProgressIndicator()),
        _UsagePhase.error => _errorView(l10n, offline),
        _UsagePhase.ready => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            if (_all?.summary != null) _summaryCard(l10n, _all!.summary!),
            if ((_all?.heatmap?.weeks.isNotEmpty ?? false)) ...[
              SectionLabel(l10n.usageHeatmapTitle),
              _heatmapCard(l10n),
            ],
            _rangeHeader(l10n),
            _rangeSection(l10n),
          ],
        ),
      },
    );
  }

  Widget _summaryCard(AppLocalizations l10n, AppUsageSummary s) {
    final locale = Localizations.localeOf(context).toString();
    final cells = <Widget>[
      _statCell(
        value: _smartCount(s.totalTokens, locale),
        label: l10n.usageSummaryTotalTokens,
      ),
      _statCell(
        value: _smartCount(s.peakDayTokens, locale),
        label: l10n.usageSummaryPeakDay,
      ),
      _statCell(
        value: _formatDuration(l10n, s.longestSessionMs),
        label: l10n.usageSummaryLongestSession,
      ),
      _statCell(
        value: l10n.usageDaysCount(s.currentStreakDays),
        label: l10n.usageSummaryCurrentStreak,
      ),
      _statCell(
        value: l10n.usageDaysCount(s.longestStreakDays),
        label: l10n.usageSummaryLongestStreak,
      ),
      if (s.favoriteModel?.modelId != null &&
          s.favoriteModel!.modelId!.isNotEmpty)
        _statCell(
          value: s.favoriteModel!.modelId!,
          label: l10n.usageSummaryFavoriteModel,
          ellipsis: true,
        ),
    ];
    return BevelCard(
      radius: 18,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final half = (constraints.maxWidth - 10) / 2;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final cell in cells) SizedBox(width: half, child: cell),
            ],
          );
        },
      ),
    );
  }

  Widget _heatmapCard(AppLocalizations l10n) {
    final zt = context.zt;
    final weeks = _all!.heatmap!.weeks;
    final colors = <Color>[
      zt.surfaceHover,
      zt.accent.withValues(alpha: 0.22),
      zt.accent.withValues(alpha: 0.45),
      zt.accent.withValues(alpha: 0.70),
      zt.accent,
    ];
    return BevelCard(
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeatmapView(
            key: const Key('usage-heatmap'),
            weeks: weeks,
            colors: colors,
            labelColor: zt.textTertiary,
            onDayTap: (day) => _openDayDetail(date: day.date),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                l10n.usageHeatmapLess,
                style: TextStyle(fontSize: 10, color: zt.textTertiary),
              ),
              const SizedBox(width: 6),
              for (var i = 0; i < colors.length; i++) ...[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colors[i],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                if (i != colors.length - 1) const SizedBox(width: 3),
              ],
              const SizedBox(width: 6),
              Text(
                l10n.usageHeatmapMore,
                style: TextStyle(fontSize: 10, color: zt.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rangeHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        children: [
          Expanded(child: SectionLabel(l10n.usageTrendTitle)),
          TactileButton(
            label: l10n.usageRange7d,
            height: 32,
            variant: _range == '7d'
                ? TactileVariant.primary
                : TactileVariant.normal,
            onPressed: _rangeBusy || _refreshing
                ? null
                : () => _changeRange('7d'),
          ),
          const SizedBox(width: 8),
          TactileButton(
            label: l10n.usageRange30d,
            height: 32,
            variant: _range == '30d'
                ? TactileVariant.primary
                : TactileVariant.normal,
            onPressed: _rangeBusy || _refreshing
                ? null
                : () => _changeRange('30d'),
          ),
        ],
      ),
    );
  }

  Widget _rangeSection(AppLocalizations l10n) {
    final ranged = _ranged;
    if (ranged == null) {
      return _rangedFailed
          ? _noteCard(l10n.usageSectionUnavailable)
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
    }
    final top = ranged.modelsByTokens
        .where((m) => m.totalTokens > 0)
        .take(kUsageTrendModels)
        .toList(growable: false);
    if (top.isEmpty || ranged.dailyModelUsage.isEmpty) {
      return Column(
        children: [
          _emptyCard(l10n),
        ],
      );
    }

    final days = [...ranged.dailyModelUsage]..sort((a, b) => a.date.compareTo(b.date));
    final series = <_TrendSeries>[
      for (final m in top)
        _TrendSeries(
          model: m.modelId ?? '—',
          total: m.totalTokens,
          values: [
            for (final d in days)
              d.models
                  .where((x) => x.modelId == m.modelId)
                  .fold<int>(0, (v, x) => v + x.totalTokens),
          ],
        ),
    ];
    var maxVal = 0;
    for (final s in series) {
      for (final v in s.values) {
        if (v > maxVal) maxVal = v;
      }
    }

    return Column(
      children: [
        _trendCard(
          l10n,
          days.map((d) => d.date).toList(),
          series,
          maxVal,
          onDayTap: (date) => _openDayDetail(date: date),
        ),
        _shareCard(l10n, ranged),
      ],
    );
  }

  Widget _trendCard(
    AppLocalizations l10n,
    List<String> dates,
    List<_TrendSeries> series,
    int maxVal, {
    required void Function(String date) onDayTap,
  }) {
    final zt = context.zt;
    return BevelCard(
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TrendChart(
            dates: dates,
            series: series,
            maxVal: maxVal,
            hairline: zt.hairline,
            textLo: zt.textLo,
            onDayTap: onDayTap,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              for (var i = 0; i < series.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: kUsageChartColors[i % kUsageChartColors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      series[i].model,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: zrMono(fontSize: 11, color: zt.textLo),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _smartCount(
                        series[i].total,
                        Localizations.localeOf(context).toString(),
                      ),
                      style: zrMono(fontSize: 11, color: zt.textTertiary),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shareCard(AppLocalizations l10n, AppUsageSnapshot ranged) {
    final zt = context.zt;
    final sorted = ranged.modelsByTokens
        .where((m) => m.totalTokens > 0)
        .toList(growable: false);
    final total = sorted.fold<int>(0, (v, m) => v + m.totalTokens);
    if (total <= 0) return _emptyCard(l10n);
    final overflow = sorted.length > kUsageTrendModels;
    final slotCount = overflow ? kUsageTrendModels - 1 : kUsageTrendModels;
    final top = sorted.take(slotCount).toList(growable: false);
    final otherTotal = sorted
        .skip(slotCount)
        .fold<int>(0, (v, m) => v + m.totalTokens);

    final rows = <(String, int, double)>[
      for (var i = 0; i < top.length; i++)
        (top[i].modelId ?? '—', top[i].totalTokens, _shareOf(top[i].totalTokens, total)),
      if (otherTotal > 0)
        (l10n.usageOther, otherTotal, _shareOf(otherTotal, total)),
    ];
    return BevelCard(
      key: const Key('usage-share'),
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.usageShareTitle,
            style: zrMono(
              fontSize: 11,
              weight: FontWeight.w600,
              color: zt.textLo,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  for (var i = 0; i < rows.length; i++)
                    Expanded(
                      flex: rows[i].$3 > 0
                          ? (rows[i].$3 * 1000).round()
                          : 1,
                      child: ColoredBox(
                        color: kUsageChartColors[i % kUsageChartColors.length],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < rows.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == rows.length - 1 ? 0 : 8,
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: kUsageChartColors[i % kUsageChartColors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rows[i].$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: zrMono(fontSize: 12, color: zt.textHi),
                    ),
                  ),
                  Text(
                    '${(rows[i].$3 * 100).toStringAsFixed(rows[i].$3 >= 0.999 ? 0 : 1)}%',
                    style: zrMono(
                      fontSize: 12,
                      color: zt.textLo,
                    ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _smartCount(
                      rows[i].$2,
                      Localizations.localeOf(context).toString(),
                    ),
                    style: zrMono(
                      fontSize: 12,
                      color: zt.textTertiary,
                    ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static double _shareOf(int part, int total) =>
      total <= 0 ? 0 : (part / total).clamp(0.0, 1.0);

  Widget _noteCard(String text) {
    return BevelCard(
      key: const Key('usage-note'),
      radius: 18,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: context.zt.textLo),
          ),
        ),
      ),
    );
  }

  Widget _emptyCard(AppLocalizations l10n) {
    final zt = context.zt;
    return BevelCard(
      radius: 18,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.usageEmptyTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: zt.textLo,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.usageEmptyDesc,
                style: TextStyle(fontSize: 12, color: zt.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCell({
    required String value,
    required String label,
    bool ellipsis = false,
  }) {
    final zt = context.zt;
    final textStyle = zrMono(
      fontSize: 18,
      weight: FontWeight.w700,
      color: zt.textHi,
    );
    final valueWidget =
        ellipsis
            ? FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, maxLines: 1, style: textStyle),
            )
            : Text(value, maxLines: 1, style: textStyle);
    return InlaidWell(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24, child: Center(child: valueWidget)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: zt.textLo)),
        ],
      ),
    );
  }

  Widget _errorView(AppLocalizations l10n, bool offline) {
    final remote = _errorKind == _UsageErrorKind.remote;
    final notReadyText =
        offline ? l10n.usageDeviceNotReady : l10n.usageServiceUnavailable;
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
              remote ? l10n.usageLoadFailed : notReadyText,
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
            TactileButton(label: l10n.usageRefresh, onPressed: _refresh),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(AppLocalizations l10n, int ms) {
    if (ms <= 0) return '0 ${l10n.usageDurS}';
    final h = ms ~/ 3600000;
    final m = (ms % 3600000) ~/ 60000;
    final s = (ms % 60000) ~/ 1000;
    if (h > 0) return '$h ${l10n.usageDurH} $m ${l10n.usageDurM}';
    if (m > 0) return '$m ${l10n.usageDurM} $s ${l10n.usageDurS}';
    return '$s ${l10n.usageDurS}';
  }
}

String _smartCount(int v, String locale) =>
    v >= 100000 ? ClaimFormat.compact(v, locale) : ClaimFormat.grouped(v);

class _TrendSeries {
  const _TrendSeries({
    required this.model,
    required this.total,
    required this.values,
  });

  final String model;
  final int total;
  final List<int> values;
}

class _HeatmapView extends StatelessWidget {
  const _HeatmapView({
    super.key,
    required this.weeks,
    required this.colors,
    required this.labelColor,
    required this.onDayTap,
  });

  final List<AppUsageWeek> weeks;
  final List<Color> colors;
  final Color labelColor;

  final void Function(AppUsageDay day) onDayTap;

  static const double _gutter = 24;
  static const double _gap = 4;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final pitch = (constraints.maxWidth - _gutter) / 7;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) {
          final x = details.localPosition.dx - _gutter;
          final y = details.localPosition.dy;
          final col = (x / pitch).floor();
          final row = (y / pitch).floor();
          if (col < 0 || col > 6 || row < 0 || row >= weeks.length) {
            return;
          }
          final days = weeks[row].days;
          if (col >= days.length) return;
          final day = days[col];
          if (day != null) onDayTap(day);
        },
        child: CustomPaint(
          painter: _HeatmapPainter(
            weeks: weeks,
            colors: colors,
            labelColor: labelColor,
            pitch: pitch,
            gutter: _gutter,
            gap: _gap,
          ),
          size: Size(constraints.maxWidth, weeks.length * pitch),
        ),
      );
    });
  }
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.weeks,
    required this.colors,
    required this.labelColor,
    required this.pitch,
    required this.gutter,
    required this.gap,
  });

  final List<AppUsageWeek> weeks;
  final List<Color> colors;
  final Color labelColor;
  final double pitch;
  final double gutter;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final labelPainter = TextPainter(textDirection: TextDirection.ltr);
    final cell = pitch - gap;
    var lastLabelRow = -10;
    var lastLabelMonth = '';
    for (var w = 0; w < weeks.length; w++) {
      final days = weeks[w].days;
      for (var d = 0; d < days.length && d < 7; d++) {
        final day = days[d];
        final level = day?.level ?? 0;
        paint.color = colors[level.clamp(0, colors.length - 1)];
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(gutter + d * pitch, w * pitch, cell, cell),
            const Radius.circular(4),
          ),
          paint,
        );
      }
      String? anchor;
      for (final d in days) {
        if (d?.date.endsWith('-01') ?? false) {
          anchor = d!.date;
          break;
        }
      }
      anchor ??= days.firstWhere((d) => d != null, orElse: () => null)?.date;
      if (anchor == null || anchor.length < 7) continue;
      final month = anchor.substring(0, 7);
      if (month == lastLabelMonth) continue;
      lastLabelMonth = month;
      if (w - lastLabelRow < 2) continue;
      lastLabelRow = w;
      labelPainter.text = TextSpan(
        text: month.substring(5),
        style: TextStyle(
          fontSize: 9,
          color: labelColor,
          fontFamily: kMonoFamily,
        ),
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(0, w * pitch + (pitch - labelPainter.height) / 2),
      );
    }
  }

  @override
  bool shouldRepaint(_HeatmapPainter old) =>
      old.weeks.length != weeks.length ||
      !identical(old.weeks, weeks) ||
      old.colors.length != colors.length ||
      !identical(old.colors, colors) ||
      old.pitch != pitch;
}

class _TrendChart extends StatefulWidget {
  const _TrendChart({
    required this.dates,
    required this.series,
    required this.maxVal,
    required this.hairline,
    required this.textLo,
    required this.onDayTap,
  });

  final List<String> dates;
  final List<_TrendSeries> series;
  final int maxVal;
  final Color hairline;
  final Color textLo;

  final void Function(String date) onDayTap;

  @override
  State<_TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<_TrendChart> {
  int? _selected;

  int? _indexAt(double dx, double w) {
    final dates = widget.dates;
    if (dates.isEmpty || w <= 0) return null;
    if (dates.length == 1) return 0;
    return (dx / w * (dates.length - 1)).round().clamp(0, dates.length - 1);
  }

  void _openSelected() {
    final i = _selected;
    if (i == null || i < 0 || i >= widget.dates.length) return;
    widget.onDayTap(widget.dates[i]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartH = 150 - 22.0;
          final w = constraints.maxWidth;
          return GestureDetector(
            key: const Key('usage-trend'),
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) =>
                setState(() => _selected = _indexAt(d.localPosition.dx, w)),
            onHorizontalDragStart: (d) =>
                setState(() => _selected = _indexAt(d.localPosition.dx, w)),
            onHorizontalDragUpdate: (d) =>
                setState(() => _selected = _indexAt(d.localPosition.dx, w)),
            onTapUp: (_) => _openSelected(),
            onHorizontalDragEnd: (_) => _openSelected(),
            child: CustomPaint(
              painter: _TrendPainter(
                dates: widget.dates,
                series: widget.series,
                maxVal: widget.maxVal,
                chartH: chartH,
                hairline: widget.hairline,
                textLo: widget.textLo,
                selectedIndex: _selected,
              ),
              size: Size(w, 150),
            ),
          );
        },
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.dates,
    required this.series,
    required this.maxVal,
    required this.chartH,
    required this.hairline,
    required this.textLo,
    this.selectedIndex,
  });

  final List<String> dates;
  final List<_TrendSeries> series;
  final int maxVal;
  final double chartH;
  final Color hairline;
  final Color textLo;

  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final grid = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = hairline;
    canvas.drawLine(Offset(0, chartH), Offset(w, chartH), grid);
    canvas.drawLine(Offset(0, chartH / 2), Offset(w, chartH / 2), grid);

    final label = TextPainter(textDirection: TextDirection.ltr);
    String fmt(String date) => date.length >= 10 ? date.substring(5, 10) : date;
    final dxPer = dates.length > 1 ? w / (dates.length - 1) : 0.0;
    final step = dates.length <= 10 ? 1 : (dates.length / 6).ceil();
    for (var i = 0; i < dates.length; i++) {
      final isEdge = i == 0 || i == dates.length - 1;
      if (i % step != 0 && !isEdge) continue;
      final cx = i * dxPer;
      if (!isEdge) {
        canvas.drawLine(Offset(cx, 0), Offset(cx, chartH), grid);
      }
      label.text = TextSpan(
        text: fmt(dates[i]),
        style: TextStyle(fontSize: 9, color: textLo, fontFamily: kMonoFamily),
      );
      label.layout();
      label.paint(
        canvas,
        Offset(
          (cx - label.width / 2).clamp(0.0, w - label.width),
          chartH + 6,
        ),
      );
    }

    final sel = selectedIndex;
    if (sel != null && sel >= 0 && sel < dates.length && dates.length > 1) {
      final cx = sel * dxPer;
      final selPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = kUsageChartColors.first;
      canvas.drawLine(Offset(cx, 0), Offset(cx, chartH), selPaint);
      label.text = TextSpan(
        text: fmt(dates[sel]),
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontFamily: kMonoFamily,
          fontWeight: FontWeight.w700,
        ),
      );
      label.layout();
      final tagW = label.width + 10;
      final tagX = (cx - tagW / 2).clamp(0.0, w - tagW);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(tagX, 2, tagW, 16),
          const Radius.circular(4),
        ),
        Paint()..color = kUsageChartColors.first,
      );
      label.paint(canvas, Offset(tagX + 5, 4));
    }

    if (dates.length > 1) {
      final dx = w / (dates.length - 1);
      double y(int v) =>
          maxVal <= 0 ? chartH : chartH - (v / maxVal) * (chartH - 4);
      final path = Path();
      final line = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      for (var i = 0; i < series.length; i++) {
        final values = series[i].values;
        line.color = kUsageChartColors[i % kUsageChartColors.length];
        path.reset();
        path.moveTo(0, y(values[0]));
        for (var d = 1; d < dates.length; d++) {
          path.lineTo(d * dx, y(d < values.length ? values[d] : 0));
        }
        canvas.drawPath(path, line);
      }
    }

  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.dates.length != dates.length ||
      old.series.length != series.length ||
      old.maxVal != maxVal ||
      !identical(old.series, series) ||
      !identical(old.dates, dates) ||
      old.selectedIndex != selectedIndex;
}

class _DayDetailSheet extends StatefulWidget {
  const _DayDetailSheet({
    required this.date,
    required this.dates,
    required this.dayOf,
    required this.modelsOf,
  });

  final String date;

  final List<String> dates;

  final AppUsageDay? Function(String) dayOf;

  final List<AppModelTokens>? Function(String) modelsOf;

  @override
  State<_DayDetailSheet> createState() => _DayDetailSheetState();
}

class _DayDetailSheetState extends State<_DayDetailSheet> {
  late String _date = widget.date;

  void _step(int delta) {
    final i = widget.dates.indexOf(_date);
    if (i < 0) return;
    final next = i + delta;
    if (next < 0 || next >= widget.dates.length) return;
    setState(() => _date = widget.dates[next]);
  }

  static const _zhWeekdays = ['一', '二', '三', '四', '五', '六', '日'];
  static const _enWeekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  static String dayTitle(String date, String locale) {
    final dt = DateTime.tryParse(date);
    if (dt == null) return date;
    final zh = locale.startsWith('zh');
    final core = zh ? '${dt.month}月${dt.day}日' : date.substring(5);
    final wd = zh ? '周${_zhWeekdays[dt.weekday - 1]}' : _enWeekdays[dt.weekday - 1];
    return '$core · $wd';
  }

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final day = widget.dayOf(_date);
    final models = widget.modelsOf(_date);
    final tokens = day?.totalTokens ?? 0;
    final turns = day?.turnCount ?? 0;
    final toolCalls = day?.toolCallCount ?? 0;
    final modelList = (models ?? const <AppModelTokens>[]).toList();
    final dateIndex = widget.dates.indexOf(_date);
    final noUsage =
        tokens == 0 && turns == 0 && toolCalls == 0 && modelList.isEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dayTitle(_date, locale),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: zt.textHi,
                    ),
                  ),
                ),
                _StepButton(
                  icon: Icons.chevron_left_rounded,
                  tooltip: l10n.usageDayPrev,
                  enabled: dateIndex > 0,
                  onTap: () => _step(-1),
                ),
                const SizedBox(width: 6),
                _StepButton(
                  icon: Icons.chevron_right_rounded,
                  tooltip: l10n.usageDayNext,
                  enabled:
                      dateIndex >= 0 &&
                      dateIndex < widget.dates.length - 1,
                  onTap: () => _step(1),
                ),
                const SizedBox(width: 6),
                _SheetCloseButton(onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
          if (noUsage)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  l10n.usageDayNoUsage,
                  style: TextStyle(fontSize: 13, color: zt.textLo),
                ),
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: _dayCell(
                    context,
                    value: _smartCount(tokens, locale),
                    label: l10n.usageDayTotalTokens,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dayCell(
                    context,
                    value: _smartCount(turns, locale),
                    label: l10n.usageDayTurns,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dayCell(
                    context,
                    value: _smartCount(toolCalls, locale),
                    label: l10n.usageDayToolCalls,
                  ),
                ),
              ],
            ),
            if (modelList.isNotEmpty) ...[
              SectionLabel(l10n.usageDayModels),
              for (var i = 0; i < modelList.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: i == modelList.length - 1 ? 4 : 8),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: kUsageChartColors[i % kUsageChartColors.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          modelList[i].modelId ?? '—',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: zrMono(fontSize: 12, color: zt.textHi),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _smartCount(modelList[i].totalTokens, locale),
                        style: zrMono(
                          fontSize: 12,
                          color: zt.textLo,
                        ).copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _dayCell(BuildContext context, {required String value, required String label}) {
    final zt = context.zt;
    return InlaidWell(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            style: zrMono(
              fontSize: 16,
              weight: FontWeight.w700,
              color: zt.textHi,
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10.5, color: zt.textLo)),
        ],
      ),
    );
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

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: zt.surfaceHover,
            border: Border.all(color: zt.hairline, width: 0.8),
          ),
          child: Icon(
            icon,
            size: 19,
            color: enabled ? zt.textHi : zt.textTertiary,
          ),
        ),
      ),
    );
  }
}
