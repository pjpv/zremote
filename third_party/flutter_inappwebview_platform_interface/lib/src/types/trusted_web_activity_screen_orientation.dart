import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'trusted_web_activity_screen_orientation.g.dart';

@ExchangeableEnum()
class TrustedWebActivityScreenOrientation_ {
  // ignore: unused_field
  final int _value;
  const TrustedWebActivityScreenOrientation_._internal(this._value);

  static const DEFAULT =
      const TrustedWebActivityScreenOrientation_._internal(0);

  static const PORTRAIT_PRIMARY =
      const TrustedWebActivityScreenOrientation_._internal(1);

  static const PORTRAIT_SECONDARY =
      const TrustedWebActivityScreenOrientation_._internal(2);

  static const LANDSCAPE_PRIMARY =
      const TrustedWebActivityScreenOrientation_._internal(3);

  static const LANDSCAPE_SECONDARY =
      const TrustedWebActivityScreenOrientation_._internal(4);

  static const ANY = const TrustedWebActivityScreenOrientation_._internal(5);

  static const LANDSCAPE =
      const TrustedWebActivityScreenOrientation_._internal(6);

  static const PORTRAIT =
      const TrustedWebActivityScreenOrientation_._internal(7);

  static const NATURAL =
      const TrustedWebActivityScreenOrientation_._internal(8);
}
