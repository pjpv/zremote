import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/state/service_readiness.dart';
import 'package:zremote/ui/toolbox_sheet.dart';

void main() {
  final device = RemoteDevice(
    id: 'd1',
    baseUrl: 'https://relay.example.com',
    params: const {'sid': 'd_test0001', 'app_version': '3.16.1'},
    label: '测试机',
    createdAt: DateTime(2026, 10, 19),
  );

  Future<void> pumpSheet(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ToolboxSheet(
              device: device,
              onAutomationPressed: () {},
              onClaimPressed: () {},
              onUsagePressed: () {},
              onModelSettingsPressed: () {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('unavailable 显示就绪提示，转 ready 后消失', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(serviceReadinessProvider.notifier)
        .report('d1', ServiceReadiness.unavailable);

    await pumpSheet(tester, container);
    expect(find.text('请先在网页中选择电脑并进入会话'), findsOneWidget);

    container
        .read(serviceReadinessProvider.notifier)
        .report('d1', ServiceReadiness.ready);
    await tester.pump();
    expect(find.text('请先在网页中选择电脑并进入会话'), findsNothing);
  });

  testWidgets('unknown 不显示提示（legacy 首连行为不变）', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await pumpSheet(tester, container);
    expect(find.text('请先在网页中选择电脑并进入会话'), findsNothing);
  });

  testWidgets('三张常驻卡保持可点（点按走复查，不因提示锁死）', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(serviceReadinessProvider.notifier)
        .report('d1', ServiceReadiness.unavailable);
    await pumpSheet(tester, container);

    InkWell inkFor(String title) => tester.widget<InkWell>(
      find.ancestor(of: find.text(title), matching: find.byType(InkWell)).first,
    );
    expect(inkFor('模型设置').onTap, isNotNull);
    expect(inkFor('用量统计').onTap, isNotNull);
    expect(inkFor('自动化调度').onTap, isNotNull);
    expect(inkFor('权益中心').onTap, isNull);
  });
}
