import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/event_observer.dart';

class DeviceFeed {
  const DeviceFeed({
    this.unread = 0,
    this.permPending = false,
    this.lastSummary,
  });

  final int unread;

  final bool permPending;

  final String? lastSummary;

  DeviceFeed copyWith({int? unread, bool? permPending, String? lastSummary}) =>
      DeviceFeed(
        unread: unread ?? this.unread,
        permPending: permPending ?? this.permPending,
        lastSummary: lastSummary ?? this.lastSummary,
      );
}

class EventFeedNotifier extends Notifier<Map<String, DeviceFeed>> {
  @override
  Map<String, DeviceFeed> build() => const {};

  void ingest(String deviceId, ObservedEvent event) {
    if (event.type == 'resolved') {
      final current = state[deviceId];
      if (current == null) return;
      state = {
        ...state,
        deviceId: current.copyWith(permPending: false),
      };
      return;
    }
    if (!kNotifiableTypes.contains(event.type)) return;
    final current = state[deviceId] ?? const DeviceFeed();
    state = {
      ...state,
      deviceId: current.copyWith(
        unread: current.unread + 1,
        permPending: current.permPending || event.type == 'permission_request',
        lastSummary: event.summary ?? event.type,
      ),
    };
  }

  void clear(String deviceId) {
    if (!state.containsKey(deviceId)) return;
    state = Map.of(state)..remove(deviceId);
  }

  void forget(String deviceId) => clear(deviceId);
}

final eventFeedProvider =
    NotifierProvider<EventFeedNotifier, Map<String, DeviceFeed>>(
      EventFeedNotifier.new,
    );
