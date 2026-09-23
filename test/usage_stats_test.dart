import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/models/usage_stats.dart';

void main() {
  Map<String, dynamic> snapshotJson({
    Map<String, dynamic>? summary,
    Map<String, dynamic>? heatmap,
    List<Object>? models,
    List<Object>? daily,
    Object? tools = const [],
  }) => {
    'range': '7d',
    'generatedAt': 1780000000000,
    'timeZone': 'Asia/Shanghai',
    'source': 'agent-db',
    'summary': summary,
    'heatmap': heatmap,
    'models': models,
    'dailyModelUsage': daily,
    'tools': tools,
  };

  test('1. 完整快照：标量/嵌套/枚举回显全量解析', () {
    final s = AppUsageSnapshot.fromJson(snapshotJson(
      summary: {
        'totalTokens': 12345678, 'peakDayTokens': 990000,
        'longestSessionMs': 4980000, 'currentStreakDays': 3,
        'longestStreakDays': 9, 'totalSessions': 42, 'totalTurns': 300,
        'toolCallCount': 88, 'activeDays': 9,
        'favoriteModel': {'modelId': 'GLM-4.6', 'totalTokens': 8000000, 'share': 0.65},
      },
      heatmap: {
        'startDate': '2026-08-01', 'endDate': '2026-09-23', 'maxTokens': 990000,
        'weeks': [
          {'weekIndex': 0, 'days': [
            {'date': '2026-08-03', 'level': 2, 'totalTokens': 1000,
             'turnCount': 5, 'toolCallCount': 2},
            null,
          ]},
        ],
      },
      models: [
        {'modelId': 'GLM-4.6', 'totalTokens': 800, 'share': 0.8,
         'inputTokens': 1, 'outputTokens': 1, 'requestCount': 3},
      ],
      daily: [
        {'date': '2026-09-22', 'models': [
          {'modelId': 'GLM-4.6', 'totalTokens': 500},
        ]},
      ],
    ))!;
    expect(s.range, '7d');
    expect(s.generatedAt, 1780000000000);
    final sum = s.summary!;
    expect(sum.totalTokens, 12345678);
    expect(sum.peakDayTokens, 990000);
    expect(sum.longestSessionMs, 4980000);
    expect(sum.currentStreakDays, 3);
    expect(sum.longestStreakDays, 9);
    expect(sum.favoriteModel!.modelId, 'GLM-4.6');
    expect(sum.favoriteModel!.share, 0.65);
    final week = s.heatmap!.weeks.single;
    expect(week.days, hasLength(2));
    expect(week.days[0]!.date, '2026-08-03');
    expect(week.days[0]!.level, 2);
    expect(week.days[1], isNull);
    expect(s.heatmap!.startDate, '2026-08-01');
    final m = s.models.single;
    expect(m.modelId, 'GLM-4.6');
    expect(m.totalTokens, 800);
    expect(m.share, 0.8);
    expect(s.dailyModelUsage.single.models.single.totalTokens, 500);
  });

  test('2. 空回执：四业务键全缺 → null（页面判 error(remote)）', () {
    expect(AppUsageSnapshot.fromJson({'generatedAt': 1, 'source': 'agent-db'}), isNull);
    expect(AppUsageSnapshot.fromJson(const {}), isNull);
  });

  test('3. 单键在场即活：仅 summary 也能成快照（区段自由缺省）', () {
    final s = AppUsageSnapshot.fromJson(snapshotJson(
      summary: {'totalTokens': 5},
      heatmap: null, models: null, daily: null,
    ))!;
    expect(s.summary!.totalTokens, 5);
    expect(s.heatmap, isNull);
    expect(s.models, isEmpty);
    expect(s.dailyModelUsage, isEmpty);
  });

  test('4. summary 宽容：字段缺席计 0、favoriteModel null 透传', () {
    final s = AppUsageSnapshot.fromJson(snapshotJson(
      summary: {'totalTokens': 7, 'favoriteModel': null},
    ))!;
    final sum = s.summary!;
    expect(sum.peakDayTokens, 0);
    expect(sum.longestSessionMs, 0);
    expect(sum.longestStreakDays, 0);
    expect(sum.favoriteModel, isNull);
  });

  test('5. level 防御性 clamp 到 0-4（漂移值不炸渲染）', () {
    final s = AppUsageSnapshot.fromJson(snapshotJson(
      heatmap: {'maxTokens': 1, 'weeks': [
        {'weekIndex': 0, 'days': [
          {'date': '2026-09-01', 'level': 9, 'totalTokens': 1,
           'turnCount': 0, 'toolCallCount': 0},
          {'date': '2026-09-02', 'level': -3, 'totalTokens': 1,
           'turnCount': 0, 'toolCallCount': 0},
        ]},
      ]},
    ))!;
    expect(s.heatmap!.weeks.single.days[0]!.level, 4);
    expect(s.heatmap!.weeks.single.days[1]!.level, 0);
  });

  test('6. 坏对象丢弃：非对象 summary/坏 models 条目/坏周条目逐个过滤', () {
    final s = AppUsageSnapshot.fromJson({
      'range': 'all',
      'summary': 'oops',
      'models': [
        {'modelId': 'A', 'totalTokens': 10, 'share': 0.6},
        {'modelId': 'B'},
        'garbage',
        {'modelId': null, 'totalTokens': 5, 'share': 0.4},
      ],
      'heatmap': {'weeks': [
        {'days': []},
        {'weekIndex': 1, 'days': null},
      ]},
    })!;
    expect(s.summary, isNull);
    expect(s.models, hasLength(2));
    expect(s.models[1].modelId, isNull);
    expect(s.heatmap!.weeks, hasLength(1));
    expect(s.heatmap!.weeks.single.days, isEmpty);
  });

  test('7. modelsByTokens：总量降序 + 同量按名稳定排序（占比榜用）', () {
    final s = AppUsageSnapshot.fromJson(snapshotJson(models: [
      {'modelId': 'B', 'totalTokens': 100, 'share': 0.1},
      {'modelId': 'A', 'totalTokens': 300, 'share': 0.3},
      {'modelId': 'C', 'totalTokens': 100, 'share': 0.1},
    ]))!;
    expect(
      s.modelsByTokens.map((m) => m.modelId).toList(),
      ['A', 'B', 'C'],
    );
    expect(s.models.first.modelId, 'B');
  });

  test('8. dailyModelUsage 坏条目丢弃：缺 date/坏 models 整对象丢', () {
    final s = AppUsageSnapshot.fromJson(snapshotJson(daily: [
      {'date': '2026-09-01', 'models': [
        {'modelId': 'X', 'totalTokens': 3},
        {'modelId': 'Y'},
      ]},
      {'models': []},
      'garbage',
    ]))!;
    expect(s.dailyModelUsage, hasLength(1));
    expect(s.dailyModelUsage.single.models, hasLength(1));
  });

  test('9. tools 解析即丢弃（网页版 UI 不渲染，同款取舍）', () {
    final s = AppUsageSnapshot.fromJson(snapshotJson(
      summary: {'totalTokens': 1},
      tools: [
        {'toolName': 'bash', 'callCount': 9, 'errorCount': 0,
         'errorRate': 0, 'avgDurationMs': 12},
      ],
    ))!;
    expect(s.summary!.totalTokens, 1);
  });
}
