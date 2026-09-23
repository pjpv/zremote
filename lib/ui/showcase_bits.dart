import 'package:flutter/material.dart';

import '../theme.dart';

class ZrSectionHead extends StatelessWidget {
  const ZrSectionHead({
    super.key,
    required this.title,
    this.badge,
    this.badgeColor,
    this.trailing,
  });

  final String title;

  final String? badge;
  final Color? badgeColor;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: zt.textLo,
              ),
            ),
          ),
          if (badge != null)
            Text(
              badge!,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: badgeColor ?? zt.live,
              ),
            ),
          ?trailing,
        ],
      ),
    );
  }
}

class ZrStatusChip extends StatelessWidget {
  const ZrStatusChip({
    super.key,
    required this.label,
    required this.color,
    this.withLed = false,
  });

  final String label;
  final Color color;
  final bool withLed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (withLed) ...[
            Container(
              width: 9.5,
              height: 9.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.35, -0.35),
                  colors: [
                    Colors.white.withValues(alpha: 0.9),
                    color,
                    color.withValues(alpha: 0.82),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.4),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.10),
                    blurRadius: 0,
                    spreadRadius: 0.8,
                  ),
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 3.5,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              height: 1.1,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class ZrTelemetryItem {
  const ZrTelemetryItem({
    required this.label,
    required this.value,
    this.unit,
    this.unitColor,
    this.ledColor,
  });

  final String label;

  final String value;

  final String? unit;
  final Color? unitColor;

  final Color? ledColor;
}

class ZrTelemetryBanner extends StatelessWidget {
  const ZrTelemetryBanner({super.key, required this.items});

  final List<ZrTelemetryItem> items;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xE6161922), Color(0xF20E1016)],
              )
            : null,
        color: isDark ? null : zt.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : zt.hairline,
          width: 0.8,
        ),
        boxShadow: [
          if (isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 14,
              offset: const Offset(0, 3),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Container(
                width: 0.8,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: zt.hairline,
              ),
            Expanded(child: _item(context, items[i])),
          ],
        ],
      ),
    );
  }

  Widget _item(BuildContext context, ZrTelemetryItem item) {
    final zt = context.zt;
    return Column(
      children: [
        Text(
          item.label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: zt.textTertiary,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (item.ledColor != null) ...[
              Container(
                width: 7.5,
                height: 7.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.ledColor,
                  boxShadow: [
                    BoxShadow(
                      color: item.ledColor!.withValues(alpha: 0.45),
                      blurRadius: 4,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              item.value,
              style: zrMono(fontSize: 14, weight: FontWeight.w700, color: zt.textHi),
            ),
            if (item.unit != null) ...[
              const SizedBox(width: 4),
              Text(
                item.unit!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: item.unitColor ?? zt.textLo,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class ZrScopeDock extends StatelessWidget {
  const ZrScopeDock({
    super.key,
    required this.label,
    required this.name,
    this.tag,
    required this.dotColor,
  });

  final String label;
  final String name;
  final String? tag;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        border: Border(bottom: BorderSide(color: zt.hairline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: zt.textLo,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                  boxShadow: [
                    BoxShadow(
                      color: dotColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: zt.textHi,
                  ),
                ),
              ),
              if (tag != null) ...[
                const SizedBox(width: 8),
                Text(tag!, style: zrMono(fontSize: 11, color: zt.textLo)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class ZrSegmented extends StatelessWidget {
  const ZrSegmented({
    super.key,
    required this.segments,
    required this.active,
    required this.onChanged,
  });

  final List<(String value, String label)> segments;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: zt.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: zt.hairline),
      ),
      child: Row(
        children: [
          for (final (value, label) in segments)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(9),
                onTap: value == active ? null : () => onChanged(value),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: value == active ? zt.surfaceHi : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: value == active
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.20),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: value == active ? zt.textHi : zt.textLo,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ZrDockButton extends StatelessWidget {
  const ZrDockButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enabled = onPressed != null;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: zt.hairlineBright),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.12),
                blurRadius: 36,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Material(
            color: enabled ? zt.accent : zt.surfaceHi,
            borderRadius: BorderRadius.circular(100),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: enabled ? zt.onAccent : zt.textLo,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: enabled ? zt.onAccent : zt.textLo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ZrActionLink extends StatelessWidget {
  const ZrActionLink({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.enabled = true,
    required this.onTap,
  });

  final String label;
  final IconData? icon;

  final Color? color;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final effective = enabled ? (color ?? zt.textLo) : zt.textTertiary;
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: effective),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: effective),
            ),
          ],
        ),
      ),
    );
  }
}

class ZrField extends StatelessWidget {
  const ZrField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: zt.textLo),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

InputDecoration zrInputDecoration(BuildContext context, {String? hint}) {
  final zt = context.zt;
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: zt.surfaceHi,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: zt.hairlineBright),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: zt.accent, width: 1.2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: zt.hairline),
    ),
  );
}

class ZrInterpreterBar extends StatelessWidget {
  const ZrInterpreterBar({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: zt.live.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: zt.live.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.check, size: 14, color: zt.live),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: zt.live,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ZrDashedBorderPainter extends CustomPainter {
  ZrDashedBorderPainter({required this.color, this.radius = 16, this.dash = 5, this.gap = 4, this.strokeWidth = 1.2});

  final Color color;
  final double radius;
  final double dash;
  final double gap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final next = (dist + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(dist, next), paint);
        dist = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant ZrDashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.dash != dash ||
      old.gap != gap ||
      old.strokeWidth != strokeWidth;
}

class ZrDashedLinePainter extends CustomPainter {
  ZrDashedLinePainter({required this.color, this.dash = 4, this.gap = 3});

  final Color color;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = color;
    final y = size.height / 2;
    var x = 0.0;
    while (x < size.width) {
      final next = (x + dash).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, y), Offset(next, y), paint);
      x = next + gap;
    }
  }

  @override
  bool shouldRepaint(covariant ZrDashedLinePainter old) => old.color != color;
}
