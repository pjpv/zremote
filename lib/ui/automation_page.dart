import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/device.dart';
import '../models/device_label.dart';
import '../services/rpc_bridge.dart';
import '../state/automation.dart';
import '../state/session_status.dart';
import '../theme.dart';
import 'automation_form.dart';
import 'bevel_card.dart';
import 'hw_chip.dart';
import 'schedule_dial.dart';
import 'showcase_bits.dart';

class AutomationPage extends ConsumerStatefulWidget {
  const AutomationPage({super.key, required this.device, required this.bridge});

  final RemoteDevice device;
  final RpcBridge bridge;

  @override
  ConsumerState<AutomationPage> createState() => _AutomationPageState();
}

class _AutomationPageState extends ConsumerState<AutomationPage> {
  int _tabIndex = 0;
  Timer? _pollTimer;

  bool _refreshing = false;

  final Set<String> _busy = {};
  AutomationNotifier? _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(automationProvider.notifier);
    _refresh();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) => _refresh());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      try {
        final r = await widget.bridge.call('off-peak-task', 'list');
        _notifier?.replaceOffPeak(widget.device.id, _objectsOf(r));
      } catch (_) {}
      try {
        final r = await widget.bridge.call('zcode-agent', 'listAllAutomations');
        _notifier?.replaceAutomations(widget.device.id, _objectsOf(r));
      } catch (_) {}
    } finally {
      _refreshing = false;
    }
  }

  static List<Map<String, dynamic>> _objectsOf(RpcResponse r) => [
    for (final value in r.values)
      if (value is Map<String, dynamic>) value,
  ];

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _guard(
    String id,
    Future<void> Function() op, {
    void Function()? onFailure,
  }) async {
    if (_busy.contains(id)) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy.add(id));
    try {
      await op();
    } catch (_) {
      onFailure?.call();
      if (mounted) _snack(l10n.automationOpFailed);
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  Future<bool> _confirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: context.zt.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result == true;
  }

  Future<void> _pauseTask(OffPeakTask task) =>
      _guard(task.offPeakTaskId, () async {
        final r = await widget.bridge.call(
          'off-peak-task',
          'pauseTask',
          params: task.offPeakTaskId,
        );
        final obj = r.firstObject;
        if (obj != null) _notifier?.upsertOffPeak(widget.device.id, obj);
      });

  Future<void> _resumeTask(OffPeakTask task) =>
      _guard(task.offPeakTaskId, () async {
        final r = await widget.bridge.call(
          'off-peak-task',
          'continueTask',
          params: task.offPeakTaskId,
        );
        final obj = r.firstObject;
        if (obj != null) _notifier?.upsertOffPeak(widget.device.id, obj);
      });

  Future<void> _cancelTask(OffPeakTask task, {required bool confirm}) async {
    if (confirm) {
      final l10n = AppLocalizations.of(context)!;
      final ok = await _confirmDialog(
        title: l10n.automationDeleteTitle,
        body: l10n.automationCancelRunningBody,
        confirmLabel: l10n.automationCancel,
      );
      if (!ok) return;
    }
    await _guard(task.offPeakTaskId, () async {
      final r = await widget.bridge.call(
        'off-peak-task',
        'cancelTask',
        params: task.offPeakTaskId,
      );
      final obj = r.firstObject;
      if (obj != null) {
        _notifier?.upsertOffPeak(widget.device.id, obj);
      } else {
        _notifier?.removeOffPeak(widget.device.id, task.offPeakTaskId);
      }
    });
  }

  Future<void> _deleteTask(OffPeakTask task) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await _confirmDialog(
      title: l10n.automationDeleteTitle,
      body: l10n.automationDeleteOffPeakBody,
      confirmLabel: l10n.automationDelete,
    );
    if (!ok) return;
    await _guard(task.offPeakTaskId, () async {
      await widget.bridge.call(
        'off-peak-task',
        'deleteTask',
        params: task.offPeakTaskId,
      );
      _notifier?.removeOffPeak(widget.device.id, task.offPeakTaskId);
    });
  }

  Future<void> _toggleAutomation(Automation auto, bool next) async {
    _notifier?.upsertAutomation(widget.device.id, {
      ..._automationRaw(auto),
      'enabled': next,
    });
    await _guard(
      auto.automationId,
      () async {
        await widget.bridge.call(
          'zcode-agent',
          'setAutomationEnabled',
          params: {
            'workspacePath': auto.workspacePath,
            'automationId': auto.automationId,
            'enabled': next,
          },
        );
      },
      onFailure: () {
        _notifier?.upsertAutomation(widget.device.id, {
          ..._automationRaw(auto),
          'enabled': !next,
        });
      },
    );
  }

  Future<void> _runAutomationNow(Automation auto) =>
      _guard(auto.automationId, () async {
        final l10n = AppLocalizations.of(context)!;
        final r = await widget.bridge.call(
          'zcode-agent',
          'runAutomationNow',
          params: {
            'workspacePath': auto.workspacePath,
            'automationId': auto.automationId,
          },
        );
        final status = r.firstObject?['status'];
        if (mounted) {
          _snack(
            status == 'duplicate'
                ? l10n.automationRunDuplicate
                : l10n.automationRunQueued,
          );
        }
      });

  Future<void> _deleteAutomation(Automation auto) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await _confirmDialog(
      title: l10n.automationDeleteTitle,
      body: l10n.automationDeleteScheduledBody,
      confirmLabel: l10n.automationDelete,
    );
    if (!ok) return;
    await _guard(auto.automationId, () async {
      await widget.bridge.call(
        'zcode-agent',
        'deleteAutomation',
        params: {
          'workspacePath': auto.workspacePath,
          'automationId': auto.automationId,
        },
      );
      _notifier?.removeAutomation(widget.device.id, auto.automationId);
    });
  }

  static Map<String, dynamic> _automationRaw(Automation a) => {
    'automationId': a.automationId,
    'title': a.title,
    'prompt': a.prompt,
    'cronExpr': a.cronExpr,
    'enabled': a.enabled,
    'recurring': a.recurring,
    'workspacePath': a.workspacePath,
    'mode': a.mode,
    'model': a.model,
    'thoughtLevel': a.thoughtLevel,
    if (a.nextRunAt != null) 'nextRunAt': a.nextRunAt!.millisecondsSinceEpoch,
    if (a.lastRunAt != null) 'lastRunAt': a.lastRunAt!.millisecondsSinceEpoch,
    'runCount': a.runCount,
  };

  void _openForm({
    required AutomationFormKind kind,
    Automation? editing,
    OffPeakTask? editingOffPeak,
    String? prefillTitle,
    String? prefillPrompt,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AutomationFormPage(
          bridge: widget.bridge,
          kind: kind,
          device: widget.device,
          editing: editing,
          editingOffPeak: editingOffPeak,
          prefillTitle: prefillTitle,
          prefillPrompt: prefillPrompt,
        ),
      ),
    );
  }

  void _create() => _openForm(
    kind: _tabIndex == 0
        ? AutomationFormKind.offPeak
        : AutomationFormKind.scheduled,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final board =
        ref.watch(automationProvider)[widget.device.id] ??
        const AutomationBoard();
    final status = ref.watch(sessionStatusProvider)[widget.device.id];
    final offline = status != SessionStatus.live;
    final live = status == SessionStatus.live;
    final zt = context.zt;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.automationCenterTitle),
        actions: [
          if (_tabIndex == 0)
            IconButton(
              tooltip: l10n.automationTabScheduled,
              onPressed: () => setState(() => _tabIndex = 1),
              icon: const Icon(Icons.schedule_outlined),
            )
          else
            IconButton(
              tooltip: l10n.automationNew,
              onPressed: offline ? null : _create,
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ZrScopeDock(
            label: l10n.automationScopeLabel,
            name: widget.device.displayName(l10n),
            tag: live ? l10n.automationRelayOnline : l10n.automationRelayOffline,
            dotColor: live ? zt.live : zt.danger,
          ),
          if (offline)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: zt.danger.withValues(alpha: 0.10),
                border: Border(
                  left: BorderSide(color: zt.danger, width: 3),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: zt.danger,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.automationOfflineHint,
                      style: TextStyle(fontSize: 12, color: zt.textLo),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
            child: ZrSegmented(
              segments: [
                ('off', l10n.automationTabOffPeak),
                ('sched', l10n.automationTabScheduled),
              ],
              active: _tabIndex == 0 ? 'off' : 'sched',
              onChanged: (value) =>
                  setState(() => _tabIndex = value == 'off' ? 0 : 1),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                _offPeakTab(l10n, board, offline),
                _scheduledTab(l10n, board, offline),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ZrDockButton(
        icon: Icons.add,
        label: _tabIndex == 0
            ? l10n.automationDockOffPeak(widget.device.displayName(l10n))
            : l10n.automationDockScheduled(widget.device.displayName(l10n)),
        onPressed: offline ? null : _create,
      ),
    );
  }

  Widget _offPeakTab(
    AppLocalizations l10n,
    AutomationBoard board,
    bool offline,
  ) {
    if (board.offPeak.isEmpty) {
      return _EmptyState(
        icon: Icons.nightlight,
        title: l10n.automationEmptyOffPeakTitle,
        body: l10n.automationEmptyOffPeakBody,
        actionLabel: l10n.automationNew,
        onAction: offline
            ? null
            : () => _openForm(kind: AutomationFormKind.offPeak),
      );
    }
    final pending = board.offPeak.any(
      (t) => t.status == 'queued' || t.status == 'running',
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.zt.accentSubtle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.zt.accentBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_mode, size: 20, color: context.zt.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.automationPolicyTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.zt.accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.automationOffPeakHint,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.45,
                        color: context.zt.textLo,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ZrSectionHead(
          title: l10n.automationQueueTitle(board.offPeak.length),
          badge: pending ? l10n.automationQueueBadge : null,
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < board.offPeak.length; i++)
          _offPeakCard(l10n, i + 1, board.offPeak[i], offline),
      ],
    );
  }

  Widget _scheduledTab(
    AppLocalizations l10n,
    AutomationBoard board,
    bool offline,
  ) {
    if (board.automations.isEmpty) {
      return _EmptyState(
        icon: Icons.event_repeat,
        title: l10n.automationEmptyScheduledTitle,
        body: l10n.automationEmptyScheduledBody,
        actionLabel: l10n.automationNew,
        onAction: offline
            ? null
            : () => _openForm(kind: AutomationFormKind.scheduled),
      );
    }
    final zt = context.zt;
    final palette = [zt.accent, zt.live, zt.warn];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        BevelCard(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ScheduleDial(
              entries: [
                for (var i = 0; i < board.automations.length; i++)
                  DialEntry(
                    time: board.automations[i].nextRunAt,
                    color: palette[i % palette.length],
                    label: CronHumanizer.describe(
                      board.automations[i].cronExpr,
                      l10n,
                    ),
                  ),
              ],
              now: DateTime.now(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ZrSectionHead(
          title: l10n.automationPlansTitle(board.automations.length),
        ),
        const SizedBox(height: 8),
        for (final auto in board.automations) _scheduledCard(l10n, auto, offline),
      ],
    );
  }

  Widget _offPeakCard(
    AppLocalizations l10n,
    int seq,
    OffPeakTask task,
    bool offline,
  ) {
    final busy = _busy.contains(task.offPeakTaskId);
    final enabled = !offline && !busy;
    final title = task.title.isEmpty ? task.prompt : task.title;
    final terminal = const [
      'completed',
      'cancelled',
      'failed',
    ].contains(task.status);
    return BevelCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: context.zt.accentSubtle,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#${seq.toString().padLeft(2, '0')}',
                  style: zrMono(fontSize: 11, weight: FontWeight.w700, color: context.zt.accent),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: task.status),
            ],
          ),
          if (task.prompt.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              task.prompt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, height: 1.4, color: context.zt.textLo),
            ),
          ],
          if (task.status == 'failed' &&
              task.failureReason != null &&
              task.failureReason!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l10n.automationFailureReason(task.failureReason!),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: context.zt.danger),
            ),
          ],
          if (task.status == 'completed' && task.filesChanged != null) ...[
            const SizedBox(height: 6),
            Text(
              l10n.automationFilesChanged(task.filesChanged!),
              style: TextStyle(fontSize: 12, color: context.zt.textLo),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              if (task.workspacePath.isNotEmpty) ...[
                _pipeTag(
                  icon: Icons.desktop_windows_outlined,
                  text: _basename(task.workspacePath),
                ),
                const SizedBox(width: 8),
              ],
              if (task.status == 'queued' && task.queuePosition != null)
                _pipeTag(
                  icon: Icons.low_priority,
                  text: l10n.automationQueuePosition(task.queuePosition!),
                  color: context.zt.warn,
                  mono: true,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.zt.hairline)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                switch (task.status) {
                  'queued' => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ZrActionLink(
                        label: l10n.automationPause,
                        enabled: enabled,
                        onTap: () => _pauseTask(task),
                      ),
                      const SizedBox(width: 8),
                      ZrActionLink(
                        label: l10n.automationEdit,
                        enabled: enabled,
                        onTap: () => _openForm(
                          kind: AutomationFormKind.offPeak,
                          editingOffPeak: task,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ZrActionLink(
                        label: l10n.automationCancel,
                        color: context.zt.danger,
                        enabled: enabled,
                        onTap: () => _cancelTask(task, confirm: false),
                      ),
                    ],
                  ),
                  'paused' => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ZrActionLink(
                        label: l10n.automationResume,
                        color: context.zt.accent,
                        enabled: enabled,
                        onTap: () => _resumeTask(task),
                      ),
                      const SizedBox(width: 8),
                      ZrActionLink(
                        label: l10n.automationEdit,
                        enabled: enabled,
                        onTap: () => _openForm(
                          kind: AutomationFormKind.offPeak,
                          editingOffPeak: task,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ZrActionLink(
                        label: l10n.automationDelete,
                        color: context.zt.danger,
                        enabled: enabled,
                        onTap: () => _deleteTask(task),
                      ),
                    ],
                  ),
                  'running' => ZrActionLink(
                    label: l10n.automationCancel,
                    color: context.zt.danger,
                    enabled: enabled,
                    onTap: () => _cancelTask(task, confirm: true),
                  ),
                  _ => ZrActionLink(
                    label: l10n.automationDelete,
                    color: context.zt.danger,
                    enabled: enabled,
                    onTap: () => _deleteTask(task),
                  ),
                },
                if (terminal) ...[
                  const SizedBox(width: 8),
                  ZrActionLink(
                    label: l10n.automationReuseTemplate,
                    color: context.zt.accent,
                    enabled: enabled,
                    onTap: () => _openForm(
                      kind: AutomationFormKind.offPeak,
                      prefillTitle: task.title,
                      prefillPrompt: task.prompt,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pipeTag({
    required IconData icon,
    required String text,
    Color? color,
    bool mono = false,
  }) {
    final zt = context.zt;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: zt.surfaceHi,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color ?? zt.textLo),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: mono
                  ? zrMono(fontSize: 11, color: color ?? zt.textLo)
                  : TextStyle(fontSize: 11, color: color ?? zt.textLo),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduledCard(AppLocalizations l10n, Automation auto, bool offline) {
    final busy = _busy.contains(auto.automationId);
    final enabled = !offline && !busy;
    final title = auto.title.isEmpty ? auto.prompt : auto.title;
    final zt = context.zt;
    return BevelCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 12,
                          color: zt.accent,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            CronHumanizer.describe(auto.cronExpr, l10n),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: zrMono(
                              fontSize: 11.5,
                              weight: FontWeight.w600,
                              color: zt.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        HwChip(text: auto.cronExpr),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: 40,
                child: Center(
                  child: Switch(
                    value: auto.enabled,
                    onChanged: enabled
                        ? (next) => _toggleAutomation(auto, next)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          if (auto.prompt.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              auto.prompt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, height: 1.4, color: zt.textLo),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: zt.hairline)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final next = auto.nextRunAt;
                      if (auto.enabled && next != null) {
                        final diff = next.difference(DateTime.now());
                        if (!diff.isNegative) {
                          return Text(
                            l10n.dialNextCountdown(formatCountdown(diff, l10n)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: zt.live,
                            ),
                          );
                        }
                      }
                      if (next != null) {
                        return Text(
                          l10n.automationNextRun(_formatLocal(next)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: zrMono(
                            fontSize: 11,
                            weight: FontWeight.w400,
                            color: zt.textLo,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                ZrActionLink(
                  label: l10n.automationRunNow,
                  icon: Icons.play_arrow,
                  color: zt.accent,
                  enabled: enabled,
                  onTap: () => _runAutomationNow(auto),
                ),
                ZrActionLink(
                  label: l10n.automationEdit,
                  icon: Icons.edit_outlined,
                  enabled: enabled,
                  onTap: () => _openForm(
                    kind: AutomationFormKind.scheduled,
                    editing: auto,
                  ),
                ),
                ZrActionLink(
                  label: l10n.automationDelete,
                  icon: Icons.delete_outline,
                  color: zt.danger,
                  enabled: enabled,
                  onTap: () => _deleteAutomation(auto),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

abstract final class CronHumanizer {
  static const List<(int, int)> _domains = [
    (0, 59),
    (0, 23),
    (1, 31),
    (1, 12),
    (0, 7),
  ];

  static bool isValid(String expr) {
    final parts = _fields(expr);
    if (parts == null) return false;
    for (var i = 0; i < 5; i++) {
      if (!_fieldOk(parts[i], _domains[i].$1, _domains[i].$2)) return false;
    }
    return true;
  }

  static List<String>? _fields(String expr) {
    final parts = expr.trim().split(RegExp(r'\s+'));
    return parts.length == 5 ? parts : null;
  }

  static bool _fieldOk(String field, int min, int max) {
    if (field == '*') return true;
    final step = RegExp(r'^\*\/(\d+)$').firstMatch(field);
    if (step != null) {
      final n = int.parse(step.group(1)!);
      return n >= 1 && n <= max;
    }
    final plain = RegExp(r'^\d+$').firstMatch(field);
    if (plain != null) {
      final n = int.parse(field);
      return n >= min && n <= max;
    }
    return false;
  }

  static String describe(String expr, AppLocalizations l10n) {
    final parts = _fields(expr);
    if (parts == null) return l10n.automationCronCustom;
    final minute = parts[0],
        hour = parts[1],
        dom = parts[2],
        mon = parts[3],
        dow = parts[4];
    if (dom != '*' || mon != '*') return l10n.automationCronCustom;
    final mm = int.tryParse(minute);
    final hh = int.tryParse(hour);
    if (mm == null) return l10n.automationCronCustom;
    final mmLabel = minute.padLeft(2, '0');

    if (hour == '*' && dow == '*') {
      return '${l10n.automationCronHourly} :$mmLabel';
    }
    final step = RegExp(r'^\*\/(\d+)$').firstMatch(hour);
    if (step != null && dow == '*') {
      final n = int.parse(step.group(1)!);
      return n <= 1
          ? '${l10n.automationCronHourly} :$mmLabel'
          : '${l10n.automationCronEveryHours(n)} :$mmLabel';
    }
    final timeLabel = '${hh == null ? hour : hour.padLeft(2, '0')}:$mmLabel';
    if (hh != null && (dow == '1-5' || dow == '1,2,3,4,5')) {
      return l10n.automationCronWeekdaysOn(timeLabel);
    }
    if (hh != null && (dow == '6,0' || dow == '0,6')) {
      return l10n.automationCronWeekendOn(timeLabel);
    }
    final dowValue = int.tryParse(dow);
    if (dowValue != null && hh != null) {
      final weekday = _weekdayLabel(dowValue, l10n);
      if (weekday != null) {
        return l10n.automationCronWeeklyOn(weekday, timeLabel);
      }
    }
    if (dow == '*' && hh != null) {
      return '${l10n.automationCronDaily} $timeLabel';
    }
    return l10n.automationCronCustom;
  }

  static String? _weekdayLabel(int dow, AppLocalizations l10n) => switch (dow) {
    1 => l10n.automationWeekdayMon,
    2 => l10n.automationWeekdayTue,
    3 => l10n.automationWeekdayWed,
    4 => l10n.automationWeekdayThu,
    5 => l10n.automationWeekdayFri,
    6 => l10n.automationWeekdaySat,
    0 || 7 => l10n.automationWeekdaySun,
    _ => null,
  };
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final cut = normalized.lastIndexOf('/');
  return cut < 0 ? path : normalized.substring(cut + 1);
}

String _formatLocal(DateTime t) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${t.month}/${t.day} ${two(t.hour)}:${two(t.minute)}';
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (color, label) = switch (status) {
      'running' => (context.zt.live, l10n.automationStatusRunning),
      'queued' => (context.zt.warn, l10n.automationStatusQueued),
      'paused' => (context.zt.warn, l10n.automationStatusPaused),
      'completed' => (context.zt.textLo, l10n.automationStatusCompleted),
      'cancelled' => (context.zt.textLo, l10n.automationStatusCancelled),
      'failed' => (context.zt.danger, l10n.automationStatusFailed),
      _ => (context.zt.textLo, status),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: context.zt.textLo),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.zt.textHi,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: context.zt.textLo),
            ),
            const SizedBox(height: 14),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
