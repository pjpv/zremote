import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SessionStatus { loading, live, error }

class SessionStatusNotifier extends Notifier<Map<String, SessionStatus>> {
  @override
  Map<String, SessionStatus> build() => const {};

  void report(String deviceId, SessionStatus status) {
    if (state[deviceId] == status) return;
    state = {...state, deviceId: status};
  }

  void forget(String deviceId) {
    if (!state.containsKey(deviceId)) return;
    state = Map.of(state)..remove(deviceId);
  }
}

final sessionStatusProvider =
    NotifierProvider<SessionStatusNotifier, Map<String, SessionStatus>>(
      SessionStatusNotifier.new,
    );
