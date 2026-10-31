import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ServiceReadiness { unknown, ready, unavailable }

bool serviceNeedsProbe(ServiceReadiness readiness) =>
    readiness == ServiceReadiness.unavailable;

class ServiceReadinessNotifier
    extends Notifier<Map<String, ServiceReadiness>> {
  @override
  Map<String, ServiceReadiness> build() => const {};

  void report(String deviceId, ServiceReadiness readiness) {
    if ((state[deviceId] ?? ServiceReadiness.unknown) == readiness) return;
    state = {...state, deviceId: readiness};
  }

  void reset(String deviceId) => report(deviceId, ServiceReadiness.unknown);

  void forget(String deviceId) {
    if (!state.containsKey(deviceId)) return;
    state = Map.of(state)..remove(deviceId);
  }
}

final serviceReadinessProvider =
    NotifierProvider<ServiceReadinessNotifier, Map<String, ServiceReadiness>>(
      ServiceReadinessNotifier.new,
    );
