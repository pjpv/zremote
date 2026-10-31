import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/state/keepalive.dart';
import 'package:zremote/state/session_pool.dart';
import 'package:zremote/ui/manage_page.dart';
import 'package:zremote/ui/tactile_button.dart';

class _FakeDeviceListNotifier extends DeviceListNotifier {
  _FakeDeviceListNotifier(this.initial);

  final List<RemoteDevice> initial;

  @override
  List<RemoteDevice> build() => initial;

  @override
  Future<void> add(RemoteDevice device) async {
    state = [...state, device];
  }
}

class _FakeKeepAliveNotifier extends KeepAliveEnabledNotifier {
  @override
  bool build() => false;
}

RemoteDevice _device(String sid) => RemoteDevice(
      id: 'id-$sid',
      baseUrl: 'https://zcode.z.ai/remote/v4',
      params: {'sid': sid, 'hash': 'h'},
      label: '设备$sid',
      createdAt: DateTime(2026, 1, 1),
    );

Future<void> _pumpManage(WidgetTester tester, List<RemoteDevice> devices) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        deviceListProvider.overrideWith(() => _FakeDeviceListNotifier(devices)),
        keepAliveEnabledProvider.overrideWith(() => _FakeKeepAliveNotifier()),
      ],
      child: MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ManagePage(),
      ),
    ),
  );
}

void main() {
  testWidgets('非法链接（解析失败）不炸元素树：snackbar 提示导入失败', (
    tester,
  ) async {
    final devices = [_device('testdup831')];
    await _pumpManage(tester, devices);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('扫码导入'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('粘贴链接导入'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'not-a-url');
    await tester.pump();
    await tester.tap(find.ancestor(of: find.textContaining('建立连接并导入'), matching: find.byType(TactileButton)).first);
    await tester.pumpAndSettle();
    expect(find.textContaining('导入失败'), findsOneWidget);
  });

  testWidgets('导入去重命中：同一链接第二次导入不新增条目', (tester) async {
    final devices = [_device('testdup831')];
    await _pumpManage(tester, devices);
    await tester.pumpAndSettle();

    const dupUrl =
        'https://zcode.z.ai/remote/v4?sid=testdup831&hash=fake123';

    await tester.tap(find.byTooltip('扫码导入'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('粘贴链接导入'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), dupUrl);
    await tester.pump();
    await tester.tap(find.ancestor(of: find.textContaining('建立连接并导入'), matching: find.byType(TactileButton)).first);
    await tester.pumpAndSettle();

    expect(find.text('设备testdup831'), findsOneWidget);
    expect(find.textContaining('已导入过'), findsOneWidget);
  });

  testWidgets('粘贴弹窗：空态清空键禁用，输入后计数 >0 且清空可用', (tester) async {
    final devices = [_device('testcnt831')];
    await _pumpManage(tester, devices);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('扫码导入'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('粘贴链接导入'));
    await tester.pumpAndSettle();

    expect(find.text('检测到剪贴板包含合法中继凭证'), findsNothing);
    expect(find.text('0 / 256 字符'), findsOneWidget, reason: '初始计数为 0');
    final clearInField = find.descendant(
      of: find.byType(TextField),
      matching: find.byIcon(Icons.close_rounded),
    );
    expect(clearInField, findsNothing);

    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump();

    expect(find.text('3 / 256 字符'), findsOneWidget, reason: '计数随输入更新');
    expect(clearInField, findsOneWidget, reason: '有文本后尾缀清空键出现');
    await tester.tap(clearInField);
    await tester.pump();
    expect(find.text('0 / 256 字符'), findsOneWidget, reason: '清空后计数归零');
  });

  testWidgets('smart-clip：剪贴板合法凭证亮胶囊，点按一键填入', (tester) async {
    const dupUrl =
        'https://zcode.z.ai/remote/v4?sid=clipfill31&hash=fake123';
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.getData') return {'text': dupUrl};
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    final devices = [_device('clipfill31')];
    await _pumpManage(tester, devices);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('扫码导入'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('粘贴链接导入'));
    await tester.pumpAndSettle();

    expect(
      find.text('检测到剪贴板包含合法中继凭证'),
      findsOneWidget,
      reason: '剪贴板有合法凭证且输入框为空，胶囊必须亮起',
    );

    await tester.tap(find.text('检测到剪贴板包含合法中继凭证'));
    await tester.pump();

    expect(find.textContaining(dupUrl), findsWidgets);
    expect(
      find.text('检测到剪贴板包含合法中继凭证'),
      findsNothing,
      reason: '填入后胶囊隐去',
    );
    expect(find.textContaining('/ 256 字符'), findsOneWidget);
  });

  testWidgets('V2 链接可导入并显示 V2 登录提示与徽标', (tester) async {
    await _pumpManage(tester, [_device('testold19')]);
    await tester.pumpAndSettle();

    const v2Url =
        'https://zcode.z.ai/remote/v4?app_version=3.16.1&sid=d_test019'
        '&mid=00000000-0000-4000-8000-000000000000&name=TEST-DESKTOP';

    await tester.tap(find.byTooltip('扫码导入'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('粘贴链接导入'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), v2Url);
    await tester.pump();

    expect(find.text('V2 链接已识别；进入后需在页面内登录账号'), findsOneWidget);
    expect(find.text('格式校验通过'), findsNothing);

    await tester.tap(
      find
          .ancestor(
            of: find.textContaining('建立连接并导入'),
            matching: find.byType(TactileButton),
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(find.text('TEST-DESKTOP'), findsOneWidget);
    expect(find.text('V2 账号'), findsOneWidget);
    expect(find.text('设备testold19'), findsOneWidget);
  });
}
