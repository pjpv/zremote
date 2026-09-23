
class AppModelStat {
  const AppModelStat({
    required this.modelId,
    required this.totalTokens,
    required this.share,
  });

  final String? modelId;
  final int totalTokens;

  final double share;

  static AppModelStat? fromJson(Map<String, dynamic> j) {
    final tokens = j['totalTokens'];
    if (tokens is! num) return null;
    return AppModelStat(
      modelId: j['modelId'] is String ? j['modelId'] as String? : null,
      totalTokens: tokens.toInt(),
      share: j['share'] is num ? (j['share'] as num).toDouble() : 0,
    );
  }
}

class AppUsageSummary {
  const AppUsageSummary({
    required this.totalTokens,
    required this.peakDayTokens,
    required this.longestSessionMs,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.totalSessions,
    required this.totalTurns,
    required this.toolCallCount,
    required this.activeDays,
    this.favoriteModel,
  });

  final int totalTokens;
  final int peakDayTokens;
  final int longestSessionMs;
  final int currentStreakDays;
  final int longestStreakDays;
  final int totalSessions;
  final int totalTurns;
  final int toolCallCount;
  final int activeDays;
  final AppModelStat? favoriteModel;

  static AppUsageSummary? fromJson(Map<String, dynamic> j) {
    if (j.isEmpty) return null;
    final favorite = j['favoriteModel'];
    return AppUsageSummary(
      totalTokens: _intOf(j['totalTokens']),
      peakDayTokens: _intOf(j['peakDayTokens']),
      longestSessionMs: _intOf(j['longestSessionMs']),
      currentStreakDays: _intOf(j['currentStreakDays']),
      longestStreakDays: _intOf(j['longestStreakDays']),
      totalSessions: _intOf(j['totalSessions']),
      totalTurns: _intOf(j['totalTurns']),
      toolCallCount: _intOf(j['toolCallCount']),
      activeDays: _intOf(j['activeDays']),
      favoriteModel: favorite is Map<String, dynamic>
          ? AppModelStat.fromJson(favorite)
          : null,
    );
  }

  static int _intOf(dynamic v) => v is num ? v.toInt() : 0;
}

class AppUsageDay {
  const AppUsageDay({
    required this.date,
    required this.level,
    required this.totalTokens,
    required this.turnCount,
    required this.toolCallCount,
  });

  final String date;

  final int level;
  final int totalTokens;
  final int turnCount;
  final int toolCallCount;

  static AppUsageDay? fromJson(Map<String, dynamic> j) {
    final date = j['date'];
    if (date is! String || date.isEmpty) return null;
    final level = j['level'] is num ? (j['level'] as num).toInt() : 0;
    return AppUsageDay(
      date: date,
      level: level.clamp(0, 4),
      totalTokens: _intOf(j['totalTokens']),
      turnCount: _intOf(j['turnCount']),
      toolCallCount: _intOf(j['toolCallCount']),
    );
  }

  static int _intOf(dynamic v) => v is num ? v.toInt() : 0;
}

class AppUsageWeek {
  const AppUsageWeek({required this.weekIndex, required this.days});

  final int weekIndex;
  final List<AppUsageDay?> days;

  static AppUsageWeek? fromJson(Map<String, dynamic> j) {
    final weekIndex = j['weekIndex'];
    if (weekIndex is! num) return null;
    final days = j['days'];
    return AppUsageWeek(
      weekIndex: weekIndex.toInt(),
      days: days is List
          ? [
              for (final d in days)
                d is Map<String, dynamic> ? AppUsageDay.fromJson(d) : null,
            ]
          : const [],
    );
  }
}

class AppUsageHeatmap {
  const AppUsageHeatmap({
    required this.maxTokens,
    required this.weeks,
    this.startDate,
    this.endDate,
  });

  final int maxTokens;
  final List<AppUsageWeek> weeks;
  final String? startDate;
  final String? endDate;

  static AppUsageHeatmap? fromJson(Map<String, dynamic> j) {
    if (j.isEmpty) return null;
    final weeks = j['weeks'];
    return AppUsageHeatmap(
      maxTokens: j['maxTokens'] is num ? (j['maxTokens'] as num).toInt() : 0,
      weeks: weeks is List
          ? [
              for (final w in weeks)
                if (w is Map<String, dynamic>) AppUsageWeek.fromJson(w),
            ].whereType<AppUsageWeek>().toList()
          : const [],
      startDate: j['startDate'] is String ? j['startDate'] as String : null,
      endDate: j['endDate'] is String ? j['endDate'] as String : null,
    );
  }
}

class AppModelTokens {
  const AppModelTokens({required this.modelId, required this.totalTokens});

  final String? modelId;
  final int totalTokens;

  static AppModelTokens? fromJson(Map<String, dynamic> j) {
    final tokens = j['totalTokens'];
    if (tokens is! num) return null;
    return AppModelTokens(
      modelId: j['modelId'] is String ? j['modelId'] as String? : null,
      totalTokens: tokens.toInt(),
    );
  }
}

class AppDailyModels {
  const AppDailyModels({required this.date, required this.models});

  final String date;
  final List<AppModelTokens> models;

  static AppDailyModels? fromJson(Map<String, dynamic> j) {
    final date = j['date'];
    if (date is! String || date.isEmpty) return null;
    final models = j['models'];
    return AppDailyModels(
      date: date,
      models: models is List
          ? [
              for (final m in models)
                if (m is Map<String, dynamic>) AppModelTokens.fromJson(m),
            ].whereType<AppModelTokens>().toList()
          : const [],
    );
  }
}

class AppUsageSnapshot {
  const AppUsageSnapshot({
    required this.range,
    required this.generatedAt,
    required this.dailyModelUsage,
    required this.models,
    this.summary,
    this.heatmap,
    this.timeZone,
  });

  final String range;
  final int generatedAt;

  final String? timeZone;
  final AppUsageSummary? summary;
  final AppUsageHeatmap? heatmap;
  final List<AppDailyModels> dailyModelUsage;

  final List<AppModelStat> models;

  List<AppModelStat> get modelsByTokens {
    final sorted = [...models]..sort((a, b) {
      final c = b.totalTokens.compareTo(a.totalTokens);
      if (c != 0) return c;
      return (a.modelId ?? '').compareTo(b.modelId ?? '');
    });
    return sorted;
  }

  static AppUsageSnapshot? fromJson(Map<String, dynamic> j) {
    final summary = j['summary'];
    final heatmap = j['heatmap'];
    final models = j['models'];
    final daily = j['dailyModelUsage'];
    final empty =
        summary == null && heatmap == null &&
        models == null && daily == null;
    if (empty) return null;
    return AppUsageSnapshot(
      range: j['range'] is String ? j['range'] as String : '',
      generatedAt: j['generatedAt'] is num
          ? (j['generatedAt'] as num).toInt()
          : 0,
      timeZone: j['timeZone'] is String && (j['timeZone'] as String).isNotEmpty
          ? j['timeZone'] as String
          : null,
      summary: summary is Map<String, dynamic>
          ? AppUsageSummary.fromJson(summary)
          : null,
      heatmap: heatmap is Map<String, dynamic>
          ? AppUsageHeatmap.fromJson(heatmap)
          : null,
      models: models is List
          ? [
              for (final m in models)
                if (m is Map<String, dynamic>) AppModelStat.fromJson(m),
            ].whereType<AppModelStat>().toList()
          : const [],
      dailyModelUsage: daily is List
          ? [
              for (final d in daily)
                if (d is Map<String, dynamic>) AppDailyModels.fromJson(d),
            ].whereType<AppDailyModels>().toList()
          : const [],
    );
  }
}

String? zrTimeZoneFromName(String name) {
  final trimmed = name.trim();
  if (trimmed == 'UTC') return 'UTC';
  final iana = RegExp(r'^[A-Za-z][A-Za-z0-9_+-]*(?:/[A-Za-z0-9_+-]+){1,2}$');
  if (iana.hasMatch(trimmed)) return trimmed;
  final offset = RegExp(
    r'^(?:GMT|UTC)?([+-])(\d{1,2})(?::?(\d{2}))?$',
  ).firstMatch(trimmed);
  if (offset == null) return null;
  final minutes = offset.group(3) == null ? 0 : int.parse(offset.group(3)!);
  if (minutes != 0) return null;
  final hours = int.parse(offset.group(2)!);
  if (hours == 0) return 'UTC';
  final posixSign = offset.group(1) == '+' ? '-' : '+';
  return 'Etc/GMT$posixSign$hours';
}

String? zrTimeZoneFromParts(String name, Duration offset) {
  final byName = zrTimeZoneFromName(name);
  if (byName != null) return byName;
  if (offset.inMinutes % 60 != 0) return null;
  final hours = offset.inHours;
  if (hours == 0) return 'UTC';
  return hours > 0 ? 'Etc/GMT-$hours' : 'Etc/GMT+${-hours}';
}

String? zrTimeZoneId() {
  final now = DateTime.now();
  return zrTimeZoneFromParts(now.timeZoneName, now.timeZoneOffset);
}
