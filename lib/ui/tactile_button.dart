import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

enum TactileVariant { normal, primary, danger }

class TactileButton extends StatefulWidget {
  const TactileButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.variant = TactileVariant.normal,
    this.icon,
    this.height = 36,
  });

  final String? label;

  final Widget? child;

  final VoidCallback? onPressed;

  final TactileVariant variant;

  final Widget? icon;

  final double height;

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.985).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
    _pressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
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
    final enabled = widget.onPressed != null;

    final Color background;
    final Color foreground;
    final Border? border;
    final Color? topEdge;
    final List<BoxShadow> shadows;
    switch (widget.variant) {
      case TactileVariant.normal:
        foreground = zt.textHi;
        if (isDark) {
          background = Colors.white.withValues(alpha: 0.06);
          border = Border.all(color: zt.hairline);
          topEdge = zt.hairlineBright;
          shadows = [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ];
        } else {
          background = const Color(0xFFF6F8FA);
          border = Border.all(color: zt.hairline);
          topEdge = null;
          shadows = [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ];
        }
      case TactileVariant.primary:
        background = zt.accent;
        foreground = zt.onAccent;
        border = null;
        topEdge = Colors.white.withValues(alpha: 0.25);
        shadows = [
          BoxShadow(
            color: zt.accentBorder,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ];
      case TactileVariant.danger:
        background = zt.danger;
        foreground = Colors.white;
        border = null;
        topEdge = Colors.white.withValues(alpha: 0.25);
        shadows = [
          BoxShadow(
            color: zt.danger.withValues(alpha: 0.32),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ];
    }

    Widget contentChild;
    if (widget.child != null) {
      contentChild = widget.child!;
    } else {
      contentChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            IconTheme.merge(
              data: IconThemeData(color: foreground, size: 16),
              child: widget.icon!,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            widget.label ?? '',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      );
    }

    Widget button = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: border,
        boxShadow: shadows,
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: contentChild,
            ),
          ),
          if (topEdge != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ColoredBox(
                color: topEdge,
                child: const SizedBox(height: 1),
              ),
            ),
        ],
      ),
    );

    if (!enabled) {
      return Opacity(opacity: 0.45, child: button);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _pressAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          ),
          child: button,
        ),
      ),
    );
  }
}
