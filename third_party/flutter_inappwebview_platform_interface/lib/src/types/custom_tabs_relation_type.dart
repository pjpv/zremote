import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'custom_tabs_relation_type.g.dart';

@ExchangeableEnum()
class CustomTabsRelationType_ {
  // ignore: unused_field
  final int _value;

  // ignore: unused_field
  final int? _nativeValue = null;

  const CustomTabsRelationType_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [EnumAndroidPlatform(value: 1)])
  static const USE_AS_ORIGIN = const CustomTabsRelationType_._internal(1);

  @EnumSupportedPlatforms(platforms: [EnumAndroidPlatform(value: 2)])
  static const HANDLE_ALL_URLS = const CustomTabsRelationType_._internal(2);
}
