import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClaimEntryNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => const {};

  void report(String deviceId, bool visible) {
    if (state[deviceId] == visible) return;
    state = {...state, deviceId: visible};
  }

  void reset(String deviceId) => report(deviceId, false);

  void forget(String deviceId) {
    if (!state.containsKey(deviceId)) return;
    state = Map.of(state)..remove(deviceId);
  }
}

final claimEntryProvider =
    NotifierProvider<ClaimEntryNotifier, Map<String, bool>>(
      ClaimEntryNotifier.new,
    );
