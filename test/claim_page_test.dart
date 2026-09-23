import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/models/claim.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/state/claim_entry.dart';
import 'package:zremote/state/session_status.dart';
import 'package:zremote/ui/claim_page.dart';
import 'package:zremote/ui/claim_ticket_dialog.dart';
import 'package:zremote/ui/tactile_button.dart';
import 'package:zremote/ui/session_view.dart'
    show ClaimEntryButton;
import 'package:zremote/theme.dart';

import 'scripted_bridge.dart';

void main() {
  final device = RemoteDevice(
    id: 'd1',
    baseUrl: 'https://relay.example.com',
    params: const {'sid': 'sid-abcdef123456', 'hash': 'h'},
    label: '工作机',
    createdAt: DateTime(2026, 9, 1),
  );

  Map<String, dynamic> planJson({String id = 'plan-a'}) => {
    'planId': id,
    'name': '周末体验包',
    'description': '3 亿 Token 体验额度',
    'priority': 10,
    'entitlements': [
      {
        'showName': 'GLM-4.6',
        'units': 300000000,
        'unitType': 'token',
        'meter': 'model_usage',
      },
      {
        'showName': 'GLM-4.6',
        'grantUnits': 60000000,
        'unitType': 'token',
        'period': 'daily',
      },
    ],
  };

  Map<String, dynamic> previewsResponse(List<Map<String, dynamic>> plans) =>
      {'serverTime': 1780000000000, 'plans': plans};

  const configJson = {
    'enabled': true,
    'region': 'cn',
    'prefix': 'p',
    'sceneId': 's',
  };
  const verifyOk = {'ok': true, 'param': 'vp'};
  const outcomeOk = {
    'success': true,
    'serverTime': 1780000000000,
    'startsAt': 1779900000,
    'endsAt': 1790000000,
  };

  Future<ProviderContainer> pumpPage(
    WidgetTester tester, {
    required ScriptedBridge bridge,
    SessionStatus status = SessionStatus.live,
  }) async {
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
          home: ClaimPage(device: device, bridge: bridge.bridge),
        ),
      ),
    );
    await tester.pump();
    return container;
  }

  testWidgets('1. 空 plans：空态 + 歧义副文案，不闪卡片', (tester) async {
    final bridge = ScriptedBridge(script: [
      [previewsResponse([])],
    ]);
    await pumpPage(tester, bridge: bridge);
    expect(find.text('暂无可领活动'), findsOneWidget);
    expect(find.textContaining('已领过'), findsOneWidget);
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('2. 非空 previews：hero 票面（名称/描述/大面额读数 + TOKENS）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson()])],
    ]);
    await pumpPage(tester, bridge: bridge);
    expect(find.text('周末体验包'), findsOneWidget);
    expect(find.text('3 亿 Token 体验额度'), findsOneWidget);
    expect(find.text('300,000,000'), findsOneWidget);
    expect(find.text('TOKENS'), findsOneWidget);
    expect(find.text('领取'), findsOneWidget);
  });

  testWidgets('2b. 票面读数回归锁：字色 == ZT.dark.accent + 等宽字族', (tester) async {
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson()])],
    ]);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(sessionStatusProvider.notifier)
        .report('d1', SessionStatus.live);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ZT.theme(Brightness.dark),
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ClaimPage(device: device, bridge: bridge.bridge),
        ),
      ),
    );
    await tester.pump();

    final quota = tester.widget<Text>(find.text('300,000,000'));
    expect(quota.style?.color, ZT.dark.accent);
    expect(quota.style?.fontFamily, kMonoFamily);
  });

  testWidgets('3. 领取全链成功：params + busy 视觉锁 + 票券 + 关闭后刷新 + 入口回写', (tester) async {
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson(id: 'plan-a'), planJson(id: 'plan-b')])],
      [configJson],
      [verifyOk],
      [outcomeOk],
      [previewsResponse([])],
    ]);
    final container = await pumpPage(tester, bridge: bridge);
    expect(bridge.commands, hasLength(1));

    await tester.tap(find.text('领取').first);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    final restored = tester.widget<TactileButton>(
      find.widgetWithText(TactileButton, '领取').first,
    );
    expect(restored.onPressed, isNotNull, reason: '成功后卡片不应残留禁用');
    expect(bridge.commands, hasLength(4));

    final request = requestOf(bridge.commands[3]);
    expect(request.channel, 'coding-plan-subscription');
    expect(request.method, 'claimManualPlan');
    expect(request.params, {
      'planId': 'plan-a',
      'captchaVerifyParam': 'vp',
      'captchaRegion': 'cn',
    });

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();

    expect(find.text('周末体验包 领取成功'), findsOneWidget);
    expect(find.textContaining('300,000,000'), findsNWidgets(3));
    expect(find.textContaining('Tokens'), findsWidgets);
    expect(find.text('GLM-4.6 3亿 Tokens'), findsOneWidget);
    expect(find.textContaining('每日'), findsOneWidget);
    expect(find.textContaining('有效期至'), findsOneWidget);
    expect(find.text('ZRemote'), findsOneWidget);
    expect(find.byIcon(Icons.replay), findsOneWidget);
    expect(find.byIcon(Icons.share), findsNothing);
    expect(find.byType(CustomPaint), findsWidgets);

    expect(bridge.commands, hasLength(4));

    await tester.tap(find.text('知道了'));
    await tester.pump();
    await tester.pump();
    await tester.pump();
    expect(bridge.commands, hasLength(5));
    expect(requestOf(bridge.commands[4]).method, 'getManualClaimPlanPreviews');
    expect(find.text('暂无可领活动'), findsOneWidget);
    expect(container.read(claimEntryProvider)['d1'], false);
  });

  testWidgets('3c. 链路中段 busy 锁：config/verify 在途时 spinner + 其他卡禁用', (tester) async {
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson(id: 'plan-a'), planJson(id: 'plan-b')])],
      [configJson],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('领取').first);
    await tester.pump();

    expect(bridge.commands, hasLength(3));
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    final other = tester.widget<TactileButton>(
      find.widgetWithText(TactileButton, '领取'),
    );
    expect(other.onPressed, isNull, reason: '中段其他卡应禁用（页级单飞）');

    await tester.pump(const Duration(seconds: 25));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('需要完成验证'), findsOneWidget);
  });

  testWidgets('3d. 刷新重试：no-services 瞬时 → 退避后成功（2026-09-13 复盘回归锁）',
      (tester) async {
    final bridge = ScriptedBridge(script: []);
    await pumpPage(tester, bridge: bridge);
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    final id0 = bridge.commands[0]['i']! as int;
    bridge.deliver(jsonEncode({'i': id0, 'ok': false, 'e': 'no-services'}));
    await tester.pump();

    bridge.script
      ..add(const [])
      ..add([previewsResponse([planJson()])]);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('周末体验包'), findsOneWidget);
    expect(bridge.commands, hasLength(2));
  });

  testWidgets('3b. 入口显隐（rev 5）：report true → Badge 礼物图标；reset → 消失', (tester) async {    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ClaimEntryButton(deviceId: 'd1', onPressed: () {}),
          ),
        ),
      ),
    );
    expect(find.byKey(const ValueKey('claim-entry-on')), findsNothing);

    container.read(claimEntryProvider.notifier).report('d1', true);
    await tester.pump(const Duration(milliseconds: 130));
    expect(find.byIcon(Icons.card_giftcard), findsOneWidget);
    expect(find.byType(Badge), findsOneWidget);

    container.read(claimEntryProvider.notifier).reset('d1');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(find.byIcon(Icons.card_giftcard), findsNothing);
    expect(find.byKey(const ValueKey('claim-entry-on')), findsNothing);
  });

  Future<void> pumpClaimChain(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
  }

  testWidgets('4. 1003 已领取：失败对话框（标题 + code 文案 + 知道了）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson()])],
      [configJson],
      [verifyOk],
      const [
        {'success': false, 'code': 1003},
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('领取'));
    await pumpClaimChain(tester);
    expect(find.text('领取失败'), findsOneWidget);
    expect(find.text('该套餐已经领取过'), findsOneWidget);
    expect(find.text('知道了'), findsOneWidget);
  });

  testWidgets('4b. 1005 同日：claimRetryAt + 当天人类时间（秒-ms 容错回归锁）', (tester) async {
    final now = DateTime.now();
    final laterToday = DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 1))
        .subtract(const Duration(minutes: 1));
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson()])],
      [configJson],
      [verifyOk],
      [
        {
          'success': false,
          'code': 1005,
          'failureEndsAt': laterToday.millisecondsSinceEpoch ~/ 1000,
        },
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('领取'));
    await pumpClaimChain(tester);
    expect(find.text('今日领取名额已用完'), findsOneWidget);
    expect(find.textContaining('后可再试'), findsOneWidget);
    expect(find.textContaining(laterToday.year.toString()), findsOneWidget);
    expect(find.textContaining('1970'), findsNothing);
    expect(
      find.textContaining((laterToday.millisecondsSinceEpoch ~/ 1000).toString()),
      findsNothing,
    );
  });

  testWidgets('4b. 1005 跨日：claimRetryTomorrow', (tester) async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(
      const Duration(days: 1),
    );
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson()])],
      [configJson],
      [verifyOk],
      [
        {
          'success': false,
          'code': 1005,
          'failureEndsAt': tomorrow.millisecondsSinceEpoch ~/ 1000,
        },
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('领取'));
    await pumpClaimChain(tester);
    expect(find.text('明日可再试'), findsOneWidget);
  });

  testWidgets('5. 无感失败：fallback 对话框含「返回」导航指引 + 无 claimManualPlan 派发', (tester) async {
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson()])],
      [configJson],
      const [
        {'ok': false, 'reason': 'timeout'},
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('领取'));
    await pumpClaimChain(tester);
    expect(find.text('需要完成验证'), findsOneWidget);
    expect(find.textContaining('返回'), findsOneWidget);
    expect(bridge.commands, hasLength(3));
    expect(
      [for (final c in bridge.commands) requestOf(c)]
          .where((r) => r.method == 'claimManualPlan'),
      isEmpty,
    );
  });

  testWidgets('6. enabled=false：无 verify 派发 + claimUnavailable SnackBar（官方同语义）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson()])],
      const [
        {'enabled': false},
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('领取'));
    await tester.pump();
    await tester.pump();
    expect(bridge.commands, hasLength(2));
    expect(
      [for (final c in bridge.commands) requestOf(c)]
          .where((r) => r.method == 'verify'),
      isEmpty,
    );
    expect(find.text('活动暂不可领'), findsOneWidget);
  });

  testWidgets('7. 离线禁用：卡片照常渲染，领取按钮 onPressed 为 null', (tester) async {
    final bridge = ScriptedBridge(script: [
      [previewsResponse([planJson()])],
    ]);
    await pumpPage(tester, bridge: bridge, status: SessionStatus.error);
    expect(find.text('周末体验包'), findsOneWidget);
    expect(find.textContaining('设备未就绪'), findsOneWidget);
    final button = tester.widget<TactileButton>(
      find.widgetWithText(TactileButton, '领取'),
    );
    expect(button.onPressed, isNull);
    await tester.tap(find.text('领取'));
    await tester.pump();
    expect(bridge.commands, hasLength(1));
  });

  final ticketPlan = ClaimPreview(
    planId: 'plan-a',
    name: '周末体验包',
    entitlements: [
      const ClaimEntitlement(
        showName: 'GLM-4.6',
        units: 300000000,
        unitType: 'token',
        meter: 'model_usage',
      ),
    ],
  );
  const ticketOutcome = ClaimOutcome(
    success: true,
    serverTime: 1780000000000,
  );

  Future<void> pumpTicket(
    WidgetTester tester, {
    bool disableAnimations = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          final c = child ?? const SizedBox.shrink();
          if (!disableAnimations) return c;
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: c,
          );
        },
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: FilledButton(
                onPressed: () => showClaimTicketDialog(
                  context,
                  plan: ticketPlan,
                  outcome: ticketOutcome,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
  }

  testWidgets('票券：入场动画结束态——金额/权益/打孔 CustomPaint/无分享', (tester) async {
    await pumpTicket(tester);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();
    expect(find.textContaining('300,000,000'), findsOneWidget);
    expect(find.textContaining('3亿'), findsOneWidget);
    expect(find.textContaining('有效期至'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.byIcon(Icons.replay), findsOneWidget);
    expect(find.byIcon(Icons.share), findsNothing);
    expect(find.text('ZRemote'), findsOneWidget);
  });

  testWidgets('票券：disableAnimations 静态直显（一帧即完成态，无入场动画）', (tester) async {
    await pumpTicket(tester, disableAnimations: true);
    await tester.pump();
    expect(find.textContaining('300,000,000'), findsOneWidget);
    expect(find.textContaining('周末体验包 领取成功'), findsOneWidget);
    expect(find.textContaining('已可使用'), findsOneWidget);
  });

  testWidgets('票券：点击左右半卡触发翻转（转完回正，金额仍在）', (tester) async {
    await pumpTicket(tester);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();
    final cardCenter = tester.getCenter(find.textContaining('300,000,000'));
    await tester.tapAt(Offset(cardCenter.dx - 60, cardCenter.dy));
    await tester.pump(const Duration(milliseconds: 720));
    await tester.pump();
    expect(find.textContaining('300,000,000'), findsOneWidget);
    await tester.tapAt(Offset(cardCenter.dx + 60, cardCenter.dy));
    await tester.pump(const Duration(milliseconds: 720));
    await tester.pump();
    expect(find.textContaining('300,000,000'), findsOneWidget);
  });

  group('票券打孔几何常量链（评审 I#1 回归锁）', () {
    test('圆心距底恒 48px（官方 mask calc(100% - 48px)）', () {
      expect(
        ticketBottomPad +
            ticketValidityRow +
            ticketDividerGap +
            ticketHoleDiameter / 2,
        ticketHoleCenterFromBottom,
      );
    });

    test('gap 反推锚点 = 3（48 - 16 - 18 - 11）', () {
      expect(ticketDividerGap, 3.0);
    });

    test('bleed 同源 = 票面水平 padding 16', () {
      expect(ticketHPad, 16.0);
    });
  });
}
