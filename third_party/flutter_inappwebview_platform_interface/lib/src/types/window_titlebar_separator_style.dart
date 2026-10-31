import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'window_titlebar_separator_style.g.dart';

@ExchangeableEnum()
class WindowTitlebarSeparatorStyle_ {
  // ignore: unused_field
  final int _value;
  // ignore: unused_field
  final int? _nativeValue = null;
  const WindowTitlebarSeparatorStyle_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [EnumMacOSPlatform(value: 0)])
  static const AUTOMATIC = const WindowTitlebarSeparatorStyle_._internal(0);

  @EnumSupportedPlatforms(platforms: [EnumMacOSPlatform(value: 1)])
  static const NONE = const WindowTitlebarSeparatorStyle_._internal(1);

  @EnumSupportedPlatforms(platforms: [EnumMacOSPlatform(value: 2)])
  static const LINE = const WindowTitlebarSeparatorStyle_._internal(2);

  @EnumSupportedPlatforms(platforms: [EnumMacOSPlatform(value: 3)])
  static const SHADOW = const WindowTitlebarSeparatorStyle_._internal(3);
}
