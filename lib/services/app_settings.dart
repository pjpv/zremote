import 'package:flutter/services.dart';

abstract final class AppSettings {
  static const MethodChannel _channel = MethodChannel('zremote/app');

  static Future<void> open() async {
    try {
      await _channel.invokeMethod<void>('openAppSettings');
    } catch (_) {}
  }
}
