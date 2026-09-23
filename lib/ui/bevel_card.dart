import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

class BevelCard extends StatefulWidget {
  const BevelCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin = const EdgeInsets.only(bottom: 10),
    this.radius = 18.0,
    this.onTap,
    this.accent = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final double radius;

  final VoidCallback? onTap;

  final bool accent;

  @override
  State<BevelCard> createState() => _BevelCardState();
}

class _BevelCardState extends State<BevelCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.985).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuad,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    _controller.forward();
    HapticFeedback.selectionClick();
  }

  void _handleTapUp(TapUpDetails _) => _controller.reverse();

  void _handleTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final interactive = widget.onTap != null;

    final Color borderColor;
    final Color? topEdge;
    final Gradient gradient;
    final List<BoxShadow> shadows;
    if (isDark) {
      final top = widget.accent
          ? Color.lerp(const Color(0xFF1A1E28), zt.accentSubtle, 0.5)!
          : const Color(0xFF1A1E28);
      final bottom = widget.accent
          ? Color.lerp(const Color(0xFF101218), zt.accentSubtle, 0.5)!
          : const Color(0xFF101218);
      gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [top, bottom],
      );
      borderColor = widget.accent ? zt.accentBorder : zt.hairline;
      topEdge = widget.accent ? null : zt.hairlineBright;
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ];
    } else {
      gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          widget.accent
              ? Color.lerp(Colors.white, zt.accentSubtle, 0.5)!
              : Colors.white,
          widget.accent
              ? Color.lerp(Colors.white, zt.accentSubtle, 0.5)!
              : Colors.white,
        ],
      );
      borderColor = widget.accent ? zt.accentBorder : zt.hairline;
      topEdge = widget.accent ? null : Colors.white.withValues(alpha: 0.9);
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];
    }

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: widget.margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: borderColor),
        boxShadow: shadows,
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(widget.radius),
              splashColor: zt.accent.withValues(alpha: 0.08),
              highlightColor: zt.accent.withValues(alpha: 0.04),
              child: Padding(padding: widget.padding, child: widget.child),
            ),
          ),
          if (topEdge != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ColoredBox(color: topEdge, child: const SizedBox(height: 1)),
            ),
        ],
      ),
    );

    if (interactive) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: ScaleTransition(scale: _scaleAnimation, child: content),
        ),
      );
    }

    return content;
  }
}
