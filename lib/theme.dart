import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'state/session_status.dart';

final class ZTPalette extends ThemeExtension<ZTPalette> {
  const ZTPalette({
    required this.bg,
    required this.surface,
    required this.surfaceHi,
    required this.surfaceHover,
    required this.field,
    required this.hairline,
    required this.hairlineBright,
    required this.accent,
    required this.onAccent,
    required this.accentSubtle,
    required this.accentBorder,
    required this.live,
    required this.danger,
    required this.warn,
    required this.textHi,
    required this.textLo,
    required this.textTertiary,
  });

  final Color bg;
  final Color surface;
  final Color surfaceHi;

  final Color surfaceHover;

  final Color field;

  final Color hairline;

  final Color hairlineBright;

  final Color accent;
  final Color onAccent;

  final Color accentSubtle;

  final Color accentBorder;

  final Color live;
  final Color danger;
  final Color warn;

  final Color textHi;
  final Color textLo;

  final Color textTertiary;

  Color statusColor(SessionStatus? status) => switch (status) {
    SessionStatus.live => live,
    SessionStatus.error => danger,
    SessionStatus.loading || null => warn,
  };

  @override
  ZTPalette copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceHi,
    Color? surfaceHover,
    Color? field,
    Color? hairline,
    Color? hairlineBright,
    Color? accent,
    Color? onAccent,
    Color? accentSubtle,
    Color? accentBorder,
    Color? live,
    Color? danger,
    Color? warn,
    Color? textHi,
    Color? textLo,
    Color? textTertiary,
  }) => ZTPalette(
    bg: bg ?? this.bg,
    surface: surface ?? this.surface,
    surfaceHi: surfaceHi ?? this.surfaceHi,
    surfaceHover: surfaceHover ?? this.surfaceHover,
    field: field ?? this.field,
    hairline: hairline ?? this.hairline,
    hairlineBright: hairlineBright ?? this.hairlineBright,
    accent: accent ?? this.accent,
    onAccent: onAccent ?? this.onAccent,
    accentSubtle: accentSubtle ?? this.accentSubtle,
    accentBorder: accentBorder ?? this.accentBorder,
    live: live ?? this.live,
    danger: danger ?? this.danger,
    warn: warn ?? this.warn,
    textHi: textHi ?? this.textHi,
    textLo: textLo ?? this.textLo,
    textTertiary: textTertiary ?? this.textTertiary,
  );

  @override
  ZTPalette lerp(ZTPalette? other, double t) {
    if (other == null) return this;
    return ZTPalette(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHi: Color.lerp(surfaceHi, other.surfaceHi, t)!,
      surfaceHover: Color.lerp(surfaceHover, other.surfaceHover, t)!,
      field: Color.lerp(field, other.field, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      hairlineBright: Color.lerp(hairlineBright, other.hairlineBright, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      accentBorder: Color.lerp(accentBorder, other.accentBorder, t)!,
      live: Color.lerp(live, other.live, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warn: Color.lerp(warn, other.warn, t)!,
      textHi: Color.lerp(textHi, other.textHi, t)!,
      textLo: Color.lerp(textLo, other.textLo, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
    );
  }
}

abstract final class ZT {
  static const dark = ZTPalette(
    bg: Color(0xFF0A0B0E),
    surface: Color(0xFF12141A),
    surfaceHi: Color(0xFF181B22),
    surfaceHover: Color(0xFF20242D),
    field: Color(0xFF0C0E12),
    hairline: Color(0x14FFFFFF),
    hairlineBright: Color(0x29FFFFFF),
    accent: Color(0xFF3B82F6),
    onAccent: Color(0xFFFFFFFF),
    accentSubtle: Color(0x1F3B82F6),
    accentBorder: Color(0x523B82F6),
    live: Color(0xFF10B981),
    danger: Color(0xFFEF4444),
    warn: Color(0xFFF59E0B),
    textHi: Color(0xFFF3F4F6),
    textLo: Color(0xFF9CA3AF),
    textTertiary: Color(0xFF6B7280),
  );

  static const light = ZTPalette(
    bg: Color(0xFFF6F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceHi: Color(0xFFFFFFFF),
    surfaceHover: Color(0xFFF3F4F6),
    field: Color(0xFFF1F3F5),
    hairline: Color(0xFFD0D7DE),
    hairlineBright: Color(0xFFAFB8C1),
    accent: Color(0xFF2563EB),
    onAccent: Color(0xFFFFFFFF),
    accentSubtle: Color(0x142563EB),
    accentBorder: Color(0x472563EB),
    live: Color(0xFF16A34A),
    danger: Color(0xFFDC2626),
    warn: Color(0xFFD97706),
    textHi: Color(0xFF1F2328),
    textLo: Color(0xFF57606A),
    textTertiary: Color(0xFF8C959F),
  );

  static ZTPalette paletteOf(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  static ThemeData theme(Brightness brightness) {
    final p = paletteOf(brightness);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: p.accent,
          brightness: brightness,
        ).copyWith(
          primary: p.accent,
          onPrimary: p.onAccent,
          secondary: p.accent,
          surface: p.surface,
          error: p.danger,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      splashFactory: InkSparkle.splashFactory,
      extensions: [p],
      appBarTheme: AppBarTheme(
        backgroundColor: p.bg,
        foregroundColor: p.textHi,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 48,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: p.textHi,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: p.hairline),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.hairline, thickness: 1, space: 1),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: p.hairline),
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: p.textHi,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.surfaceHi,
        elevation: 12,
        shadowColor: Colors.black.withValues(alpha: 0.6),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.16)
                : p.hairlineBright,
            width: 1.0,
          ),
        ),
        textStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: p.textHi,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: p.accent,
          foregroundColor: p.onAccent,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.accent,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: p.field,
        hintStyle: TextStyle(color: p.textLo.withValues(alpha: 0.55)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.accent, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.surfaceHi,
        contentTextStyle: TextStyle(
          fontSize: 13,
          color: p.textHi,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: p.hairline.withValues(alpha: 0.7)),
        ),
        elevation: 6,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        extendedTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? p.accent : null,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: p.accent,
        unselectedLabelColor: p.textLo,
        indicator: ShapeDecoration(
          color: p.accentSubtle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.accent),
      listTileTheme: ListTileThemeData(
        iconColor: p.textLo,
        textColor: p.textHi,
        subtitleTextStyle: TextStyle(color: p.textLo),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: p.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}

extension ZTContext on BuildContext {
  ZTPalette get zt =>
      Theme.of(this).extension<ZTPalette>() ??
      ZT.paletteOf(Theme.of(this).brightness);
}

const String kMonoFamily = 'JetBrainsMono';

TextStyle zrMono({
  double fontSize = 11,
  FontWeight weight = FontWeight.w600,
  Color? color,
  double letterSpacing = 0.4,
}) => TextStyle(
  fontFamily: kMonoFamily,
  fontSize: fontSize,
  fontWeight: weight,
  letterSpacing: letterSpacing,
  color: color,
  fontFeatures: const [FontFeature.tabularFigures()],
);
