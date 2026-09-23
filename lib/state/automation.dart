import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OffPeakTask {
  const OffPeakTask({
    required this.offPeakTaskId,
    this.title = '',
    this.prompt = '',
    this.status = '',
    this.queuePosition,
    this.workspacePath = '',
    this.permissionMode = 'build',
    this.failureReason,
    this.filesChanged,
    this.queuedAt,
    this.updatedAt,
  });

  final String offPeakTaskId;
  final String title;
  final String prompt;
  final String status;
  final int? queuePosition;
  final String workspacePath;

  final String permissionMode;

  final String? failureReason;

  final int? filesChanged;

  final DateTime? queuedAt;
  final DateTime? updatedAt;

  static OffPeakTask? fromJson(Map<String, dynamic> j) {
    final id = j['offPeakTaskId'];
    if (id is! String || id.isEmpty) return null;
    if (j['historyDeletedAt'] != null) return null;
    return OffPeakTask(
      offPeakTaskId: id,
      title: j['title'] is String ? j['title'] as String : '',
      prompt: j['prompt'] is String ? j['prompt'] as String : '',
      status: j['status'] is String ? j['status'] as String : '',
      queuePosition: j['queuePosition'] is num
          ? (j['queuePosition'] as num).toInt()
          : null,
      workspacePath: j['workspacePath'] is String
          ? j['workspacePath'] as String
          : '',
      permissionMode: j['permissionMode'] is String
          ? j['permissionMode'] as String
          : 'build',
      failureReason: j['failureReason'] is String
          ? j['failureReason'] as String
          : null,
      filesChanged: j['filesChanged'] is num
          ? (j['filesChanged'] as num).toInt()
          : null,
      queuedAt: _msToDateTime(j['queuedAt']),
      updatedAt: _msToDateTime(j['updatedAt']),
    );
  }

  static DateTime? _msToDateTime(dynamic v) =>
      v is num ? DateTime.fromMillisecondsSinceEpoch(v.toInt()) : null;

  @override
  bool operator ==(Object other) =>
      other is OffPeakTask &&
      other.offPeakTaskId == offPeakTaskId &&
      other.title == title &&
      other.prompt == prompt &&
      other.status == status &&
      other.queuePosition == queuePosition &&
      other.workspacePath == workspacePath &&
      other.permissionMode == permissionMode &&
      other.failureReason == failureReason &&
      other.filesChanged == filesChanged &&
      other.queuedAt == queuedAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hashAll([
        offPeakTaskId,
        title,
        prompt,
        status,
        queuePosition,
        workspacePath,
        permissionMode,
        failureReason,
        filesChanged,
        queuedAt,
        updatedAt,
      ]);
}

class Automation {
  const Automation({
    required this.automationId,
    this.title = '',
    this.prompt = '',
    this.cronExpr = '',
    this.enabled = false,
    this.recurring = false,
    this.workspacePath = '',
    this.mode = '',
    this.model = '',
    this.thoughtLevel = '',
    this.nextRunAt,
    this.lastRunAt,
    this.runCount = 0,
  });

  final String automationId;
  final String title;
  final String prompt;
  final String cronExpr;
  final bool enabled;
  final bool recurring;
  final String workspacePath;
  final String mode;
  final String model;
  final String thoughtLevel;
  final DateTime? nextRunAt;
  final DateTime? lastRunAt;
  final int runCount;

  static Automation? fromJson(Map<String, dynamic> j) {
    final id = j['automationId'];
    if (id is! String || id.isEmpty) return null;
    return Automation(
      automationId: id,
      title: j['title'] is String ? j['title'] as String : '',
      prompt: j['prompt'] is String ? j['prompt'] as String : '',
      cronExpr: j['cronExpr'] is String ? j['cronExpr'] as String : '',
      enabled: j['enabled'] == true,
      recurring: j['recurring'] == true,
      workspacePath: j['workspacePath'] is String
          ? j['workspacePath'] as String
          : '',
      mode: j['mode'] is String ? j['mode'] as String : '',
      model: j['model'] is String ? j['model'] as String : '',
      thoughtLevel: j['thoughtLevel'] is String
          ? j['thoughtLevel'] as String
          : '',
      nextRunAt: OffPeakTask._msToDateTime(j['nextRunAt']),
      lastRunAt: OffPeakTask._msToDateTime(j['lastRunAt']),
      runCount: j['runCount'] is num ? (j['runCount'] as num).toInt() : 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Automation &&
      other.automationId == automationId &&
      other.title == title &&
      other.prompt == prompt &&
      other.cronExpr == cronExpr &&
      other.enabled == enabled &&
      other.recurring == recurring &&
      other.workspacePath == workspacePath &&
      other.mode == mode &&
      other.model == model &&
      other.thoughtLevel == thoughtLevel &&
      other.nextRunAt == nextRunAt &&
      other.lastRunAt == lastRunAt &&
      other.runCount == runCount;

  @override
  int get hashCode => Object.hashAll([
        automationId,
        title,
        prompt,
        cronExpr,
        enabled,
        recurring,
        workspacePath,
        mode,
        model,
        thoughtLevel,
        nextRunAt,
        lastRunAt,
        runCount,
      ]);
}

class AutomationBoard {
  const AutomationBoard({
    this.subscribed = false,
    this.offPeak = const [],
    this.automations = const [],
    this.recentProjects = const [],
  });

  final bool subscribed;

  final List<OffPeakTask> offPeak;
  final List<Automation> automations;
  final List<String> recentProjects;

  int get queuedCount =>
      offPeak.where((t) => t.status == 'queued').length;

  AutomationBoard copyWith({
    bool? subscribed,
    List<OffPeakTask>? offPeak,
    List<Automation>? automations,
    List<String>? recentProjects,
  }) => AutomationBoard(
    subscribed: subscribed ?? this.subscribed,
    offPeak: offPeak ?? this.offPeak,
    automations: automations ?? this.automations,
    recentProjects: recentProjects ?? this.recentProjects,
  );

  @override
  bool operator ==(Object other) =>
      other is AutomationBoard &&
      other.subscribed == subscribed &&
      listEquals(other.offPeak, offPeak) &&
      listEquals(other.automations, automations) &&
      listEquals(other.recentProjects, recentProjects);

  @override
  int get hashCode => Object.hash(
        subscribed,
        Object.hashAll(offPeak),
        Object.hashAll(automations),
        Object.hashAll(recentProjects),
      );
}

class AutomationNotifier extends Notifier<Map<String, AutomationBoard>> {
  @override
  Map<String, AutomationBoard> build() => const {};

  AutomationBoard _boardOf(String deviceId) =>
      state[deviceId] ?? const AutomationBoard();

  void _put(String deviceId, AutomationBoard board) {
    if (state[deviceId] == board) return;
    state = {...state, deviceId: board};
  }

  void reportSubscribed(String deviceId, bool subscribed) {
    final board = _boardOf(deviceId);
    if (subscribed) {
      _put(deviceId, board.copyWith(subscribed: true));
    } else {
      _put(
        deviceId,
        board.copyWith(subscribed: false, offPeak: const [], automations: const []),
      );
    }
  }

  void replaceOffPeak(String deviceId, List<Map<String, dynamic>> raw) {
    final tasks = <OffPeakTask>[
      for (final item in raw) ?OffPeakTask.fromJson(item),
    ];
    _put(deviceId, _boardOf(deviceId).copyWith(offPeak: tasks));
  }

  void replaceAutomations(String deviceId, List<Map<String, dynamic>> raw) {
    final automations = <Automation>[
      for (final item in raw) ?Automation.fromJson(item),
    ];
    _put(deviceId, _boardOf(deviceId).copyWith(automations: automations));
  }

  void upsertOffPeak(String deviceId, Map<String, dynamic> raw) {
    final deletedId = raw['historyDeletedAt'] != null ? raw['offPeakTaskId'] : null;
    if (deletedId is String && deletedId.isNotEmpty) {
      removeOffPeak(deviceId, deletedId);
      return;
    }
    final task = OffPeakTask.fromJson(raw);
    if (task == null) return;
    final board = _boardOf(deviceId);
    final tasks = [...board.offPeak];
    final index = tasks.indexWhere((t) => t.offPeakTaskId == task.offPeakTaskId);
    if (index >= 0) {
      tasks[index] = task;
    } else {
      tasks.insert(0, task);
    }
    _put(deviceId, board.copyWith(offPeak: tasks));
  }

  void upsertAutomation(String deviceId, Map<String, dynamic> raw) {
    final auto = Automation.fromJson(raw);
    if (auto == null) return;
    final board = _boardOf(deviceId);
    final automations = [...board.automations];
    final index = automations.indexWhere(
      (a) => a.automationId == auto.automationId,
    );
    if (index >= 0) {
      automations[index] = auto;
    } else {
      automations.insert(0, auto);
    }
    _put(deviceId, board.copyWith(automations: automations));
  }

  void removeOffPeak(String deviceId, String id) {
    final board = _boardOf(deviceId);
    if (!board.offPeak.any((t) => t.offPeakTaskId == id)) return;
    _put(
      deviceId,
      board.copyWith(
        offPeak: board.offPeak
            .where((t) => t.offPeakTaskId != id)
            .toList(),
      ),
    );
  }

  void removeAutomation(String deviceId, String id) {
    final board = _boardOf(deviceId);
    if (!board.automations.any((a) => a.automationId == id)) return;
    _put(
      deviceId,
      board.copyWith(
        automations: board.automations
            .where((a) => a.automationId != id)
            .toList(),
      ),
    );
  }

  void reportProjects(String deviceId, List<String> projects) {
    _put(deviceId, _boardOf(deviceId).copyWith(recentProjects: projects));
  }

  void forget(String deviceId) {
    if (!state.containsKey(deviceId)) return;
    state = Map.of(state)..remove(deviceId);
  }
}

final automationProvider =
    NotifierProvider<AutomationNotifier, Map<String, AutomationBoard>>(
      AutomationNotifier.new,
    );
