import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/state/session_status.dart';
import 'package:zremote/theme.dart';

void main() {
  test('theme(dark)：注册深色母版 extension + scaffold/状态栏随动', () {
    final t = ZT.theme(Brightness.dark);
    expect(t.extension<ZTPalette>(), same(ZT.dark));
    expect(t.scaffoldBackgroundColor, ZT.dark.bg);
    final overlay = t.appBarTheme.systemOverlayStyle!;
    expect(overlay.statusBarIconBrightness, Brightness.light);
    expect(overlay.statusBarBrightness, Brightness.dark);
  });

  test('theme(light)：注册浅色 extension + 状态栏图标翻暗', () {
    final t = ZT.theme(Brightness.light);
    expect(t.extension<ZTPalette>(), same(ZT.light));
    expect(t.scaffoldBackgroundColor, ZT.light.bg);
    final overlay = t.appBarTheme.systemOverlayStyle!;
    expect(overlay.statusBarIconBrightness, Brightness.dark);
    expect(overlay.statusBarBrightness, Brightness.light);
  });

  testWidgets('context.zt 回落：裸壳（无 extension）按 Theme 亮度解析', (tester) async {
    late ZTPalette captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            captured = context.zt;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(captured, same(ZT.light));
  });

  testWidgets('context.zt：themeMode=system 下按平台亮度解析', (tester) async {
    late ZTPalette captured;
    await tester.pumpWidget(
      MaterialApp(
        theme: ZT.theme(Brightness.light),
        darkTheme: ZT.theme(Brightness.dark),
        themeMode: ThemeMode.system,
        home: Builder(
          builder: (context) {
            captured = context.zt;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(captured, same(ZT.light));
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(
      tester.binding.platformDispatcher.clearPlatformBrightnessTestValue,
    );
    await tester.pumpAndSettle();
    expect(captured, same(ZT.dark));
  });

  test('palette lerp：中点插值不越界、null other 原样返回', () {
    final mid = ZT.dark.lerp(ZT.light, 0.5);
    expect(mid.bg.a, 1.0);
    expect(mid.bg.r, greaterThanOrEqualTo(ZT.dark.bg.r));
    expect(mid.bg.r, lessThanOrEqualTo(ZT.light.bg.r));
    expect(ZT.dark.lerp(null, 0.3), same(ZT.dark));
    final copied = ZT.dark.copyWith(accent: const Color(0x00000001));
    expect(copied.accent, const Color(0x00000001));
    expect(copied.bg, ZT.dark.bg);
  });

  test('v2 换色：主操作色 Dev Blue 落位', () {
    expect(ZT.dark.accent, const Color(0xFF3B82F6));
    expect(ZT.light.accent, const Color(0xFF2563EB));
  });

  test('v2 新增字段的 copyWith/lerp 覆盖', () {
    final copied = ZT.dark.copyWith(surfaceHover: const Color(0x00000002));
    expect(copied.surfaceHover, const Color(0x00000002));
    expect(copied.surface, ZT.dark.surface);
    final lerped = ZT.dark.lerp(ZT.light, 1);
    expect(lerped.hairlineBright, ZT.light.hairlineBright);
    expect(lerped.accentSubtle, ZT.light.accentSubtle);
    expect(lerped.accentBorder, ZT.light.accentBorder);
    expect(lerped.textTertiary, ZT.light.textTertiary);
    expect(lerped.surfaceHover, ZT.light.surfaceHover);
  });

  test('statusColor 三态语义双 palette 一致（决议 2 解耦后）', () {
    for (final p in [ZT.dark, ZT.light]) {
      expect(p.statusColor(null), p.warn);
      expect(p.statusColor(SessionStatus.loading), p.warn);
      expect(p.statusColor(SessionStatus.live), p.live);
      expect(p.statusColor(SessionStatus.error), p.danger);
    }
  });
}
