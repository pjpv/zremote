import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/device_store.dart';

const kThemeSystem = 'system';

class ThemeModeSettingNotifier extends Notifier<String> {
  ThemeModeSettingNotifier({String? initial}) : _initial = initial;

  final String? _initial;

  @override
  String build() {
    final initial = _initial;
    if (initial != null) {
      return _valid(initial) ? initial : kThemeSystem;
    }
    _load();
    return kThemeSystem;
  }

  Future<void> _load() async {
    final value = await DeviceStore.instance.themeModeSetting();
    state = _valid(value) ? value : kThemeSystem;
  }

  static bool _valid(String v) =>
      v == kThemeSystem || v == 'dark' || v == 'light';

  Future<void> set(String value) async {
    if (!_valid(value)) return;
    await DeviceStore.instance.setThemeModeSetting(value);
    state = value;
  }
}

final themeModeSettingProvider =
    NotifierProvider<ThemeModeSettingNotifier, String>(
      ThemeModeSettingNotifier.new,
    );

ThemeMode resolveThemeMode(String setting) => switch (setting) {
  'dark' => ThemeMode.dark,
  'light' => ThemeMode.light,
  _ => ThemeMode.system,
};

const kThemeDark = 'dark';
const kThemeLight = 'light';
