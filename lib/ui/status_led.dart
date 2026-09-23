import 'package:flutter/material.dart';

import '../state/session_status.dart';
import '../theme.dart';

class StatusLed extends StatelessWidget {
  const StatusLed({
    super.key,
    required this.status,
    this.size = 10.0,
    this.showGlow = true,
    this.semanticLabel,
  });

  final SessionStatus? status;

  final double size;
  final bool showGlow;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final color = zt.statusColor(status);

    final glowShadow = showGlow
        ? [
            BoxShadow(
              color: color.withValues(alpha: 0.7),
              blurRadius: size * 0.5,
              spreadRadius: size * 0.1,
            ),
          ]
        : const <BoxShadow>[];

    final core = AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: size * 0.6,
      height: size * 0.6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: [
            Colors.white.withValues(alpha: 0.9),
            color,
            Color.lerp(color, Colors.black, 0.35)!,
          ],
        ),
        boxShadow: glowShadow,
      ),
    );

    final bezel = AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0A0C10),
        border: Border.all(color: Colors.black.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.15),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(child: core),
    );

    if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        child: bezel,
      );
    }

    return bezel;
  }
}
