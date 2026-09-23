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
    this.deviceName,
    this.onClose,
    this.now,
  });

  final List<SessionState> sessions;

  final String? activeSessionId;

  final ValueChanged<String>? onSessionTap;

  final String? deviceName;

  final VoidCallback? onClose;

  final DateTime? now;

  static (String, Color)? phaseL10n(
    AppLocalizations l10n,
    String? phase,
    ZTPalette zt,
  ) => switch (phase) {
    'running' || 'prewarming' => (l10n.sessionPhaseRunning, zt.live),
    'completedSuccess' ||
    'completedInterrupted' => (l10n.sessionPhaseCompleted, zt.textLo),
    'error' => (l10n.sessionPhaseFailed, zt.danger),
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
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: context.zt.hairline, width: 0.8),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sessionsPanelTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: context.zt.textHi,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      deviceName == null
                          ? l10n.sessionsPanelCount(sessions.length)
                          : l10n.sessionsPanelSubtitle(
                              deviceName!,
                              sessions.length,
                            ),
                      style: TextStyle(
                        fontSize: 11,
                        color: context.zt.textLo,
                      ),
                    ),
                  ],
                ),
              ),
              if (onClose != null)
                Tooltip(
                  message: AppLocalizations.of(context)!.commonCancel,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onClose,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.05)
                            : context.zt.surfaceHover,
                        border: Border.all(
                          color:
                              Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.08)
                              : context.zt.hairline,
                          width: 0.8,
                        ),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 15,
                        color: context.zt.textLo,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (sessions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              l10n.sessionsPanelEmpty,
              style: TextStyle(fontSize: 13, color: context.zt.textLo),
            ),
          )
        else
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                for (final group in SessionGrouping.groupByDay(
                  sessions,
                  effectiveNow,
                  weekStartsMonday: l10n.localeName.startsWith('zh'),
                )) ...[
                  _GroupHeader(
                    label: groupLabel(l10n, group.key),
                    count: group.value.length,
                  ),
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
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: zt.textTertiary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: zrMono(fontSize: 10, weight: FontWeight.w400, color: zt.textLo),
            ),
          ),
        ],
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
    final pill = SessionPanelSheet.phaseL10n(l10n, s.phase, context.zt);
    return InkWell(
      onTap: () => onTap?.call(s.sessionId),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: active
              ? context.zt.accentSubtle
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: active
              ? Border.all(color: context.zt.accentBorder)
              : Border.all(color: Colors.transparent),
        ),
        padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
        child: Row(
          children: [
            Container(
              key: Key('session-active-dot-${s.sessionId}'),
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? context.zt.accent : Colors.transparent,
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: context.zt.accent.withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
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
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? context.zt.accent
                          : context.zt.textHi,
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
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: context.zt.textLo,
                            ),
                          ),
                        ),
                        Text(
                          ' · ',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.zt.textLo,
                          ),
                        ),
                      ],
                      Flexible(
                        child: Text(
                          _relativeLabel(l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.zt.textLo,
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
                  _PhasePill(label: pill.$1, color: pill.$2),
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
    if (alert) {
      return Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.zt.danger,
          boxShadow: [
            BoxShadow(
              color: context.zt.danger.withValues(alpha: 0.35),
              blurRadius: 4,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Text(
          count >= 99 ? '99' : '$count',
          style: zrMono(
            fontSize: 10,
            weight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      );
    }
    final base = context.zt.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: base.withValues(alpha: 0.30)),
      ),
      child: Text(
        count >= 99 ? '99+' : '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: base,
        ),
      ),
    );
  }
}

class _PhasePill extends StatelessWidget {
  const _PhasePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
