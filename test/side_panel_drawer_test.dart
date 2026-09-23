import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/state/automation.dart';
import 'package:zremote/state/claim_entry.dart';
import 'package:zremote/theme.dart';
import 'package:zremote/ui/side_panel_drawer.dart';

void main() {
  final device = RemoteDevice(
    id: 'd1',
    baseUrl: 'https://relay.example.com',
    params: const {'sid': 'sid-12345678', 'hash': 'h'},
    label: '我的电脑',
    createdAt: DateTime(2026, 9, 1),
  );

  Widget buildHost({
    required VoidCallback onAuto,
    required VoidCallback onClaim,
    VoidCallback? onUsage,
    Locale locale = const Locale('zh'),
    WidgetRef Function(WidgetRef)? onInit,
  }) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          onInit?.call(ref);
          return MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ZT.theme(Brightness.dark),
            home: Scaffold(
              body: SidePanelDrawer(
                device: device,
                onAutomationPressed: onAuto,
                onClaimPressed: onClaim,
                onUsagePressed: onUsage ?? () {},
              ),
            ),
          );
        },
      ),
    );
  }

  testWidgets('SidePanelDrawer 渲染标题与各功能卡片 (中文)', (tester) async {
    await tester.pumpWidget(
      buildHost(onAuto: () {}, onClaim: () {}),
    );
    await tester.pumpAndSettle();

    expect(find.text('功能工具箱'), findsOneWidget);
    expect(find.text('我的电脑'), findsNothing);
    expect(find.text('自动化调度'), findsOneWidget);
    expect(find.text('权益中心'), findsOneWidget);
    expect(find.text('更多功能'), findsOneWidget);
  });

  testWidgets('SidePanelDrawer 渲染英文文本 (English)', (tester) async {
    await tester.pumpWidget(
      buildHost(
        onAuto: () {},
        onClaim: () {},
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Toolbox'), findsOneWidget);
    expect(find.text('Automation'), findsOneWidget);
    expect(find.text('Perks Center'), findsOneWidget);
    expect(find.text('More Tools'), findsOneWidget);
  });

  testWidgets('自动化卡常驻可点（无订阅信号也不锁）', (tester) async {
    bool autoTriggered = false;

    await tester.pumpWidget(
      buildHost(
        onAuto: () => autoTriggered = true,
        onClaim: () {},
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('需套餐'), findsNothing);
    await tester.tap(find.text('自动化调度'));
    await tester.pumpAndSettle();
    expect(autoTriggered, isTrue);
  });

  testWidgets('权益卡未就绪（无 previews 命中）仍禁用点击', (tester) async {
    bool claimTriggered = false;

    await tester.pumpWidget(
      buildHost(
        onAuto: () {},
        onClaim: () => claimTriggered = true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('权益中心'));
    await tester.pumpAndSettle();
    expect(claimTriggered, isFalse);
  });

  testWidgets('排队任务点亮「N 条排队」徽标，自动化卡可点', (tester) async {
    bool autoTriggered = false;
    await tester.pumpWidget(
      buildHost(
        onAuto: () => autoTriggered = true,
        onClaim: () {},
      ),
    );
    await tester.pumpAndSettle();

    final element = tester.element(find.byType(SidePanelDrawer));
    final container = ProviderScope.containerOf(element);
    container.read(automationProvider.notifier).replaceOffPeak(device.id, [
      {
        'offPeakTaskId': 't1',
        'title': 'T-1',
        'prompt': 'P',
        'status': 'queued',
        'queuePosition': 3,
        'workspacePath': r'J:\tmp\demo',
        'queuedAt': 1788523547814,
        'updatedAt': 1788523547814,
      },
    ]);
    await tester.pumpAndSettle();
    expect(find.text('1 条排队'), findsOneWidget);

    await tester.tap(find.text('自动化调度'));
    await tester.pumpAndSettle();

    expect(autoTriggered, isTrue);
  });

  testWidgets('权益就绪后点击权益卡片触发 onClaimPressed 回调', (tester) async {
    bool claimTriggered = false;
    await tester.pumpWidget(
      buildHost(
        onAuto: () {},
        onClaim: () => claimTriggered = true,
      ),
    );
    await tester.pumpAndSettle();

    final element = tester.element(find.byType(SidePanelDrawer));
    final container = ProviderScope.containerOf(element);
    container.read(claimEntryProvider.notifier).report(device.id, true);
    await tester.pumpAndSettle();

    await tester.tap(find.text('权益中心'));
    await tester.pumpAndSettle();

    expect(claimTriggered, isTrue);
  });

  testWidgets('有套餐且有排队任务、有待领权益时渲染对应状态徽标', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ZT.theme(Brightness.dark),
          home: Scaffold(
            body: SidePanelDrawer(
              device: device,
              onAutomationPressed: () {},
              onClaimPressed: () {},
              onUsagePressed: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final element = tester.element(find.byType(SidePanelDrawer));
    final container = ProviderScope.containerOf(element);

    container.read(claimEntryProvider.notifier).report(device.id, true);
    container.read(automationProvider.notifier).reportSubscribed(device.id, true);
    container.read(automationProvider.notifier).replaceOffPeak(
      device.id,
      [
        {
          'offPeakTaskId': 'task-1',
          'status': 'queued',
          'title': '测试排队任务 1',
        },
        {
          'offPeakTaskId': 'task-2',
          'status': 'queued',
          'title': '测试排队任务 2',
        },
      ],
    );

    await tester.pumpAndSettle();

    expect(find.text('2 条排队'), findsOneWidget);
    expect(find.text('有可领'), findsOneWidget);
  });

  testWidgets('在 showToolboxSheet 模式下点击已开通卡片会安全关闭面板并触发回调', (tester) async {
    bool autoTriggered = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ZT.theme(Brightness.dark),
          home: Scaffold(
            body: Builder(
              builder: (ctx) => Center(
                child: ElevatedButton(
                  onPressed: () => showToolboxSheet(
                    context: ctx,
                    device: device,
                    onAutomationPressed: () => autoTriggered = true,
                    onClaimPressed: () {},
                    onUsagePressed: () {},
                  ),
                  child: const Text('打开工具箱'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final element = tester.element(find.byType(MaterialApp));
    final container = ProviderScope.containerOf(element);
    container.read(automationProvider.notifier).reportSubscribed(device.id, true);
    await tester.pumpAndSettle();

    await tester.tap(find.text('打开工具箱'));
    await tester.pumpAndSettle();

    expect(find.text('功能工具箱'), findsOneWidget);

    await tester.tap(find.text('自动化调度'));
    await tester.pumpAndSettle();

    expect(autoTriggered, isTrue);
    expect(find.text('功能工具箱'), findsNothing);
  });

  testWidgets('在 showToolboxSheet 打开时系统返回事件优先关闭面板', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ZT.theme(Brightness.dark),
          home: Scaffold(
            body: Builder(
              builder: (ctx) => Center(
                child: ElevatedButton(
                  onPressed: () => showToolboxSheet(
                    context: ctx,
                    device: device,
                    onAutomationPressed: () {},
                    onClaimPressed: () {},
                    onUsagePressed: () {},
                  ),
                  child: const Text('打开工具箱'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('打开工具箱'));
    await tester.pumpAndSettle();
    expect(find.text('功能工具箱'), findsOneWidget);

    final dynamic widgetsBinding = tester.binding;
    await widgetsBinding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('功能工具箱'), findsNothing);
    expect(find.text('打开工具箱'), findsOneWidget);
  });
}
