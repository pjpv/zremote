import 'package:flutter/material.dart';

import '../theme.dart';

class HwChip extends StatelessWidget {
  const HwChip({super.key, required this.text, this.color, this.icon});

  final String text;

  final Color? color;

  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ?? zt.textLo;

    final label = Text(
      text,
      style: zrMono(fontSize: 10, color: effectiveColor),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: zt.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme.merge(
              data: IconThemeData(color: effectiveColor, size: 12),
              child: icon!,
            ),
            const SizedBox(width: 4),
          ],
          label,
        ],
      ),
    );
  }
}
