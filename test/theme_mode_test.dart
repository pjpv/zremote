import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zremote/state/theme_mode.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('resolveThemeMode', () {
    test('合法值直映，其余一律 system', () {
      expect(resolveThemeMode('system'), ThemeMode.system);
      expect(resolveThemeMode('dark'), ThemeMode.dark);
      expect(resolveThemeMode('light'), ThemeMode.light);
      expect(resolveThemeMode('zai-dark'), ThemeMode.system);
      expect(resolveThemeMode(''), ThemeMode.system);
    });
  });

  group('ThemeModeSettingNotifier', () {
    test('initial 合法值直接生效（main() 预载路径）', () {
      final container = ProviderContainer(
        overrides: [
          themeModeSettingProvider.overrideWith(
            () => ThemeModeSettingNotifier(initial: 'dark'),
          ),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(themeModeSettingProvider), 'dark');
    });

    test('initial 脏值夹回 system（降级遗留）', () {
      final container = ProviderContainer(
        overrides: [
          themeModeSettingProvider.overrideWith(
            () => ThemeModeSettingNotifier(initial: 'zai-dark'),
          ),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(themeModeSettingProvider), 'system');
    });

    testWidgets('懒加载路径：读存储值；set() 落盘并更新状态', (tester) async {
      SharedPreferences.setMockInitialValues({'zremote.themeMode': 'light'});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(themeModeSettingProvider), 'system');
      await tester.pumpAndSettle();
      expect(container.read(themeModeSettingProvider), 'light');

      await container.read(themeModeSettingProvider.notifier).set('dark');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('zremote.themeMode'), 'dark');
      expect(container.read(themeModeSettingProvider), 'dark');
    });

    test('set 脏值拒绝（不落盘不改状态）', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer(
        overrides: [
          themeModeSettingProvider.overrideWith(
            () => ThemeModeSettingNotifier(initial: 'light'),
          ),
        ],
      );
      addTearDown(container.dispose);
      await container.read(themeModeSettingProvider.notifier).set('blue');
      expect(container.read(themeModeSettingProvider), 'light');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('zremote.themeMode'), isNull);
    });
  });
}
