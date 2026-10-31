import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device.dart';

const String _kProfilePrefix = 'zr_';

final RegExp _kInvalidProfileChars = RegExp(r'[^A-Za-z0-9_-]');

String? webProfileNameFor(RemoteDevice device) {
  if (device.kind != DeviceKind.v2) return null;
  final sanitized =
      device.id.replaceAll(_kInvalidProfileChars, '_');
  if (sanitized.isEmpty) return null;
  return '$_kProfilePrefix$sanitized';
}

bool shouldShowIsolationFallback({
  required DeviceKind kind,
  required bool multiProfileSupported,
}) =>
    kind == DeviceKind.v2 && !multiProfileSupported;

final multiProfileSupportedProvider = FutureProvider<bool>((ref) async {
  if (defaultTargetPlatform != TargetPlatform.android) return false;
  try {
    return await WebViewFeature.isFeatureSupported(
        WebViewFeature.MULTI_PROFILE);
  } catch (e) {
    debugPrint('[zr-profile] MULTI_PROFILE probe failed: $e');
    return false;
  }
});
