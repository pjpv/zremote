import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class KeepAliveService {
  KeepAliveService._() : _invoke = ((m) => _channel.invokeMethod(m));

  @visibleForTesting
  KeepAliveService.forTesting(Future<Object?> Function(String method) invoke)
    : _invoke = invoke;

  static final KeepAliveService instance = KeepAliveService._();

  static const MethodChannel _channel = MethodChannel('zremote/keepalive');

  final Future<Object?> Function(String method) _invoke;

  Future<void> start() async {
    try {
      await _invoke('start');
    } catch (_) {
    }
  }

  Future<void> stop() async {
    try {
      await _invoke('stop');
    } catch (_) {}
  }

  Future<bool> get isRunning async {
    try {
      return await _invoke('isRunning') == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get isBatteryIgnored async {
    try {
      return await _invoke('isBatteryIgnored') == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get isBlocked async {
    try {
      return await _invoke('isBlocked') == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> requestBatteryExemption() async {
    try {
      await _invoke('requestBatteryIgnore');
    } catch (_) {}
  }

  Future<void> requestVendorExemption() async {
    try {
      await _invoke('requestVendorExemption');
    } catch (_) {}
  }
}
