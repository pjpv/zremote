import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/event_observer.dart';

abstract final class SessionRanking {
  static int compareSessions(SessionState a, SessionState b) {
    final aRunning = a.phase == 'running';
    final bRunning = b.phase == 'running';
    if (aRunning != bRunning) return aRunning ? -1 : 1;
    if (aRunning) {
      final byCreated = (b.createdAt ?? 0).compareTo(a.createdAt ?? 0);
      if (byCreated != 0) return byCreated;
      return a.sessionId.compareTo(b.sessionId);
    }
    final byRecency = (b.lastActivityAt ?? -1).compareTo(
      a.lastActivityAt ?? -1,
    );
    if (byRecency != 0) return byRecency;
    final byCreated = (b.createdAt ?? 0).compareTo(a.createdAt ?? 0);
    if (byCreated != 0) return byCreated;
    return a.sessionId.compareTo(b.sessionId);
  }
}

class SessionIndexNotifier
    extends Notifier<Map<String, Map<String, SessionState>>> {
  final Map<String, Map<String, SessionState>> _tasks = {};
  final Map<String, Map<String, SessionState>> _sessions = {};

  @override
  Map<String, Map<String, SessionState>> build() => const {};

  void upsertAll(String deviceId, List<SessionState> states) {
    if (states.isEmpty) return;
    final m = Map.of(_sessions[deviceId] ?? const <String, SessionState>{});
    for (final s in states) {
      m[s.sessionId] = s;
    }
    _sessions[deviceId] = m;
    _rebuild(deviceId);
  }

  void upsertTasks(String deviceId, List<SessionState> taskEntries) {
    if (taskEntries.isEmpty) return;
    final m = Map.of(_tasks[deviceId] ?? const <String, SessionState>{});
    for (final t in taskEntries) {
      m[t.sessionId] = t;
    }
    _tasks[deviceId] = m;
    _rebuild(deviceId);
  }

  void replaceTasks(
    String deviceId,
    List<SessionState> taskEntries, {
    bool preservePinned = false,
  }) {
    final prev = _tasks[deviceId];
    _tasks[deviceId] = {
      for (final t in taskEntries)
        t.sessionId: preservePinned &&
                !t.pinned &&
                (prev?[t.sessionId]?.pinned ?? false)
            ? _withPinned(t, true)
            : t,
    };
    _rebuild(deviceId);
  }

  static SessionState _withPinned(SessionState s, bool pinned) =>
      SessionState(
        sessionId: s.sessionId,
        title: s.title,
        phase: s.phase,
        sessionEnded: s.sessionEnded,
        permissionCount: s.permissionCount,
        userInputCount: s.userInputCount,
        interactionKind: s.interactionKind,
        toolName: s.toolName,
        description: s.description,
        lastActivityAt: s.lastActivityAt,
        createdAt: s.createdAt,
        workspace: s.workspace,
        pinned: pinned,
      );

  void removeSessions(String deviceId, List<String> sessionIds) {
    if (sessionIds.isEmpty) return;
    var touched = false;
    for (final store in [_tasks, _sessions]) {
      final m = store[deviceId];
      if (m == null) continue;
      for (final id in sessionIds) {
        touched |= m.remove(id) != null;
      }
      if (m.isEmpty) store.remove(deviceId);
    }
    if (touched) _rebuild(deviceId);
  }

  void forget(String deviceId) {
    _tasks.remove(deviceId);
    _sessions.remove(deviceId);
    if (!state.containsKey(deviceId)) return;
    state = Map.of(state)..remove(deviceId);
  }

  void _rebuild(String deviceId) {
    final tasks = _tasks[deviceId];
    final sessions = _sessions[deviceId];
    if ((tasks == null || tasks.isEmpty) &&
        (sessions == null || sessions.isEmpty)) {
      if (!state.containsKey(deviceId)) return;
      state = Map.of(state)..remove(deviceId);
      return;
    }
    final ids = <String>{
      ...?tasks?.keys,
      ...?sessions?.keys,
    };
    final merged = <String, SessionState>{
      for (final id in ids) id: _mergeTaskSession(tasks?[id], sessions?[id]),
    };
    state = {...state, deviceId: merged};
  }

  static SessionState _mergeTaskSession(SessionState? task, SessionState? s) {
    if (s == null) return task!;
    if (task == null) return s;
    return SessionState(
      sessionId: s.sessionId,
      title: task.title ?? s.title,
      phase: s.phase ?? task.phase,
      sessionEnded: s.sessionEnded ?? task.sessionEnded,
      permissionCount: s.permissionCount,
      userInputCount: s.userInputCount,
      interactionKind: s.interactionKind,
      toolName: s.toolName,
      description: s.description,
      lastActivityAt: s.lastActivityAt ?? task.lastActivityAt,
      createdAt: s.createdAt ?? task.createdAt,
      workspace: task.workspace ?? s.workspace,
      pinned: task.pinned,
    );
  }
}

final sessionIndexProvider =
    NotifierProvider<SessionIndexNotifier, Map<String, Map<String, SessionState>>>(
      SessionIndexNotifier.new,
    );

abstract final class RelativeTime {
  static ({String kind, int n}) format(int? lastActivityAtMs, int nowMs) {
    final diff = lastActivityAtMs == null ? null : nowMs - lastActivityAtMs;
    if (diff == null || diff < 0) return (kind: 'now', n: 0);
    if (diff < 60 * 1000) return (kind: 'now', n: 0);
    if (diff < 3600 * 1000) return (kind: 'minute', n: diff ~/ (60 * 1000));
    if (diff < 24 * 3600 * 1000) {
      return (kind: 'hour', n: diff ~/ (3600 * 1000));
    }
    return (kind: 'day', n: diff ~/ (24 * 3600 * 1000));
  }
}

abstract final class SessionGrouping {
  static List<MapEntry<String, List<SessionState>>> groupByDay(
    List<SessionState> sorted,
    DateTime now, {
    bool weekStartsMonday = true,
  }) {
    final pinned = <SessionState>[];
    final rest = <SessionState>[];
    for (final s in sorted) {
      (s.pinned ? pinned : rest).add(s);
    }
    final out = <MapEntry<String, List<SessionState>>>[];
    if (pinned.isNotEmpty) out.add(MapEntry('pinned', pinned));

    final groups = <String, List<SessionState>>{};
    final order = <String>[];
    for (final s in rest) {
      final key = _keyOf(s, now, weekStartsMonday);
      if (!groups.containsKey(key)) {
        groups[key] = <SessionState>[];
        order.add(key);
      }
      groups[key]!.add(s);
    }
    out.addAll([for (final key in order) MapEntry(key, groups[key]!)]);
    return out;
  }

  static String _keyOf(SessionState s, DateTime now, bool weekStartsMonday) {
    final laa = s.lastActivityAt;
    if (laa == null) return 'unknown';
    final then = DateTime.fromMillisecondsSinceEpoch(laa);
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(then.year, then.month, then.day);
    final days = today.difference(day).inDays;
    if (days <= 0) return 'today';
    if (days == 1) return 'yesterday';
    if (days <= 3) return 'day:$days';

    final weekStart = _startOfWeek(now, weekStartsMonday);
    if (!then.isBefore(weekStart)) return 'thisWeek';
    if (!then.isBefore(weekStart.subtract(const Duration(days: 7)))) {
      return 'lastWeek';
    }
    if (!then.isBefore(DateTime(now.year, now.month))) return 'thisMonth';
    if (!then.isBefore(DateTime(now.year, now.month - 1))) return 'lastMonth';
    return 'older';
  }

  static DateTime _startOfWeek(DateTime now, bool weekStartsMonday) {
    final today = DateTime(now.year, now.month, now.day);
    final dow = today.weekday;
    final shift = weekStartsMonday ? dow - 1 : dow % 7;
    return today.subtract(Duration(days: shift));
  }
}
