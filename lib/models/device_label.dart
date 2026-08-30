import 'package:flutter/widgets.dart' show Locale;

import '../l10n/app_localizations.dart';
import 'device.dart';

final l10nZh = lookupAppLocalizations(const Locale('zh'));

extension RemoteDeviceDisplay on RemoteDevice {
  String displayName(AppLocalizations? l10n) {
    final name = label.trim();
    return name.isEmpty ? (l10n ?? l10nZh).unnamedDevice : name;
  }
}
