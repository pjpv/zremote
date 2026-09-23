import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/state/session_status.dart';
import 'package:zremote/ui/toolbox_sheet.dart';
import 'package:zremote/ui/claim_ticket_dialog.dart';
import 'package:zremote/ui/usage_page.dart';

import 'scripted_bridge.dart';

void main() {
  final device = RemoteDevice(
    id: 'd1',
    baseUrl: 'https://relay.example.com',
    params: const {'sid': 'sid-abcdef123456', 'hash': 'h'},
    label: '工作机',
    createdAt: DateTime(2026, 9, 1),
  );

  Map<String, dynamic> allJson() => {
    'range': 'all', 'generatedAt': 1780000000000,
    'timeZone': 'Asia/Shanghai', 'source': 'agent-db',
    'summary': {
      'totalTokens': 12345678, 'peakDayTokens': 990000,
      'longestSessionMs': 1380000, 'currentStreakDays': 3,
      'longestStreakDays': 9, 'totalSessions': 42, 'totalTurns': 300,
      'toolCallCount': 88, 'activeDays': 9,
      'favoriteModel': {'modelId': 'GLM-4.6', 'totalTokens': 8000000, 'share': 0.65},
    },
    'heatmap': {'startDate': '2026-09-14', 'endDate': '2026-09-21',
      'maxTokens': 990000, 'weeks': [
        {'weekIndex': 0, 'days': [
          {'date': '2026-09-20', 'level': 1, 'totalTokens': 100,
           'turnCount': 1, 'toolCallCount': 0},
          null,
          {'date': '2026-09-22', 'level': 3, 'totalTokens': 5000,
           'turnCount': 6, 'toolCallCount': 2},
        ]},
      ]},
    'dailyModelUsage': [], 'models': [], 'tools': [],
  };

  Map<String, dynamic> rangedJson(String range, {String? secondModel}) => {
    'range': range, 'generatedAt': 1780000000000,
    'timeZone': 'Asia/Shanghai', 'source': 'agent-db',
    'summary': {'totalTokens': 1250, 'peakDayTokens': 600,
      'longestSessionMs': 0, 'currentStreakDays': 2, 'longestStreakDays': 2,
      'favoriteModel': null},
    'heatmap': {'maxTokens': 0, 'weeks': []},
    'dailyModelUsage': [
      {'date': '2026-09-20', 'models': [
        {'modelId': 'GLM-4.6', 'totalTokens': 600}]},
      {'date': '2026-09-21', 'models': [
        {'modelId': 'GLM-4.6', 'totalTokens': 400},
        if (secondModel != null) {'modelId': secondModel, 'totalTokens': 250},
      ]},
    ],
    'models': [
      {'modelId': 'GLM-4.6', 'totalTokens': 1000, 'share': 0.8,
       'inputTokens': 0, 'outputTokens': 0, 'requestCount': 9},
      if (secondModel != null)
        {'modelId': secondModel, 'totalTokens': 250, 'share': 0.2,
         'inputTokens': 0, 'outputTokens': 0, 'requestCount': 2},
    ],
    'tools': [],
  };

  Future<void> pumpPage(
    WidgetTester tester, {
    required ScriptedBridge bridge,
    SessionStatus status = SessionStatus.live,
  }) async {
    tester.view.physicalSize = const Size(600, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(sessionStatusProvider.notifier).report('d1', status);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: UsagePage(device: device, bridge: bridge.bridge),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('1. 正常快照：五格汇总 + 热力图 + 趋势图例 + 占比', (tester) async {
    final bridge = ScriptedBridge(script: [
      [allJson()],
      [rangedJson('7d', secondModel: 'GLM-4.5-Air')],
    ]);
    await pumpPage(tester, bridge: bridge);
    expect(find.text(ClaimFormat.compact(12345678, 'zh')), findsOneWidget);
    expect(find.text(ClaimFormat.compact(990000, 'zh')), findsOneWidget);
    expect(find.text('23 分 0 秒'), findsOneWidget);
    expect(find.text('3 天'), findsOneWidget);
    expect(find.text('9 天'), findsOneWidget);
    expect(find.text('累计 Token'), findsOneWidget);
    expect(find.text('使用热力图'), findsOneWidget);
    expect(find.text('少'), findsOneWidget);
    expect(find.text('多'), findsOneWidget);
    expect(find.text('每日模型用量'), findsOneWidget);
    expect(find.text('近 7 天'), findsOneWidget);
    expect(find.text('近 30 天'), findsOneWidget);
    expect(find.text('GLM-4.6'), findsWidgets);
    await tester.ensureVisible(find.byKey(const Key('usage-share')));
    await tester.pumpAndSettle();
    expect(find.text('80.0%'), findsOneWidget);
    expect(find.text('20.0%'), findsOneWidget);
    expect(find.text('1,000'), findsNWidgets(2));
    expect(find.text('250'), findsNWidgets(2));
    expect(bridge.commands.length, 2);
    final first = requestOf(bridge.commands[0]);
    expect(first.channel, 'usage-stats');
    expect(first.method, 'getAppUsageSnapshot');
    final firstParams = first.params! as Map<String, dynamic>;
    expect(firstParams['range'], 'all');
    expect(firstParams.length, lessThanOrEqualTo(2));
    final tz = firstParams['timeZone'] as String?;
    if (tz != null) {
      expect(
        RegExp(
          r'^(UTC|Etc/GMT[+-]\d{1,2}|[A-Za-z][A-Za-z0-9_+-]*(?:/[A-Za-z0-9_+-]+){1,2})$',
        ).hasMatch(tz),
        isTrue,
        reason: 'timeZone=$tz',
      );
    }
    final second = requestOf(bridge.commands[1]);
    expect(second.method, 'getAppUsageSnapshot');
    expect((second.params! as Map<String, dynamic>)['range'], '7d');
  });

  testWidgets('1b. 热力图点按：当日详情弹层（三计数 + 模型明细 + 关闭）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [allJson()],
      [rangedJson('7d', secondModel: 'GLM-4.5-Air')],
    ]);
    await pumpPage(tester, bridge: bridge);
    final heat = find.byKey(const Key('usage-heatmap'));
    expect(heat, findsOneWidget);
    await tester.tapAt(tester.getTopLeft(heat) + const Offset(30, 10));
    await tester.pumpAndSettle();
    expect(find.text('9月20日 · 周日'), findsOneWidget);
    expect(find.text('当日消耗'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('600'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();
    expect(find.text('9月21日 · 周一'), findsOneWidget);
    expect(find.text('400'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.text('9月20日 · 周日'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('9月20日 · 周日'), findsNothing);
  });

  testWidgets('1c. 趋势点按：当日详情（就近取日；日不在热力图 → 计数 0 兜底）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [allJson()],
      [rangedJson('7d', secondModel: 'GLM-4.5-Air')],
    ]);
    await pumpPage(tester, bridge: bridge);
    final trend = find.byKey(const Key('usage-trend'));
    expect(trend, findsOneWidget);
    await tester.ensureVisible(trend);
    await tester.pumpAndSettle();
    final size = tester.getSize(trend);
    await tester.tapAt(
      tester.getTopLeft(trend) + Offset(size.width * 0.75, 40),
    );
    await tester.pumpAndSettle();
    expect(find.text('9月21日 · 周一'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(3));
    expect(find.text('400'), findsOneWidget);
    expect(find.text('250'), findsWidgets);
  });

  testWidgets('2. range 切换：30d 追加一次 ranged 调用并重绘', (tester) async {
    final bridge = ScriptedBridge(script: [
      [allJson()],
      [rangedJson('7d')],
      [rangedJson('30d', secondModel: 'GLM-4.5-Air')],
    ]);
    await pumpPage(tester, bridge: bridge);
    expect(find.text('20.0%'), findsNothing);
    await tester.tap(find.text('近 30 天'));
    await tester.pump();
    expect(bridge.commands.length, 3);
    final third = requestOf(bridge.commands[2]);
    expect((third.params! as Map<String, dynamic>)['range'], '30d');
    await tester.ensureVisible(find.byKey(const Key('usage-share')));
    await tester.pumpAndSettle();
    expect(find.text('20.0%'), findsOneWidget);
    expect(find.text('GLM-4.5-Air'), findsWidgets);
  });

  testWidgets('2b. 模型溢出：占比 top5+其他（预留槽防撞色），趋势保持 top6', (tester) async {
    final models = <Map<String, dynamic>>[
      for (var i = 1; i <= 8; i++)
        {'modelId': 'M$i', 'totalTokens': 100 * (9 - i), 'share': 0.0,
         'inputTokens': 0, 'outputTokens': 0, 'requestCount': 1},
    ];
    final ranged = rangedJson('7d')
      ..['dailyModelUsage'] = [
        {'date': '2026-09-20', 'models': [
          for (final m in models)
            {'modelId': m['modelId'], 'totalTokens': m['totalTokens']},
        ]},
      ]
      ..['models'] = models;
    final bridge = ScriptedBridge(script: [
      [allJson()],
      [ranged],
    ]);
    await pumpPage(tester, bridge: bridge);
    expect(find.text('其他'), findsOneWidget);
    expect(find.text('M5'), findsNWidgets(2));
    expect(find.text('M6'), findsOneWidget);
    expect(find.text('M7'), findsNothing);
    expect(find.text('M8'), findsNothing);
  });

  testWidgets('3. no-services 退避：2s 后自愈，全量断言照过', (tester) async {
    final bridge = ScriptedBridge(
      errors: {0: 'no-services'},
      script: [
        [],
        [allJson()],
        [rangedJson('7d', secondModel: 'GLM-4.5-Air')],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text(ClaimFormat.compact(12345678, 'zh')), findsNothing);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text(ClaimFormat.compact(12345678, 'zh')), findsOneWidget);
    expect(find.text('使用热力图'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('usage-share')));
    await tester.pumpAndSettle();
    expect(find.text('80.0%'), findsOneWidget);
    expect(bridge.commands.length, 3);
  });

  testWidgets('4. 超时耗尽：3×10s+2×2s → error(notReady) LED-live 分支', (tester) async {
    final bridge = ScriptedBridge(script: []);
    await pumpPage(tester, bridge: bridge);
    await tester.pump(const Duration(seconds: 10));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 10));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 10));
    await tester.pump();
    expect(find.text('页面服务暂不可用'), findsOneWidget);
    expect(find.text('刷新'), findsOneWidget);
    expect(find.text(ClaimFormat.compact(12345678, 'zh')), findsNothing);
    expect(bridge.commands.length, 3);
  });

  testWidgets('5. 区段降级：ranged 失败只降级趋势区，汇总/热力图不受影响', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [allJson()],
      ],
      errors: {1: 'boom monitor'},
    );
    await pumpPage(tester, bridge: bridge);
    expect(find.text(ClaimFormat.compact(12345678, 'zh')), findsOneWidget);
    expect(find.text('使用热力图'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('usage-note')));
    await tester.pumpAndSettle();
    expect(find.text('统计暂不可用'), findsOneWidget);
    expect(find.text('80.0%'), findsNothing);
  });

  testWidgets('6. 空数据：无热力图区、趋势区空态卡、汇总零值不炸', (tester) async {
    final emptyAll = allJson()
      ..['summary'] = {
        'totalTokens': 0, 'peakDayTokens': 0, 'longestSessionMs': 0,
        'currentStreakDays': 0, 'longestStreakDays': 0, 'favoriteModel': null,
      }
      ..['heatmap'] = {'maxTokens': 0, 'weeks': []};
    final emptyRanged = rangedJson('7d')
      ..['dailyModelUsage'] = []
      ..['models'] = [];
    final bridge = ScriptedBridge(script: [
      [emptyAll],
      [emptyRanged],
    ]);
    await pumpPage(tester, bridge: bridge);
    expect(find.text('使用热力图'), findsNothing);
    expect(find.text('暂无使用记录'), findsOneWidget);
    expect(find.text('0 秒'), findsOneWidget);
    expect(find.text('0 天'), findsNWidgets(2));
  });

  testWidgets('7. 用量入箱：工具箱面板用量卡常驻可点 + 回调触发', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (sheetHost) => TextButton(
                onPressed: () => showToolboxSheet(
                  context: sheetHost,
                  device: device,
                  onAutomationPressed: () {},
                  onClaimPressed: () {},
                  onUsagePressed: () => taps++,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.query_stats_rounded), findsOneWidget);
    expect(find.text('用量统计'), findsOneWidget);
    await tester.tap(find.text('用量统计'));
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(find.text('用量统计'), findsNothing);
  });
}
