import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'custom_tabs_post_message_result_type.g.dart';

@ExchangeableEnum()
class CustomTabsPostMessageResultType_ {
  // ignore: unused_field
  final int _value;

  // ignore: unused_field
  final int? _nativeValue = null;

  const CustomTabsPostMessageResultType_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [EnumAndroidPlatform(value: 0)])
  static const SUCCESS = const CustomTabsPostMessageResultType_._internal(0);

  @EnumSupportedPlatforms(platforms: [EnumAndroidPlatform(value: -1)])
  static const FAILURE_DISALLOWED =
      const CustomTabsPostMessageResultType_._internal(-1);

  @EnumSupportedPlatforms(platforms: [EnumAndroidPlatform(value: -2)])
  static const FAILURE_REMOTE_ERROR =
      const CustomTabsPostMessageResultType_._internal(-2);

  @EnumSupportedPlatforms(platforms: [EnumAndroidPlatform(value: -3)])
  static const FAILURE_MESSAGING_ERROR =
      const CustomTabsPostMessageResultType_._internal(-3);
}
