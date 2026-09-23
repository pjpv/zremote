import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/state/session_status.dart';
import 'package:zremote/theme.dart';
import 'package:zremote/ui/automation_page.dart';
import 'package:zremote/ui/showcase_bits.dart';

import 'scripted_bridge.dart';

void main() {
  final device = RemoteDevice(
    id: 'd1',
    baseUrl: 'https://relay.example.com',
    params: const {'sid': 'sid-abcdef123456', 'hash': 'h'},
    label: '工作机',
    createdAt: DateTime(2026, 9, 1),
  );

  Map<String, dynamic> taskJson(
    String id, {
    String status = 'queued',
    int? queuePosition,
  }) => {
    'offPeakTaskId': id,
    'title': '任务-$id',
    'prompt': '回复 done',
    'status': status,
    'queuePosition': ?queuePosition,
    'workspacePath': r'J:\tmp\demo',
  };

  Map<String, dynamic> autoJson(String id, {String cron = '0 9 * * *'}) => {
    'automationId': id,
    'title': '定时-$id',
    'cronExpr': cron,
    'prompt': '定时回复 done',
    'workspacePath': r'J:\tmp\demo',
    'enabled': true,
    'recurring': true,
    'nextRunAt': DateTime(2026, 9, 5, 9, 0).millisecondsSinceEpoch,
    'runCount': 0,
  };

  Future<void> pumpPage(
    WidgetTester tester, {
    required ScriptedBridge bridge,
    SessionStatus status = SessionStatus.live,
  }) {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(sessionStatusProvider.notifier).report('d1', status);
    return tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AutomationPage(device: device, bridge: bridge.bridge),
        ),
      ),
    );
  }

  testWidgets('闲时 tab：任务卡渲染 + 状态徽章 + 排队位 + workspace', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [taskJson('t1', queuePosition: 3)],
        [],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump();
    expect(find.text('任务-t1'), findsOneWidget);
    expect(find.text('排队中'), findsOneWidget);
    expect(find.text('排队第 3 位'), findsOneWidget);
    expect(find.text('回复 done'), findsOneWidget);
    expect(find.text('demo'), findsOneWidget);
    expect(bridge.commands, hasLength(2));
    expect(requestOf(bridge.commands[0]).method, 'list');
    expect(requestOf(bridge.commands[1]).method, 'listAllAutomations');
  });

  testWidgets('定时 tab：cron 人话 + 下次时间 + 开关', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [],
        [autoJson('a1')],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump();
    await tester.tap(find.text('定时排程'));
    await tester.pumpAndSettle();
    expect(find.text('定时-a1'), findsOneWidget);
    expect(find.text('每日 09:00'), findsNWidgets(2));
    expect(find.text('下次：9/5 09:00'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
  });

  testWidgets('cron 人话：分钟为 * 不渲染「每小时 :*」，落自定义兜底（评审 r1）', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [],
        [autoJson('a1', cron: '* * * * *')],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump();
    await tester.tap(find.text('定时排程'));
    await tester.pumpAndSettle();
    expect(find.text('自定义'), findsNWidgets(2));
    expect(find.textContaining('每小时'), findsNothing);
  });

  testWidgets('状态徽章词汇：paused 用琥珀（warn）文案「已暂停」', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [taskJson('t1', status: 'paused')],
        [],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump();
    final badge = tester.widget<Text>(find.text('已暂停'));
    expect(badge.style!.color, ZT.light.warn);
  });

  testWidgets('离线禁写：警示条 + 全部操作按钮 onPressed 为 null', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [taskJson('t1', status: 'paused')],
        [],
      ],
    );
    await pumpPage(tester, bridge: bridge, status: SessionStatus.error);
    await tester.pump();
    expect(find.text('设备离线：列表为最后快照，操作已禁用'), findsOneWidget);
    expect(find.text('任务-t1'), findsOneWidget);
    for (final label in ['恢复', '编辑', '删除']) {
      final link = tester.widget<ZrActionLink>(
        find.widgetWithText(ZrActionLink, label),
      );
      expect(link.enabled, isFalse, reason: '$label 应禁用');
    }
    final dock = tester.widget<ZrDockButton>(find.byType(ZrDockButton));
    expect(dock.onPressed, isNull);
    await tester.tap(find.text('删除'));
    await tester.pump();
    expect(bridge.commands, hasLength(2));
  });

  testWidgets('空态：两 tab 各自文案 + 主按钮', (tester) async {
    final bridge = ScriptedBridge(script: const [[], []]);
    await pumpPage(tester, bridge: bridge);
    await tester.pump();
    expect(find.text('没有闲时任务'), findsOneWidget);
    expect(find.byIcon(Icons.nightlight), findsOneWidget);
    await tester.tap(find.text('定时排程'));
    await tester.pumpAndSettle();
    expect(find.text('没有定时任务'), findsOneWidget);
    expect(find.byIcon(Icons.event_repeat), findsOneWidget);
  });

  testWidgets('暂停操作：字符串参数 taskId + 响应对象 upsert 徽章', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [taskJson('t1', queuePosition: 3)],
        [],
        [taskJson('t1', status: 'paused')],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump();
    await tester.tap(find.text('暂停'));
    await tester.pump();
    await tester.pump();
    final request = requestOf(bridge.commands.last);
    expect(request.channel, 'off-peak-task');
    expect(request.method, 'pauseTask');
    expect(request.params, 't1');
    expect(find.text('已暂停'), findsOneWidget);
    expect(find.text('排队第 3 位'), findsNothing);
  });

  testWidgets('删除确认弹窗：确认后才发 deleteTask', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [taskJson('t1', status: 'paused')],
        [],
        [],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    expect(find.text('删除后不可恢复。'), findsOneWidget);
    expect(bridge.commands, hasLength(2));
    await tester.tap(find.widgetWithText(TextButton, '删除').last);
    await tester.pumpAndSettle();
    final request = requestOf(bridge.commands.last);
    expect(request.method, 'deleteTask');
    expect(request.params, 't1');
    expect(find.text('任务-t1'), findsNothing);
  });

  testWidgets('开关乐观更新：setAutomationEnabled 参数（失败回滚分支见 state 测试）', (
    tester,
  ) async {
    final bridge = ScriptedBridge(
      script: [
        [],
        [autoJson('a1')],
        [],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump();
    await tester.tap(find.text('定时排程'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.pump();
    final request = requestOf(bridge.commands.last);
    expect(request.method, 'setAutomationEnabled');
    expect(request.params, {
      'workspacePath': r'J:\tmp\demo',
      'automationId': 'a1',
      'enabled': false,
    });
  });

  testWidgets('终态卡新字段：failed 显示失败原因，completed 显示变更文件数', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [
          {...taskJson('t1', status: 'failed'), 'failureReason': 'ticket expired'},
          {...taskJson('t2', status: 'completed'), 'filesChanged': 3},
        ],
        [],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump();
    expect(find.text('任务-t1'), findsOneWidget);
    expect(find.text('失败原因：ticket expired'), findsOneWidget);
    expect(find.text('变更 3 个文件'), findsOneWidget);
    expect(find.textContaining('变更'), findsOneWidget);
    expect(find.textContaining('失败原因'), findsOneWidget);
  });
}
