import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../content_blocker.dart';

part 'content_blocker_action_type.g.dart';

@ExchangeableEnum()
class ContentBlockerActionType_ {
  // ignore: unused_field
  final String _value;

  const ContentBlockerActionType_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(value: 'block'),
    EnumIOSPlatform(value: 'block'),
    EnumMacOSPlatform(value: 'block')
  ])
  static const BLOCK = const ContentBlockerActionType_._internal('block');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(value: 'css-display-none'),
    EnumIOSPlatform(value: 'css-display-none'),
    EnumMacOSPlatform(value: 'css-display-none')
  ])
  static const CSS_DISPLAY_NONE =
      const ContentBlockerActionType_._internal('css-display-none');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(value: 'make-https'),
    EnumIOSPlatform(value: 'make-https'),
    EnumMacOSPlatform(value: 'make-https')
  ])
  static const MAKE_HTTPS =
      const ContentBlockerActionType_._internal('make-https');

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(value: 'block-cookies'),
    EnumMacOSPlatform(value: 'block-cookies')
  ])
  static const BLOCK_COOKIES =
      const ContentBlockerActionType_._internal('block-cookies');

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(value: 'ignore-previous-rules'),
    EnumMacOSPlatform(value: 'ignore-previous-rules')
  ])
  static const IGNORE_PREVIOUS_RULES =
      const ContentBlockerActionType_._internal('ignore-previous-rules');
}
