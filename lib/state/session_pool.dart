import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device.dart';
import '../services/device_store.dart';

class DeviceListNotifier extends Notifier<List<RemoteDevice>> {
  @override
  List<RemoteDevice> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    state = await DeviceStore.instance.loadAll();
  }

  Future<void> add(RemoteDevice device) async {
    await DeviceStore.instance.add(device);
    state = [...state, device];
  }

  Future<void> rename(String id, String label) async {
    RemoteDevice? target;
    for (final d in state) {
      if (d.id == id) {
        target = d;
        break;
      }
    }
    if (target == null || label.trim().isEmpty) return;
    final updated = target.copyWith(label: label.trim());
    await DeviceStore.instance.update(updated);
    state = [
      for (final d in state)
        if (d.id == id) updated else d,
    ];
  }

  Future<void> remove(String id) async {
    await DeviceStore.instance.remove(id);
    state = state.where((d) => d.id != id).toList();
  }
}

final deviceListProvider =
    NotifierProvider<DeviceListNotifier, List<RemoteDevice>>(
      DeviceListNotifier.new,
    );

class ActiveTabNotifier extends Notifier<int> {
  bool _restoreDone = false;

  bool _jumpedBeforeRestore = false;

  @override
  int build() => 0;

  void set(int index) {
    final count = ref.read(deviceListProvider).length;
    if (index < 0 || index > count) return;
    state = index;
    if (index < count) {
      _jumpedBeforeRestore = true;
      unawaited(
        DeviceStore.instance.setLastDeviceId(
          ref.read(deviceListProvider)[index].id,
        ).catchError((e) {
          debugPrint('[ZR] lastDevice 落盘失败: $e');
        }),
      );
    }
  }

  Future<void> restoreLast() async {
    if (_restoreDone || _jumpedBeforeRestore) return;
    _restoreDone = true;
    final id = await DeviceStore.instance.lastDeviceId();
    if (_jumpedBeforeRestore) return;
    if (id == null) return;
    final index = ref.read(deviceListProvider).indexWhere((d) => d.id == id);
    if (index >= 0) state = index;
  }

  void clampTo(int childCount) {
    if (state >= childCount) state = childCount - 1;
    if (state < 0) state = 0;
  }
}

final activeTabProvider = NotifierProvider<ActiveTabNotifier, int>(
  ActiveTabNotifier.new,
);

class BiometricNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    state = await DeviceStore.instance.biometricEnabled();
  }

  Future<void> set(bool value) async {
    await DeviceStore.instance.setBiometricEnabled(value);
    state = value;
  }
}

final biometricProvider = NotifierProvider<BiometricNotifier, bool>(
  BiometricNotifier.new,
);
