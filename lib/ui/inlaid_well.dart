import 'package:flutter/material.dart';

import '../theme.dart';

class InlaidWell extends StatelessWidget {
  const InlaidWell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.radius = 8.0,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  final double radius;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hairlineColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : zt.hairline;
    final bottomHighlight = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.85);

    return CustomPaint(
      painter: _InlaidWellPainter(
        radius: radius,
        isDark: isDark,
        fieldColor: zt.field,
        hairlineColor: hairlineColor,
        bottomHighlightColor: bottomHighlight,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _InlaidWellPainter extends CustomPainter {
  const _InlaidWellPainter({
    required this.radius,
    required this.isDark,
    required this.fieldColor,
    required this.hairlineColor,
    required this.bottomHighlightColor,
  });

  final double radius;
  final bool isDark;
  final Color fieldColor;
  final Color hairlineColor;
  final Color bottomHighlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final bgPaint = Paint()..color = fieldColor;
    canvas.drawRRect(rrect, bgPaint);

    canvas.save();
    canvas.clipRRect(rrect);

    if (isDark) {
      final topShadowPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.35),
            Colors.transparent,
          ],
          stops: const [0.0, 0.40],
        ).createShader(rect);
      canvas.drawRect(rect, topShadowPaint);
    }

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = hairlineColor;
    final strokeRRect = RRect.fromRectAndRadius(
      rect.deflate(0.4),
      Radius.circular(radius > 0.4 ? radius - 0.4 : 0),
    );
    canvas.drawRRect(strokeRRect, strokePaint);

    final bottomGlowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          bottomHighlightColor,
          Colors.transparent,
        ],
        stops: const [0.0, 0.20],
      ).createShader(Rect.fromLTWH(0, size.height - 6, size.width, 6));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - 6, size.width, 6),
      bottomGlowPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InlaidWellPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.isDark != isDark ||
        oldDelegate.fieldColor != fieldColor ||
        oldDelegate.hairlineColor != hairlineColor ||
        oldDelegate.bottomHighlightColor != bottomHighlightColor;
  }
}
