import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/app_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('open 调用 zremote/app 通道的 openAppSettings 方法', () async {
    const channel = MethodChannel('zremote/app');
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    await AppSettings.open();

    expect(calls, hasLength(1));
    expect(calls.first.method, 'openAppSettings');
  });

  test('通道异常吞掉不外抛（引导失败回到现状，不崩）', () async {
    const channel = MethodChannel('zremote/app');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'open_failed');
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    await AppSettings.open();
  });
}
