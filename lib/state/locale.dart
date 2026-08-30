import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../services/device_store.dart';

const kLocaleSystem = 'system';

class LocaleSettingNotifier extends Notifier<String> {
  LocaleSettingNotifier({String? initial}) : _initial = initial;

  final String? _initial;

  @override
  String build() {
    final initial = _initial;
    if (initial != null) {
      return _valid(initial) ? initial : kLocaleSystem;
    }
    _load();
    return kLocaleSystem;
  }

  Future<void> _load() async {
    final value = await DeviceStore.instance.localeSetting();
    state = _valid(value) ? value : kLocaleSystem;
  }

  static bool _valid(String v) =>
      v == kLocaleSystem ||
      AppLocalizations.supportedLocales.any((l) => l.languageCode == v);

  Future<void> set(String value) async {
    if (!_valid(value)) return;
    await DeviceStore.instance.setLocaleSetting(value);
    state = value;
  }
}

final localeSettingProvider = NotifierProvider<LocaleSettingNotifier, String>(
  LocaleSettingNotifier.new,
);

const localeNativeNames = {'zh': '中文', 'en': 'English'};

String localeDisplayName(String tag) => localeNativeNames[tag] ?? tag;
