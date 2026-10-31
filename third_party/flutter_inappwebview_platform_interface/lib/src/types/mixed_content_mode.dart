import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'mixed_content_mode.g.dart';

@ExchangeableEnum()
class MixedContentMode_ {
  // ignore: unused_field
  final int _value;
  const MixedContentMode_._internal(this._value);

  static const MIXED_CONTENT_ALWAYS_ALLOW =
      const MixedContentMode_._internal(0);

  static const MIXED_CONTENT_NEVER_ALLOW = const MixedContentMode_._internal(1);

  static const MIXED_CONTENT_COMPATIBILITY_MODE =
      const MixedContentMode_._internal(2);
}

@Deprecated("Use MixedContentMode instead")
@ExchangeableEnum()
class AndroidMixedContentMode_ {
  // ignore: unused_field
  final int _value;
  const AndroidMixedContentMode_._internal(this._value);

  static const MIXED_CONTENT_ALWAYS_ALLOW =
      const AndroidMixedContentMode_._internal(0);

  static const MIXED_CONTENT_NEVER_ALLOW =
      const AndroidMixedContentMode_._internal(1);

  static const MIXED_CONTENT_COMPATIBILITY_MODE =
      const AndroidMixedContentMode_._internal(2);
}
