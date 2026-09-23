import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

Future<T?> showZrSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,

  double? maxHeightFactor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    useSafeArea: false,
    isScrollControlled: isScrollControlled,
    builder: (sheetContext) {
      final zt = sheetContext.zt;
      final mediaQuery = MediaQuery.of(sheetContext);
      final safeBottom = math.max(
        mediaQuery.padding.bottom,
        mediaQuery.viewPadding.bottom,
      );
      final keyboardInset = mediaQuery.viewInsets.bottom;
      final bottomPadding = keyboardInset > 0
          ? 6.0
          : (safeBottom > 0 ? safeBottom + 8.0 : 14.0);

      return AnimatedPadding(
        padding: EdgeInsets.only(bottom: keyboardInset),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: CustomPaint(
          foregroundPainter: _SheetBorderPainter(
            topRadius: 18,
            topColor: zt.hairlineBright,
            sideColor: zt.hairline,
            strokeWidth: 1.0,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [zt.surfaceHi, zt.surface],
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxHeightFactor == null
                      ? mediaQuery.size.height * 0.9
                      : mediaQuery.size.height * maxHeightFactor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      key: const Key('zr-sheet-handle'),
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(top: 10, bottom: 4),
                      decoration: BoxDecoration(
                        color: zt.hairlineBright,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Flexible(child: Builder(builder: builder)),
                    SizedBox(height: bottomPadding),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _SheetBorderPainter extends CustomPainter {
  const _SheetBorderPainter({
    required this.topRadius,
    required this.topColor,
    required this.sideColor,
    this.strokeWidth = 1.0,
  });

  final double topRadius;
  final Color topColor;
  final Color sideColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final half = strokeWidth / 2;
    final rect = Offset.zero & size;
    final r = (topRadius - half).clamp(0.0, double.infinity);

    final rrect = RRect.fromRectAndCorners(
      rect.deflate(half),
      topLeft: Radius.circular(r),
      topRight: Radius.circular(r),
    );

    final shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        topColor,
        topColor,
        sideColor,
        sideColor,
      ],
      stops: const [0.0, 0.08, 0.25, 1.0],
    ).createShader(rect);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = shader;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _SheetBorderPainter oldDelegate) {
    return oldDelegate.topRadius != topRadius ||
        oldDelegate.topColor != topColor ||
        oldDelegate.sideColor != sideColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
