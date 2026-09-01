import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/services/event_observer.dart';
import 'package:zremote/theme.dart';
import 'package:zremote/ui/session_panel.dart';

void main() {
  SessionState sess(
    String id, {
    String? title,
    String? phase,
    String? workspace,
    int? lastActivityAt,
    int permissionCount = 0,
    int userInputCount = 0,
    bool pinned = false,
  }) => SessionState(
    sessionId: id,
    title: title,
    phase: phase,
    permissionCount: permissionCount,
    userInputCount: userInputCount,
    lastActivityAt: lastActivityAt,
    workspace: workspace,
    pinned: pinned,
  );

  Future<void> pumpPanel(
    WidgetTester tester,
    List<SessionState> sessions, {
    String? activeSessionId,
    ValueChanged<String>? onSessionTap,
    DateTime? now,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SessionPanelSheet(
            sessions: sessions,
            activeSessionId: activeSessionId,
            onSessionTap: onSessionTap,
            now: now,
          ),
        ),
      ),
    );
  }

  testWidgets('标题渲染「会话」', (tester) async {
    await pumpPanel(tester, [sess('s1', title: '任务A', phase: 'running')]);
    expect(find.text('会话'), findsOneWidget);
  });

  testWidgets('三会话按传入顺序渲染（排序责任在调用方，面板不重排）', (tester) async {
    final now = DateTime(2026, 8, 31, 15, 0);
    final nowMs = now.millisecondsSinceEpoch;
    await pumpPanel(tester, [
      sess('s1', title: '任务一', lastActivityAt: nowMs - 60 * 1000),
      sess('s2', title: '任务二', lastActivityAt: nowMs - 2 * 3600 * 1000),
      sess('s3', title: '任务三', lastActivityAt: nowMs - 5 * 3600 * 1000),
    ], now: now);
    final y1 = tester.getTopLeft(find.text('任务一')).dy;
    final y2 = tester.getTopLeft(find.text('任务二')).dy;
    final y3 = tester.getTopLeft(find.text('任务三')).dy;
    expect(y1, lessThan(y2));
    expect(y2, lessThan(y3));
  });

  testWidgets('日历分组头：今天/昨天/3天', (tester) async {
    final now = DateTime(2026, 8, 31, 15, 0);
    final nowMs = now.millisecondsSinceEpoch;
    const hour = 3600 * 1000;
    await pumpPanel(tester, [
      sess('s1', title: '刚动的', lastActivityAt: nowMs),
      sess('s2', title: '昨天动的', lastActivityAt: nowMs - 24 * hour),
      sess('s3', title: '三天前动的', lastActivityAt: nowMs - 72 * hour),
    ], now: now);
    expect(find.text('今天'), findsOneWidget);
    expect(find.text('昨天'), findsOneWidget);
    expect(find.text('3天'), findsWidgets);
  });

  testWidgets('置顶组：pinned 会话归首组，组头「已置顶」在日分组头之前', (tester) async {
    final now = DateTime(2026, 8, 31, 15, 0);
    final nowMs = now.millisecondsSinceEpoch;
    await pumpPanel(tester, [
      sess('s1', title: '普通会话', phase: 'running', lastActivityAt: nowMs),
      sess(
        's2',
        title: '置顶会话',
        phase: 'running',
        lastActivityAt: nowMs - 72 * 3600 * 1000,
        pinned: true,
      ),
    ], now: now);
    expect(find.text('已置顶'), findsOneWidget);
    expect(find.text('今天'), findsOneWidget);
    final yPinnedHeader = tester.getTopLeft(find.text('已置顶')).dy;
    final yPinnedRow = tester.getTopLeft(find.text('置顶会话')).dy;
    final yToday = tester.getTopLeft(find.text('今天')).dy;
    expect(yPinnedHeader, lessThan(yPinnedRow));
    expect(yPinnedRow, lessThan(yToday));
  });

  testWidgets('状态胶囊：running→运行中、completedSuccess→已完成、error→失败', (
    tester,
  ) async {
    await pumpPanel(tester, [
      sess('s1', title: '任务甲', phase: 'running'),
      sess('s2', title: '任务乙', phase: 'completedSuccess'),
      sess('s3', title: '任务丙', phase: 'error'),
    ]);
    expect(find.text('运行中'), findsOneWidget);
    expect(find.text('已完成'), findsOneWidget);
    expect(find.text('失败'), findsOneWidget);
  });

  testWidgets('未知/缺 phase 不渲染状态胶囊（Web 对未知态不出）', (tester) async {
    await pumpPanel(tester, [
      sess('s1', title: '任务甲'),
      sess('s2', title: '任务乙', phase: 'mysterious'),
    ]);
    expect(find.text('运行中'), findsNothing);
    expect(find.text('已完成'), findsNothing);
    expect(find.text('失败'), findsNothing);
  });

  testWidgets('蓝点：仅 activeSessionId 匹配行是 accent 实心，不匹配行透明占位', (
    tester,
  ) async {
    await pumpPanel(
      tester,
      [
        sess('s1', title: '任务A', phase: 'running'),
        sess('s2', title: '任务B', phase: 'running'),
      ],
      activeSessionId: 's1',
    );
    Color dotColor(String id) =>
        (tester.widget<Container>(
                  find.byKey(Key('session-active-dot-$id')),
                ).decoration
                as BoxDecoration)
            .color!;
    expect(dotColor('s1'), ZT.accent);
    expect(dotColor('s2'), Colors.transparent);
  });

  testWidgets('副标题：项目名 · 相对时间（词形「1小时」，无「前」）', (tester) async {
    final now = DateTime(2026, 8, 31, 15, 0);
    await pumpPanel(tester, [
      sess(
        's1',
        title: '任务A',
        phase: 'running',
        workspace: 'demo',
        lastActivityAt: now.millisecondsSinceEpoch - 3600 * 1000,
      ),
    ], now: now);
    expect(find.text('demo'), findsOneWidget);
    expect(find.textContaining('·'), findsOneWidget);
    expect(find.text('1小时'), findsOneWidget);
  });

  testWidgets('副标题：workspace 缺失时只显示时间（无 ·）', (tester) async {
    final now = DateTime(2026, 8, 31, 15, 0);
    await pumpPanel(tester, [
      sess(
        's1',
        title: '任务A',
        phase: 'running',
        lastActivityAt: now.millisecondsSinceEpoch - 30 * 1000,
      ),
    ], now: now);
    expect(find.textContaining('·'), findsNothing);
    expect(find.text('刚刚'), findsOneWidget);
  });

  testWidgets('待办徽章保留：权限红胶囊、输入青胶囊', (tester) async {
    await pumpPanel(tester, [
      sess('s1', title: '任务甲', phase: 'running', permissionCount: 2),
      sess('s2', title: '任务乙', phase: 'running', userInputCount: 1),
    ]);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('同行内待办徽章排在状态胶囊之前（间隔 6）', (tester) async {
    await pumpPanel(tester, [
      sess('s1', title: '任务甲', phase: 'running', permissionCount: 2),
    ]);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('运行中'), findsOneWidget);
    final badgeX = tester.getTopLeft(find.text('2')).dx;
    final pillX = tester.getTopLeft(find.text('运行中')).dx;
    expect(badgeX, lessThan(pillX));
  });

  testWidgets('点某行 → 回调收到对应 sessionId', (tester) async {
    final tapped = <String>[];
    final now = DateTime(2026, 8, 31, 15, 0);
    await pumpPanel(
      tester,
      [
        sess(
          'sess_x',
          title: '任务丙',
          phase: 'running',
          lastActivityAt: now.millisecondsSinceEpoch,
        ),
      ],
      onSessionTap: tapped.add,
      now: now,
    );
    await tester.tap(find.text('任务丙'));
    expect(tapped, ['sess_x']);
  });

  testWidgets('空列表 → 「此设备暂无会话」可见', (tester) async {
    await pumpPanel(tester, const []);
    expect(find.text('此设备暂无会话'), findsOneWidget);
  });

  List<SessionState> manySessions(int n) => List<SessionState>.generate(
    n,
    (i) => SessionState(sessionId: 's$i', title: '会话-$i', phase: 'running'),
  );

  testWidgets('超长列表（120 行）在有限高度内不溢出且可滚动', (tester) async {
    await pumpPanel(tester, manySessions(120));
    expect(tester.takeException(), isNull);
    expect(find.text('会话-0'), findsOneWidget);
  });

  testWidgets('抽屉真实嵌套（外层 Column(min) 经 Flexible 持有面板）下 120 行不溢出', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: SessionPanelSheet(sessions: manySessions(120)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('会话-0'), findsOneWidget);
  });
}
