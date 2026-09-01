import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/event_observer.dart';
import '../state/session_index.dart';
import '../theme.dart';

class SessionPanelSheet extends StatelessWidget {
  const SessionPanelSheet({
    super.key,
    required this.sessions,
    this.activeSessionId,
    this.onSessionTap,
    this.now,
  });

  final List<SessionState> sessions;

  final String? activeSessionId;

  final ValueChanged<String>? onSessionTap;

  final DateTime? now;

  static (String, Color, Color)? phaseL10n(
    AppLocalizations l10n,
    String? phase,
  ) => switch (phase) {
    'running' || 'prewarming' => (
      l10n.sessionPhaseRunning,
      ZT.accent,
      ZT.onAccent,
    ),
    'completedSuccess' || 'completedInterrupted' => (
      l10n.sessionPhaseCompleted,
      ZT.live,
      ZT.bg,
    ),
    'error' => (l10n.sessionPhaseFailed, ZT.danger, Colors.white),
    _ => null,
  };

  static String groupLabel(AppLocalizations l10n, String key) {
    if (key == 'pinned') return l10n.sessionGroupPinned;
    if (key == 'today') return l10n.sessionGroupToday;
    if (key == 'yesterday') return l10n.sessionGroupYesterday;
    if (key == 'thisWeek') return l10n.sessionGroupThisWeek;
    if (key == 'lastWeek') return l10n.sessionGroupLastWeek;
    if (key == 'thisMonth') return l10n.sessionGroupThisMonth;
    if (key == 'lastMonth') return l10n.sessionGroupLastMonth;
    if (key == 'older') return l10n.sessionGroupOlder;
    if (key == 'unknown') return l10n.sessionGroupOlder;
    if (key.startsWith('day:')) {
      return l10n.sessionGroupDays(int.tryParse(key.substring(4)) ?? 0);
    }
    return l10n.sessionGroupOlder;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveNow = now ?? DateTime.now();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.sessionsPanelTitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: ZT.textHi,
              ),
            ),
          ),
        ),
        if (sessions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              l10n.sessionsPanelEmpty,
              style: const TextStyle(fontSize: 13, color: ZT.textLo),
            ),
          )
        else
          Flexible(
            child: ListView(
              children: [
                for (final group in SessionGrouping.groupByDay(
                  sessions,
                  effectiveNow,
                  weekStartsMonday: l10n.localeName.startsWith('zh'),
                )) ...[
                  _GroupHeader(label: groupLabel(l10n, group.key)),
                  for (final s in group.value)
                    _SessionRow(
                      session: s,
                      active: activeSessionId == s.sessionId,
                      now: effectiveNow,
                      onTap: onSessionTap,
                    ),
                ],
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ZT.textLo,
          ),
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.session,
    required this.active,
    required this.now,
    this.onTap,
  });

  final SessionState session;
  final bool active;
  final DateTime now;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = session;
    final title = (s.title == null || s.title!.isEmpty)
        ? s.sessionId
        : s.title!;
    final pill = SessionPanelSheet.phaseL10n(l10n, s.phase);
    return InkWell(
      onTap: () => onTap?.call(s.sessionId),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(
          children: [
            Container(
              key: Key('session-active-dot-${s.sessionId}'),
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? ZT.accent : Colors.transparent,
              ),
            ),
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
                      fontWeight: FontWeight.w600,
                      color: ZT.textHi,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (s.workspace != null) ...[
                        Flexible(
                          child: Text(
                            s.workspace!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: ZT.textLo,
                            ),
                          ),
                        ),
                        const Text(
                          ' · ',
                          style: TextStyle(fontSize: 12, color: ZT.textLo),
                        ),
                      ],
                      Flexible(
                        child: Text(
                          _relativeLabel(l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ZT.textLo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (s.permissionCount > 0) ...[
                  _CountPill(count: s.permissionCount, alert: true),
                  if (s.userInputCount > 0) const SizedBox(width: 6),
                ],
                if (s.userInputCount > 0) _CountPill(count: s.userInputCount),
                if (pill != null) ...[
                  const SizedBox(width: 6),
                  _PhasePill(
                    label: pill.$1,
                    background: pill.$2,
                    foreground: pill.$3,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _relativeLabel(AppLocalizations l10n) {
    final t = RelativeTime.format(
      session.lastActivityAt,
      now.millisecondsSinceEpoch,
    );
    return switch (t.kind) {
      'minute' => l10n.sessionTimeMinutes(t.n),
      'hour' => l10n.sessionTimeHours(t.n),
      'day' => l10n.sessionTimeDays(t.n),
      _ => l10n.sessionTimeNow,
    };
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count, this.alert = false});

  final int count;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: alert ? ZT.danger : ZT.accent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        count >= 99 ? '99+' : '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: alert ? Colors.white : ZT.onAccent,
        ),
      ),
    );
  }
}

class _PhasePill extends StatelessWidget {
  const _PhasePill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}
