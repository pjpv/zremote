import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'in_app_webview_hit_test_result_type.g.dart';

@ExchangeableEnum()
class InAppWebViewHitTestResultType_ {
  // ignore: unused_field
  final int _value;
  const InAppWebViewHitTestResultType_._internal(this._value);

  static const UNKNOWN_TYPE = const InAppWebViewHitTestResultType_._internal(0);

  static const PHONE_TYPE = const InAppWebViewHitTestResultType_._internal(2);

  static const GEO_TYPE = const InAppWebViewHitTestResultType_._internal(3);

  static const EMAIL_TYPE = const InAppWebViewHitTestResultType_._internal(4);

  static const IMAGE_TYPE = const InAppWebViewHitTestResultType_._internal(5);

  static const SRC_ANCHOR_TYPE =
      const InAppWebViewHitTestResultType_._internal(7);

  static const SRC_IMAGE_ANCHOR_TYPE =
      const InAppWebViewHitTestResultType_._internal(8);

  static const EDIT_TEXT_TYPE =
      const InAppWebViewHitTestResultType_._internal(9);
}
