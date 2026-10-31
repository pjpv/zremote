import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'window_type.g.dart';

@ExchangeableEnum()
class WindowType_ {
  // ignore: unused_field
  final String _value;

  const WindowType_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [
    EnumMacOSPlatform(value: 'WINDOW'),
    EnumWindowsPlatform(value: 'WINDOW')
  ])
  static const WINDOW = const WindowType_._internal('WINDOW');

  @EnumSupportedPlatforms(platforms: [
    EnumMacOSPlatform(value: 'CHILD'),
    EnumWindowsPlatform(value: 'CHILD')
  ])
  static const CHILD = const WindowType_._internal('CHILD');

  @EnumSupportedPlatforms(
      platforms: [EnumMacOSPlatform(value: 'TABBED', available: "10.12+")])
  static const TABBED = const WindowType_._internal('TABBED');
}
