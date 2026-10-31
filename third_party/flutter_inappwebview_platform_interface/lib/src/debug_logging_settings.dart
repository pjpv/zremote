import 'package:flutter/foundation.dart';

class DebugLoggingSettings {
  bool enabled;

  List<RegExp> excludeFilter;

  int maxLogMessageLength;

  bool usePrint;

  DebugLoggingSettings(
      {this.enabled = kDebugMode,
      this.excludeFilter = const [],
      this.maxLogMessageLength = -1,
      this.usePrint = false});
}
