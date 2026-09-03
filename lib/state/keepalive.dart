import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/device_store.dart';
import '../services/keepalive.dart';
import 'app_lifecycle.dart';
import 'session_pool.dart';

class KeepAliveEnabledNotifier extends Notifier<bool> {
  KeepAliveEnabledNotifier({this.initial = true});

  final bool initial;

  @override
  bool build() {
    _load();
    return initial;
  }

  Future<void> _load() async {
    state = await DeviceStore.instance.keepAliveEnabled();
  }

  Future<void> set(bool value) async {
    await DeviceStore.instance.setKeepAliveEnabled(value);
    state = value;
  }
}

final keepAliveEnabledProvider = NotifierProvider<KeepAliveEnabledNotifier,
    bool>(KeepAliveEnabledNotifier.new);

enum KeepAliveDecision { run, stop }

KeepAliveDecision keepAliveDecision({
  required bool enabled,
  required bool hasDevices,
}) => enabled && hasDevices ? KeepAliveDecision.run : KeepAliveDecision.stop;

final keepAliveControllerProvider = Provider<void>((ref) {
  void sync() => _syncService(ref);
  ref.listen(keepAliveEnabledProvider, (_, _) => sync(), fireImmediately: true);
  ref.listen(deviceListProvider, (_, _) => sync());
  ref.listen(appLifecycleProvider, (_, next) {
    if (next == AppLifecycleState.resumed) sync();
  });
});

int _syncGeneration = 0;

Future<void> _syncService(Ref ref) async {
  final generation = ++_syncGeneration;
  final decision = keepAliveDecision(
    enabled: ref.read(keepAliveEnabledProvider),
    hasDevices: ref.read(deviceListProvider).isNotEmpty,
  );
  if (generation != _syncGeneration) return;
  if (decision == KeepAliveDecision.run) {
    await KeepAliveService.instance.start();
  } else {
    await KeepAliveService.instance.stop();
  }
}
