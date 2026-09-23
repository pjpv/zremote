import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/claim.dart';

abstract final class ClaimFormat {
  static String grouped(num v) => NumberFormat('#,##0').format(v);

  static String compact(num v, String locale) =>
      NumberFormat.compact(locale: locale).format(v);

  static String compactOrNull(num? v, String locale) =>
      v == null ? '' : compact(v, locale);

  static String dateTime(DateTime t, String locale) {
    String two(int v) => v.toString().padLeft(2, '0');
    if (locale.startsWith('zh')) {
      return '${t.year}年${t.month}月${t.day}日 ${two(t.hour)}:${two(t.minute)}';
    }
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final ampm = t.hour < 12 ? 'AM' : 'PM';
    return '${months[t.month - 1]} ${t.day}, ${t.year}, '
        '$h12:${two(t.minute)} $ampm';
  }

  static String listJoin(List<String> names, String locale) {
    final zh = locale.startsWith('zh');
    switch (names.length) {
      case 0:
        return '';
      case 1:
        return names.single;
      case 2:
        return zh ? '${names[0]}和${names[1]}' : '${names[0]} and ${names[1]}';
      default:
        final head = names
            .sublist(0, names.length - 1)
            .join(zh ? '、' : ', ');
        return zh ? '$head和${names.last}' : '$head, and ${names.last}';
    }
  }
}

typedef ClaimTicketTokens = ({
  Color primary,
  Color onPrimary,
  Color chart,
  Color popover,
  Color foreground,
  Color subtle,
});

ClaimTicketTokens claimTicketTokensOf(Brightness brightness) =>
    brightness == Brightness.dark
        ? (
            primary: const Color(0xFFFAFAFA),
            onPrimary: const Color(0xFF0A0A0A),
            chart: const Color(0xFF0EA5E9),
            popover: const Color(0xFF262626),
            foreground: const Color(0xFFE5E5E5),
            subtle: const Color(0xFFE5E5E5).withValues(alpha: 0.60),
          )
        : (
            primary: const Color(0xFF0A0A0A),
            onPrimary: const Color(0xFFFAFAFA),
            chart: const Color(0xFF0284C7),
            popover: const Color(0xFFFFFFFF),
            foreground: const Color(0xFF404040),
            subtle: const Color(0xFF404040).withValues(alpha: 0.60),
          );

Future<void> showClaimTicketDialog(
  BuildContext context, {
  required ClaimPreview plan,
  required ClaimOutcome outcome,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.60),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      clipBehavior: Clip.none,
      child: ClaimTicketDialog(plan: plan, outcome: outcome),
    ),
  );
}

const double ticketHPad = 16.0;

const double ticketHoleCenterFromBottom = 48.0;

const double ticketBottomPad = 16.0;

const double ticketValidityRow = 18.0;

const double ticketHoleDiameter = 22.0;

const double ticketDividerGap = ticketHoleCenterFromBottom -
    ticketBottomPad -
    ticketValidityRow -
    ticketHoleDiameter / 2;

class ClaimTicketDialog extends StatefulWidget {
  const ClaimTicketDialog({
    super.key,
    required this.plan,
    required this.outcome,
  });

  final ClaimPreview plan;
  final ClaimOutcome outcome;

  @override
  State<ClaimTicketDialog> createState() => _ClaimTicketDialogState();
}

class _ClaimTicketDialogState extends State<ClaimTicketDialog>
    with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final CurvedAnimation _enterCurve = CurvedAnimation(
    parent: _enter,
    curve: Curves.easeInOut,
  );

  late final AnimationController _flip = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 720),
  );
  late final CurvedAnimation _flipCurve = CurvedAnimation(
    parent: _flip,
    curve: const Cubic(0.22, 0.72, 0.18, 1),
  );

  int _flipDir = 1;

  final ValueNotifier<double> _starTime = ValueNotifier(0);
  Ticker? _starTicker;
  bool _motionInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_motionInit) return;
    _motionInit = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _enter.value = 1;
    } else {
      _enter.forward();
      _starTicker = createTicker(
        (elapsed) => _starTime.value = elapsed.inMicroseconds / 1e6,
      )..start();
    }
  }

  @override
  void dispose() {
    _starTicker?.dispose();
    _enterCurve.dispose();
    _flipCurve.dispose();
    _enter.dispose();
    _flip.dispose();
    _starTime.dispose();
    super.dispose();
  }

  void _replay() {
    if (MediaQuery.disableAnimationsOf(context)) return;
    _flip
      ..stop()
      ..value = 0;
    _enter.forward(from: 0);
  }

  void _flipTo(int dir) {
    if (MediaQuery.disableAnimationsOf(context) || _flip.isAnimating) return;
    setState(() => _flipDir = dir);
    _flip.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final tokens = claimTicketTokensOf(Theme.of(context).brightness);
    final plan = widget.plan;
    final outcome = widget.outcome;

    final totalTokens = _totalTokensOf(plan);
    final names = plan.entitlements
        .map((e) => e.showName)
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    final listLabel = ClaimFormat.listJoin(names, locale);
    final startsLater = outcome.startsAtMillis != null &&
        outcome.serverTime != null &&
        outcome.startsAtMillis! > outcome.serverTime!;
    final desc = startsLater
        ? l10n.claimSuccessPending(
            listLabel,
            ClaimFormat.dateTime(
              DateTime.fromMillisecondsSinceEpoch(outcome.startsAtMillis!),
              locale,
            ),
          )
        : l10n.claimSuccessReady(listLabel);

    final media = MediaQuery.sizeOf(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduceMotion ? 1.0 : 0.95, end: 1),
      duration: const Duration(milliseconds: 100),
      builder: (context, t, child) => Opacity(
        opacity: ((t - 0.95) / 0.05).clamp(0.0, 1.0),
        child: Transform.scale(scale: t, child: child),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: math.min(480.0, media.width - 32),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: tokens.popover,
            constraints: BoxConstraints(maxHeight: media.height - 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: RepaintBoundary(
                              child: CustomPaint(
                                painter: _StarfieldPainter(
                                  time: _starTime,
                                  meteors: !reduceMotion,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: _ReplayButton(onPressed: _replay),
                          ),
                          Center(
                            child: _TicketCard(
                              plan: plan,
                              totalTokens: totalTokens,
                              endsAt: outcome.endsAt,
                              enter: _enterCurve,
                              flip: _flipCurve,
                              flipDir: _flipDir,
                              onFlip: _flipTo,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.claimSuccessTitle(
                              plan.name.isEmpty ? plan.planId : plan.name,
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: tokens.foreground,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            desc,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.625,
                              color: tokens.subtle,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(l10n.claimGotIt),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Opacity(
                            opacity: 0.80,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    'assets/brand/mark.png',
                                    width: 16,
                                    height: 16,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'ZRemote',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: tokens.foreground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  static int? _totalTokensOf(ClaimPreview plan) {
    int? max;
    for (final e in plan.entitlements) {
      if (e.meter != 'model_usage') continue;
      final u = e.units;
      if (u == null) continue;
      final v = u.toInt();
      if (max == null || v > max) max = v;
    }
    return max;
  }
}

class _ReplayButton extends StatelessWidget {
  const _ReplayButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context)!.claimReplayTooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.10),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.replay, size: 16, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  _StarfieldPainter({required ValueNotifier<double> time, required this.meteors})
    : _time = time,
      super(repaint: time);

  final ValueNotifier<double> _time;
  final bool meteors;

  static const List<(double, double, double, double, bool)> _stars = [
    (0.49, 86.03, 1.66, .53, false),
    (12.75, 32.63, 1.48, .69, false),
    (70.63, 66.97, 1.72, .38, false),
    (94.8, 87.97, 1.35, .39, false),
    (93.09, 42.91, 1.18, .25, true),
    (77.38, 49.49, 1.72, .60, false),
    (33.25, 76.16, 1.25, .36, true),
    (51.55, 57.88, 1.07, .75, false),
    (78.27, 6.77, 1.47, .71, true),
    (89.59, 65.79, 1.48, .57, false),
    (40.24, 99.45, 1.51, .25, false),
    (7.51, 23.13, 1.20, .54, false),
    (48.92, 60.74, 1.45, .46, true),
    (0.63, 19.53, 1.46, .77, true),
    (8.16, 83.18, 1.38, .33, false),
    (66.87, 95.84, 1.57, .52, true),
    (22.55, 46.23, 0.86, .51, true),
    (57.09, 2.47, 0.97, .37, false),
    (62.49, 51.85, 1.34, .74, true),
    (4.17, 96.63, 1.20, .35, false),
    (7.08, 53.72, 0.54, .26, false),
    (39.75, 62.64, 1.58, .47, false),
    (17.61, 57.35, 1.71, .70, false),
    (15.49, 92.73, 1.20, .64, false),
    (29.76, 82.32, 0.86, .59, false),
    (60.44, 9.77, 0.65, .68, false),
    (42.43, 91.49, 0.58, .35, false),
    (34.72, 30.39, 1.08, .31, true),
    (5.56, 63.58, 1.15, .33, false),
    (37.02, 87.56, 1.26, .74, true),
    (0.72, 19.85, 0.88, .59, false),
    (97.41, 38.02, 0.95, .49, false),
    (46.69, 69.68, 1.00, .69, false),
    (91.98, 1.83, 0.72, .60, false),
    (80.23, 19.48, 1.09, .35, true),
    (60.35, 1.77, 1.09, .53, true),
    (39.83, 51.46, 0.80, .56, false),
    (44.82, 18.9, 0.97, .73, false),
    (49.64, 28.53, 1.12, .56, false),
    (9.47, 39.99, 0.76, .41, true),
    (42.56, 76.56, 1.60, .58, false),
    (93.67, 72.78, 1.20, .75, false),
    (7.36, 40.46, 1.01, .43, false),
    (13.85, 28.17, 0.77, .72, false),
    (75.58, 62.92, 1.19, .60, false),
    (6.3, 45.75, 1.61, .32, true),
    (11.36, 0.69, 0.67, .53, true),
    (8.89, 50.97, 1.15, .79, false),
  ];

  static const List<(double, double, double, double)> _meteors = [
    (11, 0, 2.1, 8),
    (148.5, .37, 2.5, 15),
    (286, .74, 2.9, 22),
    (63.5, 1.11, 3.3, 11),
    (201, 1.48, 2.4, 18),
    (338.5, 1.85, 2.8, 25),
    (116, 2.22, 3.2, 14),
    (253.5, 2.59, 2.3, 21),
    (31, 2.96, 2.7, 10),
    (168.5, 3.33, 3.1, 17),
    (306, .10, 2.2, 24),
    (83.5, .47, 2.6, 13),
  ];

  static const _deepSpace = Color(0xFF061127);
  static const _skyTop = Color(0xFF081532);
  static const _coolStar = Color(0xFF7DD3FC);
  static const _meteorGlow = Color(0xFF7DD3FC);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, size.height),
          [_skyTop, _deepSpace],
        ),
    );

    final center = Offset(size.width * 0.5, size.height * 0.42);
    final radius = size.height * 0.62;
    final galaxy = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        const [
          Color(0xAD4784E0),
          Color(0xD1183979),
          Color(0xF008183B),
          _deepSpace,
        ],
        const [0.0, 0.45, 0.75, 1.0],
      );
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(1.0, 1.42);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawCircle(center, radius, galaxy);
    canvas.restore();

    void blob(Offset c, double r, Color color) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = ui.Gradient.radial(c, r, [color, color.withAlpha(0)]),
      );
    }

    blob(
      Offset(size.width * 0.72, size.height * 0.18),
      size.width * 0.24,
      const Color(0x3D38BDF8),
    );
    blob(
      Offset(size.width * 0.18, size.height * 0.82),
      size.width * 0.22,
      const Color(0x337C3AED),
    );

    final bar = Rect.fromCenter(center: center, width: 6, height: 56);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bar, const Radius.circular(3)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.70)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    for (final (x, y, s, o, cool) in _stars) {
      final c = Offset(size.width * x / 100, size.height * y / 100);
      final color = (cool ? _coolStar : Colors.white).withValues(alpha: o);
      if (s > 1.25) {
        canvas.drawCircle(
          c,
          s,
          Paint()
            ..color = cool
                ? const Color(0xCC7DD3FC)
                : const Color(0xB8FFFFFF)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
        );
      }
      canvas.drawCircle(c, s / 2, Paint()..color = color);
    }

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(size.width / 2, size.height / 2),
          size.longestSide * 0.72,
          [Colors.transparent, const Color(0x6B000000)],
          [0.46, 1.0],
        ),
    );

    if (!meteors) return;
    final now = _time.value;
    for (var i = 0; i < _meteors.length; i++) {
      final (angleDeg, delay, dur, lenPx) = _meteors[i];
      final phase = ((now - delay) / dur) % 1.0;
      final opacity = _meteorOpacity(phase);
      if (opacity <= 0) continue;
      final rad = angleDeg * math.pi / 180;
      final dir = Offset(math.cos(rad), math.sin(rad));
      final origin = Offset(
        size.width * (((i * 61.8) % 80 + 10) / 100),
        size.height * (((i * 38.2) % 80 + 10) / 100),
      );
      final travel = 10 + (340 - 10) * phase;
      final head = origin + dir * travel;
      final stretch = 0.08 + (2.5 - 0.08) * phase;
      final tail = head - dir * (lenPx * stretch);

      canvas.drawLine(
        tail,
        head,
        Paint()
          ..color = _meteorGlow.withValues(alpha: opacity * 0.85)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      );
      canvas.drawLine(
        tail,
        head,
        Paint()
          ..color = Colors.white.withValues(alpha: opacity)
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(
        head,
        1.3,
        Paint()..color = Colors.white.withValues(alpha: opacity),
      );
    }
  }

  static double _meteorOpacity(double t) {
    if (t < 0.16) return t / 0.16 * 0.12;
    if (t < 0.62) return 0.12 + (t - 0.16) / 0.46 * (0.58 - 0.12);
    return 0.58 * (1 - (t - 0.62) / 0.38);
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => old.meteors != meteors;
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.plan,
    required this.totalTokens,
    required this.endsAt,
    required this.enter,
    required this.flip,
    required this.flipDir,
    required this.onFlip,
  });

  final ClaimPreview plan;
  final int? totalTokens;
  final DateTime? endsAt;
  final Animation<double> enter;
  final Animation<double> flip;
  final int flipDir;
  final void Function(int dir) onFlip;

  @override
  Widget build(BuildContext context) {
    final tokens = claimTicketTokensOf(Theme.of(context).brightness);

    final maxWidth = math.min(318.0, MediaQuery.sizeOf(context).width - 160);
    final front = _ticketFront(context, tokens);

    return AnimatedBuilder(
      animation: Listenable.merge([enter, flip]),
      builder: (context, _) {
        final enterT = enter.value;
        final angleX = enterT * 4 * math.pi;
        final scale = 0.24 + (1 - 0.24) * enterT;
        final angleY = flip.value * 2 * math.pi * flipDir;
        bool frontVisible(double rad) {
          final deg = (rad * 180 / math.pi) % 360;
          return deg < 90 || deg > 270;
        }

        final showFront = frontVisible(angleX) && frontVisible(angleY);
        final card = Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: BoxDecoration(
            color: tokens.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              front,
              if (!showFront)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: tokens.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        );
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(angleX)
            ..rotateY(angleY)
            ..scaleByDouble(scale, scale, scale, 1),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final w = context.size?.width ?? maxWidth;
              onFlip(details.localPosition.dx < w / 2 ? -1 : 1);
            },
            child: card,
          ),
        );
      },
    );
  }

  Widget _ticketFront(BuildContext context, ClaimTicketTokens tokens) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final name = plan.name;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: ticketHPad,
        right: ticketHPad,
        bottom: ticketBottomPad,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _LogoBox(iconColor: Color(0xFFFAFAFA)),
              const SizedBox(width: 8),
              _SvgIcon(
                paths: _zcodeWordmarkPaths,
                viewBox: const Size(244, 54),
                height: 10,
                color: tokens.onPrimary,
              ),
              const SizedBox(width: 8),
              if (name.isNotEmpty)
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: tokens.chart,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (totalTokens != null) ...[
            const SizedBox(height: 16),
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    ClaimFormat.grouped(totalTokens!),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      fontFeatures: [ui.FontFeature.tabularFigures()],
                      height: 1.0,
                      color: tokens.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    l10n.claimTicketAmountUnit,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: tokens.onPrimary.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          for (final e in plan.entitlements)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.card_giftcard, size: 12, color: tokens.chart),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      e.period == 'daily'
                          ? l10n.claimTicketBenefitDaily(
                              e.showName,
                              ClaimFormat.compactOrNull(e.units, locale),
                              e.unitType == 'token'
                                  ? l10n.claimTicketAmountUnit
                                  : e.unitType,
                            )
                          : l10n.claimTicketBenefit(
                              e.showName,
                              ClaimFormat.compactOrNull(e.units, locale),
                              e.unitType == 'token'
                                  ? l10n.claimTicketAmountUnit
                                  : e.unitType,
                            ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: tokens.onPrimary.withValues(alpha: 0.60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 3),
          _TicketDivider(tokens: tokens, bleed: ticketHPad),
          const SizedBox(height: ticketDividerGap),
          SizedBox(
            height: ticketValidityRow,
            width: double.infinity,
            child: Center(
              child: Text(
                l10n.claimTicketEndsAt(
                  endsAt == null ? '—' : ClaimFormat.dateTime(endsAt!, locale),
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: tokens.onPrimary.withValues(alpha: 0.70),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketDivider extends StatelessWidget {
  const _TicketDivider({required this.tokens, required this.bleed});

  final ClaimTicketTokens tokens;

  final double bleed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ticketHoleDiameter,
      width: double.infinity,
      child: CustomPaint(
        painter: _TicketDividerPainter(
          dashColor: tokens.onPrimary.withValues(alpha: 0.18),
          bleed: bleed,
        ),
      ),
    );
  }
}

class _TicketDividerPainter extends CustomPainter {
  _TicketDividerPainter({required this.dashColor, required this.bleed});

  final Color dashColor;

  final double bleed;
  static const _holeColor = Color(0xFF061127);

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final inset = 14.0 + bleed;
    final paint = Paint()
      ..color = dashColor
      ..strokeWidth = 1;
    var x = inset;
    while (x < size.width - inset) {
      final end = math.min(x + 12, size.width - inset);
      canvas.drawLine(Offset(x, y), Offset(end, y), paint);
      x = end + 6;
    }
    canvas.drawCircle(
      Offset(-bleed, y),
      ticketHoleDiameter / 2,
      Paint()..color = _holeColor,
    );
    canvas.drawCircle(
      Offset(size.width + bleed, y),
      ticketHoleDiameter / 2,
      Paint()..color = _holeColor,
    );
  }

  @override
  bool shouldRepaint(_TicketDividerPainter old) =>
      old.dashColor != dashColor || old.bleed != bleed;
}

class _LogoBox extends StatelessWidget {
  const _LogoBox({required this.iconColor});

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF000000), Color(0xFF151718)],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Center(
        child: _SvgIcon(
          paths: _zBoltPaths,
          viewBox: const Size(256, 218),
          width: 10,
          color: iconColor,
        ),
      ),
    );
  }
}

class _SvgIcon extends StatelessWidget {
  const _SvgIcon({
    required this.paths,
    required this.viewBox,
    this.width,
    this.height,
    required this.color,
  });

  final List<String> paths;
  final Size viewBox;
  final double? width;
  final double? height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final w = width ?? height! * viewBox.width / viewBox.height;
    final h = height ?? width! * viewBox.height / viewBox.width;
    return SizedBox(
      width: w,
      height: h,
      child: CustomPaint(
        painter: _SvgPathPainter(paths: paths, viewBox: viewBox, color: color),
      ),
    );
  }
}

class _SvgPathPainter extends CustomPainter {
  _SvgPathPainter({
    required this.paths,
    required this.viewBox,
    required this.color,
  });

  final List<String> paths;
  final Size viewBox;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / viewBox.width, size.height / viewBox.height);
    final paint = Paint()..color = color;
    for (final d in paths) {
      canvas.drawPath(_parseSvgPath(d), paint);
    }
  }

  static ui.Path _parseSvgPath(String d) {
    final path = ui.Path();
    final cmdRe = RegExp(r'([MLCHVZ])([^MLCHVZ]*)');
    var cx = 0.0;
    var cy = 0.0;
    for (final m in cmdRe.allMatches(d)) {
      final cmd = m.group(1)!;
      final nums = RegExp(r'-?\d*\.?\d+(?:[eE][-+]?\d+)?')
          .allMatches(m.group(2)!)
          .map((x) => double.parse(x.group(0)!))
          .toList();
      switch (cmd) {
        case 'M':
          for (var i = 0; i + 1 < nums.length; i += 2) {
            cx = nums[i];
            cy = nums[i + 1];
            if (i == 0) {
              path.moveTo(cx, cy);
            } else {
              path.lineTo(cx, cy);
            }
          }
        case 'L':
          for (var i = 0; i + 1 < nums.length; i += 2) {
            cx = nums[i];
            cy = nums[i + 1];
            path.lineTo(cx, cy);
          }
        case 'C':
          for (var i = 0; i + 5 < nums.length; i += 6) {
            path.cubicTo(
              nums[i],
              nums[i + 1],
              nums[i + 2],
              nums[i + 3],
              nums[i + 4],
              nums[i + 5],
            );
            cx = nums[i + 4];
            cy = nums[i + 5];
          }
        case 'H':
          for (final n in nums) {
            cx = n;
            path.lineTo(cx, cy);
          }
        case 'V':
          for (final n in nums) {
            cy = n;
            path.lineTo(cx, cy);
          }
        case 'Z':
          path.close();
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(_SvgPathPainter old) =>
      old.color != color || old.paths != paths;
}

const _zBoltPaths = [
  'M134.4 0.130152L116.48 25.6022C113.665 29.5699 109.054 32.0019 104.064 32.0019H6.3999V0C6.3999 0.130149 134.4 0.130152 134.4 0.130152Z',
  'M256 0.130127L102.401 217.732H0L153.599 0.130127H256Z',
  'M121.601 217.732L139.65 192.134C142.465 188.166 147.076 185.734 152.067 185.734H249.604V217.736H121.601V217.732Z',
];

const _zcodeWordmarkPaths = [
  'M217.995 51.9734V41.8837H243.618V51.9734H217.995ZM217.995 11.2515V1.16174H243.618V11.2515H217.995ZM217.995 30.197V20.325H242.166V30.197H217.995ZM209.865 1.16174H221.624V51.9734H209.865V1.16174Z',
  'M156.628 1.16174H169.259V51.9734H156.628V1.16174ZM174.775 51.9734H164.758V41.0852H174.34C176.276 41.0852 178.139 40.8432 179.929 40.3593C181.768 39.8754 183.365 39.0769 184.72 37.9639C186.123 36.8509 187.236 35.3749 188.059 33.536C188.882 31.6487 189.293 29.3259 189.293 26.5676C189.293 23.8092 188.882 21.5106 188.059 19.6717C187.236 17.7844 186.123 16.2843 184.72 15.1712C183.365 14.0582 181.768 13.2598 179.929 12.7758C178.139 12.2919 176.276 12.05 174.34 12.05H164.758V1.16174H174.775C180.341 1.16174 185.156 2.20217 189.22 4.28303C193.285 6.36389 196.431 9.29161 198.657 13.0662C200.883 16.8408 201.996 21.3412 201.996 26.5676C201.996 31.7455 200.883 36.246 198.657 40.069C196.431 43.8435 193.285 46.7713 189.22 48.8521C185.156 50.933 180.341 51.9734 174.775 51.9734Z',
  'M107.102 26.5672C107.102 29.5675 107.683 32.2291 108.844 34.5519C110.054 36.8264 111.724 38.6169 113.853 39.9234C116.031 41.23 118.571 41.8833 121.475 41.8833C124.33 41.8833 126.822 41.23 128.951 39.9234C131.129 38.6169 132.798 36.8264 133.96 34.5519C135.17 32.2291 135.774 29.5675 135.774 26.5672C135.774 23.5669 135.194 20.9296 134.032 18.6551C132.871 16.3323 131.226 14.5176 129.096 13.211C126.967 11.9044 124.427 11.2511 121.475 11.2511C118.571 11.2511 116.031 11.9044 113.853 13.211C111.724 14.5176 110.054 16.3323 108.844 18.6551C107.683 20.9296 107.102 23.5669 107.102 26.5672ZM94.1089 26.5672C94.1089 22.6475 94.7864 19.0665 96.1414 15.8242C97.5448 12.5819 99.4804 9.77519 101.948 7.40398C104.416 5.03277 107.32 3.21807 110.659 1.95988C113.998 0.653293 117.603 0 121.475 0C125.394 0 129 0.653293 132.29 1.95988C135.629 3.21807 138.533 5.03277 141.001 7.40398C143.469 9.77519 145.38 12.5819 146.735 15.8242C148.09 19.0665 148.768 22.6475 148.768 26.5672C148.768 30.487 148.09 34.0922 146.735 37.3829C145.429 40.6735 143.541 43.5287 141.073 45.9483C138.654 48.3679 135.774 50.2551 132.435 51.6101C129.096 52.9167 125.443 53.57 121.475 53.57C117.458 53.57 113.78 52.9167 110.441 51.6101C107.102 50.2551 104.199 48.3679 101.731 45.9483C99.3111 43.5287 97.4238 40.6735 96.0688 37.3829C94.7622 34.0922 94.1089 30.487 94.1089 26.5672Z',
  'M56.5689 26.5672C56.5689 29.6643 57.2706 32.3501 58.674 34.6245C60.0773 36.8505 61.9162 38.5443 64.1907 39.7057C66.5135 40.8671 69.0541 41.4478 71.8124 41.4478C74.232 41.4478 76.3613 41.1332 78.2002 40.5041C80.0391 39.8751 81.6844 39.0524 83.1362 38.0362C84.5879 37.0199 85.8703 35.9311 86.9833 34.7697V47.9807C84.9509 49.5777 82.7248 50.8359 80.3052 51.7553C77.8856 52.6748 74.8127 53.1345 71.0865 53.1345C67.0216 53.1345 63.2712 52.5054 59.8354 51.2472C56.3995 49.989 53.4476 48.1743 50.9796 45.8031C48.5116 43.4319 46.6002 40.6251 45.2452 37.3829C43.8902 34.1406 43.2127 30.5354 43.2127 26.5672C43.2127 22.5991 43.8902 18.9939 45.2452 15.7516C46.6002 12.5093 48.5116 9.7026 50.9796 7.3314C53.4476 4.96018 56.3995 3.14548 59.8354 1.88729C63.2712 0.629095 67.0216 0 71.0865 0C74.8127 0 77.8856 0.459725 80.3052 1.37917C82.7248 2.29862 84.9509 3.55681 86.9833 5.15375V18.3648C85.8703 17.2034 84.5879 16.1146 83.1362 15.0983C81.6844 14.0337 80.0391 13.211 78.2002 12.6303C76.3613 12.0012 74.232 11.6867 71.8124 11.6867C69.0541 11.6867 66.5135 12.2674 64.1907 13.4288C61.9162 14.5902 60.0773 16.2839 58.674 18.51C57.2706 20.736 56.5689 23.4218 56.5689 26.5672Z',
  'M3.48423 12.1225V1.16174H43.3351L19.3084 41.4481H40.7219V51.9734H0L23.6637 12.1225H3.48423Z',
];
