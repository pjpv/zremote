import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'compress_format.g.dart';

@ExchangeableEnum()
class CompressFormat_ {
  // ignore: unused_field
  final String _value;
  const CompressFormat_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(),
    EnumIOSPlatform(),
    EnumMacOSPlatform(),
    EnumWindowsPlatform(),
  ])
  static const PNG = const CompressFormat_._internal("PNG");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(),
    EnumIOSPlatform(),
    EnumMacOSPlatform(),
    EnumWindowsPlatform(),
  ])
  static const JPEG = const CompressFormat_._internal("JPEG");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(),
    EnumWindowsPlatform(),
  ])
  static const WEBP = const CompressFormat_._internal("WEBP");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(available: '30'),
  ])
  static const WEBP_LOSSY = const CompressFormat_._internal("WEBP_LOSSY");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(available: '30'),
  ])
  static const WEBP_LOSSLESS = const CompressFormat_._internal("WEBP_LOSSLESS");
}
