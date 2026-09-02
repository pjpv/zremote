import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/state/session_pool.dart';
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

  _replaceGroup();
}

class _StubDevices extends DeviceListNotifier {
  _StubDevices(this.devices);

  final List<RemoteDevice> devices;

  @override
  List<RemoteDevice> build() => devices;
}

RemoteDevice _device(String id, String sid) => RemoteDevice(
  id: id,
  baseUrl: 'https://zcode.z.ai/remote/v4',
  params: {'sid': sid, 'hash': 'h-$id'},
  label: '',
  createdAt: DateTime(2026),
);

BarcodeCapture _capture(String url) =>
    BarcodeCapture(barcodes: [Barcode(rawValue: url)]);

Future<void> _pumpReplace(
  WidgetTester tester,
  List<RemoteDevice> devices,
  RemoteDevice replaceOf,
) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [deviceListProvider.overrideWith(() => _StubDevices(devices))],
      child: MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScannerPage(replaceOf: replaceOf),
      ),
    ),
  );
}

void _replaceGroup() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    const channel = MethodChannel(
      'plugins.it_nomads.com/flutter_secure_storage',
    );
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      return null;
    });
  });

  testWidgets('更换模式提示文案切换为「对准新的二维码」', (tester) async {
    final a = _device('a', 'sid-a');
    await _pumpReplace(tester, [a], a);
    await tester.pumpAndSettle();

    expect(find.text('对准电脑端新的远程控制二维码'), findsOneWidget);
  });

  testWidgets('扫到撞其他设备 sid 的码 → 拒绝更换（防重复接入），身份不动', (tester) async {
    final a = _device('a', 'sid-a');
    final b = _device('b', 'sid-b');
    await _pumpReplace(tester, [a, b], b);
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ScannerPage)),
    );

    final scanner = tester.widget<MobileScanner>(find.byType(MobileScanner));
    scanner.onDetect!(
      _capture('https://zcode.z.ai/remote/v4?sid=sid-a&hash=newhash'),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    final devices = container.read(deviceListProvider);
    expect(devices.length, 2, reason: '不得新增条目');
    expect(devices[1].id, 'b');
    expect(devices[1].sid, 'sid-b', reason: '撞车时目标设备身份不得被改写');
    expect(find.byType(ScannerPage), findsNothing, reason: '拒绝后收场返回');
  });

  testWidgets('扫到合法新链接 → 原条目换新身份，不新增设备', (tester) async {
    final a = _device('a', 'sid-a');
    final b = _device('b', 'sid-b');
    await _pumpReplace(tester, [a, b], b);
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ScannerPage)),
    );

    final scanner = tester.widget<MobileScanner>(find.byType(MobileScanner));
    scanner.onDetect!(
      _capture('https://zcode.z.ai/remote/v4?sid=sid-b2&hash=newhash'),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final devices = container.read(deviceListProvider);
    expect(devices.length, 2, reason: '更换不新增条目');
    expect(devices[1].id, 'b', reason: 'id 不变：保活/通知/恢复不断线');
    expect(devices[1].sid, 'sid-b2', reason: '控制身份已换成新链接');
    expect(devices[1].params['hash'], 'newhash');
  });
}
