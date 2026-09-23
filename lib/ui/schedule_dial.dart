import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';

class ScheduleDial extends StatelessWidget {
  const ScheduleDial({super.key, required this.entries, this.now});

  final List<DialEntry> entries;

  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final visible = entries
        .where((e) => e.showLegend || e.time != null)
        .toList(growable: false);
    if (visible.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CustomPaint(
            painter: _DialPainter(
              colors: ScheduleDialColors(
                field: zt.field,
                hairline: zt.hairline,
                hairlineBright: zt.hairlineBright,
                warn: zt.warn,
                textTertiary: zt.textTertiary,
                surface: zt.surface,
              ),
              entries: entries,
              now: now ?? DateTime.now(),
            ),
          ),
        ),
        if (visible.any((e) => e.showLegend && e.label.isNotEmpty)) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              for (final e in visible)
                if (e.showLegend && e.label.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: e.color,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        e.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: zt.textLo,
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ],
      ],
    );
  }
}

class DialEntry {
  const DialEntry({
    required this.time,
    required this.color,
    this.label = '',
    this.showLegend = true,
  });

  final DateTime? time;
  final Color color;
  final String label;
  final bool showLegend;
}

String formatCountdown(Duration d, AppLocalizations l10n) {
  if (d.inMinutes < 1) return l10n.countdownLt1;
  final h = d.inHours;
  final m = d.inMinutes % 60;
  return h > 0 ? l10n.countdownHm(h, m) : l10n.countdownM(m);
}

class ScheduleDialColors {
  const ScheduleDialColors({
    required this.field,
    required this.hairline,
    required this.hairlineBright,
    required this.warn,
    required this.textTertiary,
    required this.surface,
  });

  final Color field;
  final Color hairline;
  final Color hairlineBright;
  final Color warn;
  final Color textTertiary;
  final Color surface;
}

class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.colors,
    required this.entries,
    required this.now,
  });

  final ScheduleDialColors colors;
  final List<DialEntry> entries;
  final DateTime now;

  static double _angleOf(int hour, int minute) =>
      -math.pi / 2 + 2 * math.pi * (hour * 60 + minute) / 1440;

  void _label(Canvas canvas, Size size, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 9,
          fontFamily: kMonoFamily,
          color: colors.textTertiary,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;

    canvas.drawCircle(center, radius, Paint()..color = colors.field);
    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = colors.hairlineBright,
    );

    final labelRadius = radius - 13;
    _label(canvas, size, '00:00', center + Offset(0, -labelRadius));
    _label(canvas, size, '06:00', center + Offset(labelRadius, 0));
    _label(canvas, size, '12:00', center + Offset(0, labelRadius));
    _label(canvas, size, '18:00', center + Offset(-labelRadius, 0));

    for (var hour = 0; hour < 24; hour++) {
      final major = hour % 6 == 0;
      final angle = _angleOf(hour, 0);
      final dir = Offset(math.cos(angle), math.sin(angle));
      final origin = center + dir * (radius - (major ? 20 : 12));
      final outer = center + dir * (radius - 7);
      canvas.drawLine(
        origin,
        outer,
        Paint()
          ..strokeWidth = major ? 1.5 : 1
          ..color = major ? colors.hairlineBright : colors.hairline,
      );
    }

    final dotRadius = radius - 26;
    final byMinute = <int, List<DialEntry>>{};
    for (final e in entries) {
      if (e.time == null) continue;
      byMinute.putIfAbsent(e.time!.hour * 60 + e.time!.minute, () => []).add(e);
    }
    for (final entry in byMinute.values.indexed) {
      final (minuteOfDay, group) = entry;
      final angle = _angleOf(minuteOfDay ~/ 60, minuteOfDay % 60);
      for (var i = 0; i < group.length; i++) {
        final e = group[i];
        final jitter = (i - (group.length - 1) / 2) * 0.035;
        final a = angle + jitter;
        final pos =
            center + Offset(math.cos(a), math.sin(a)) * dotRadius;
        canvas.drawCircle(
          pos,
          7,
          Paint()
            ..color = e.color.withValues(alpha: 0.35)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
        canvas.drawCircle(pos, 5, Paint()..color = e.color);
        canvas.drawCircle(
          pos,
          5,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = colors.surface,
        );
      }
    }

    final nowAngle = _angleOf(now.hour, now.minute);
    final handEnd =
        center + Offset(math.cos(nowAngle), math.sin(nowAngle)) * (radius * 0.6);
    canvas.drawLine(
      center,
      handEnd,
      Paint()
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = colors.warn,
    );
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) =>
      oldDelegate.entries != entries ||
      oldDelegate.now != now ||
      oldDelegate.colors != colors;
}
