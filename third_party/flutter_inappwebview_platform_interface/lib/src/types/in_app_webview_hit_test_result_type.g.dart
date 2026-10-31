
part of 'in_app_webview_hit_test_result_type.dart';

class InAppWebViewHitTestResultType {
  final int _value;
  final int _nativeValue;
  const InAppWebViewHitTestResultType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory InAppWebViewHitTestResultType._internalMultiPlatform(
          int value, Function nativeValue) =>
      InAppWebViewHitTestResultType._internal(value, nativeValue());

  static const EDIT_TEXT_TYPE = InAppWebViewHitTestResultType._internal(9, 9);

  static const EMAIL_TYPE = InAppWebViewHitTestResultType._internal(4, 4);

  static const GEO_TYPE = InAppWebViewHitTestResultType._internal(3, 3);

  static const IMAGE_TYPE = InAppWebViewHitTestResultType._internal(5, 5);

  static const PHONE_TYPE = InAppWebViewHitTestResultType._internal(2, 2);

  static const SRC_ANCHOR_TYPE = InAppWebViewHitTestResultType._internal(7, 7);

  static const SRC_IMAGE_ANCHOR_TYPE =
      InAppWebViewHitTestResultType._internal(8, 8);

  static const UNKNOWN_TYPE = InAppWebViewHitTestResultType._internal(0, 0);

  static final Set<InAppWebViewHitTestResultType> values = [
    InAppWebViewHitTestResultType.EDIT_TEXT_TYPE,
    InAppWebViewHitTestResultType.EMAIL_TYPE,
    InAppWebViewHitTestResultType.GEO_TYPE,
    InAppWebViewHitTestResultType.IMAGE_TYPE,
    InAppWebViewHitTestResultType.PHONE_TYPE,
    InAppWebViewHitTestResultType.SRC_ANCHOR_TYPE,
    InAppWebViewHitTestResultType.SRC_IMAGE_ANCHOR_TYPE,
    InAppWebViewHitTestResultType.UNKNOWN_TYPE,
  ].toSet();

  static InAppWebViewHitTestResultType? fromValue(int? value) {
    if (value != null) {
      try {
        return InAppWebViewHitTestResultType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static InAppWebViewHitTestResultType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return InAppWebViewHitTestResultType.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 9:
        return 'EDIT_TEXT_TYPE';
      case 4:
        return 'EMAIL_TYPE';
      case 3:
        return 'GEO_TYPE';
      case 5:
        return 'IMAGE_TYPE';
      case 2:
        return 'PHONE_TYPE';
      case 7:
        return 'SRC_ANCHOR_TYPE';
      case 8:
        return 'SRC_IMAGE_ANCHOR_TYPE';
      case 0:
        return 'UNKNOWN_TYPE';
    }
    return _value.toString();
  }
}
