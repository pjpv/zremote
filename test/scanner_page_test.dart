import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/ui/manage_page.dart';

Future<void> _pumpScanner(WidgetTester tester) {
  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ScannerPage(),
      ),
    ),
  );
}

void main() {
  testWidgets('普通 resumed 不重建扫码器（防白重启相机回归）', (tester) async {
    await _pumpScanner(tester);
    await tester.pumpAndSettle();

    expect(find.byType(MobileScanner), findsOneWidget);
    final keyBefore =
        tester.widget<MobileScanner>(find.byType(MobileScanner)).key;
    final stateBefore = tester.state<State<MobileScanner>>(
      find.byType(MobileScanner),
    );
    expect(keyBefore, const ValueKey<int>(0));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(
      tester.widget<MobileScanner>(find.byType(MobileScanner)).key,
      keyBefore,
      reason: '无权限拒绝态的 resumed 不得重建扫码器',
    );
    final stateAfter = tester.state<State<MobileScanner>>(
      find.byType(MobileScanner),
    );
    expect(
      identical(stateBefore, stateAfter),
      isTrue,
      reason: 'State 实例更换 = controller 被无谓重启',
    );
  });

  testWidgets('权限被拒后 resumed → 换新 controller 重建（f2984de 修复路径）', (
    tester,
  ) async {
    await _pumpScanner(tester);
    await tester.pumpAndSettle();

    final controllerBefore =
        tester.widget<MobileScanner>(find.byType(MobileScanner)).controller;
    final dynamic pageState = tester.state(find.byType(ScannerPage));
    pageState.debugMarkPermDenied();
    expect(pageState.debugScannerGeneration, 0);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(pageState.debugScannerGeneration, 1, reason: 'resumed 必须重建扫码器');
    expect(
      tester.widget<MobileScanner>(find.byType(MobileScanner)).key,
      const ValueKey<int>(1),
      reason: '代数递增 = MobileScanner 强制销毁重建',
    );
    final controllerAfter =
        tester.widget<MobileScanner>(find.byType(MobileScanner)).controller;
    expect(
      identical(controllerBefore, controllerAfter),
      isFalse,
      reason: '必须换全新 controller 重走权限请求',
    );
  });
}
