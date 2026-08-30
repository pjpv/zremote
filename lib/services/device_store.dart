import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/device.dart';
import '../models/notification_prefs.dart';

class DeviceStore {
  DeviceStore._();

  static final DeviceStore instance = DeviceStore._();

  static const _indexKey = 'zremote.device.index';
  static const _deviceKeyPrefix = 'zremote.device.';
  static const _biometricKey = 'zremote.biometricEnabled';

  final _secure = const FlutterSecureStorage();

  Future<List<RemoteDevice>> loadAll() async {
    final indexRaw = await _secure.read(key: _indexKey);
    if (indexRaw == null) return [];
    final ids = (jsonDecode(indexRaw) as List).cast<String>();
    final devices = <RemoteDevice>[];
    for (final id in ids) {
      final raw = await _secure.read(key: _deviceKey(id));
      if (raw == null) continue;
      try {
        devices.add(
          RemoteDevice.fromJson(jsonDecode(raw) as Map<String, dynamic>),
        );
      } catch (_) {
      }
    }
    return devices;
  }

  Future<void> add(RemoteDevice device) async {
    final ids = await _readIndex();
    if (!ids.contains(device.id)) ids.add(device.id);
    await _secure.write(
      key: _deviceKey(device.id),
      value: jsonEncode(device.toJson()),
    );
    await _secure.write(key: _indexKey, value: jsonEncode(ids));
  }

  Future<void> update(RemoteDevice device) => _secure.write(
    key: _deviceKey(device.id),
    value: jsonEncode(device.toJson()),
  );

  Future<void> remove(String id) async {
    await _secure.delete(key: _deviceKey(id));
    final ids = await _readIndex();
    ids.remove(id);
    await _secure.write(key: _indexKey, value: jsonEncode(ids));
  }

  Future<List<String>> _readIndex() async {
    final raw = await _secure.read(key: _indexKey);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List).cast<String>();
    } catch (_) {
      return [];
    }
  }

  String _deviceKey(String id) => '$_deviceKeyPrefix$id';

  Future<bool> biometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricKey) ?? false;
  }

  Future<void> setBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, value);
  }

  static const _keepAliveKey = 'zremote.keepalive';

  Future<bool> keepAliveEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keepAliveKey) ?? true;
  }

  Future<void> setKeepAliveEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keepAliveKey, value);
  }

  static const _notifApprovalKey = 'zremote.notify.approval';
  static const _notifCompleteKey = 'zremote.notify.complete';
  static const _notifFailKey = 'zremote.notify.fail';

  Future<NotificationPrefs> notificationPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationPrefs(
      approval: prefs.getBool(_notifApprovalKey) ?? true,
      complete: prefs.getBool(_notifCompleteKey) ?? false,
      fail: prefs.getBool(_notifFailKey) ?? false,
    );
  }

  Future<void> setNotificationPrefs(NotificationPrefs value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifApprovalKey, value.approval);
    await prefs.setBool(_notifCompleteKey, value.complete);
    await prefs.setBool(_notifFailKey, value.fail);
  }
}
