
part of 'mixed_content_mode.dart';

class MixedContentMode {
  final int _value;
  final int _nativeValue;
  const MixedContentMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory MixedContentMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      MixedContentMode._internal(value, nativeValue());

  static const MIXED_CONTENT_ALWAYS_ALLOW = MixedContentMode._internal(0, 0);

  static const MIXED_CONTENT_COMPATIBILITY_MODE =
      MixedContentMode._internal(2, 2);

  static const MIXED_CONTENT_NEVER_ALLOW = MixedContentMode._internal(1, 1);

  static final Set<MixedContentMode> values = [
    MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE,
    MixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
  ].toSet();

  static MixedContentMode? fromValue(int? value) {
    if (value != null) {
      try {
        return MixedContentMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static MixedContentMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return MixedContentMode.values
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
      case 0:
        return 'MIXED_CONTENT_ALWAYS_ALLOW';
      case 2:
        return 'MIXED_CONTENT_COMPATIBILITY_MODE';
      case 1:
        return 'MIXED_CONTENT_NEVER_ALLOW';
    }
    return _value.toString();
  }
}

@Deprecated('Use MixedContentMode instead')
class AndroidMixedContentMode {
  final int _value;
  final int _nativeValue;
  const AndroidMixedContentMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidMixedContentMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidMixedContentMode._internal(value, nativeValue());

  static const MIXED_CONTENT_ALWAYS_ALLOW =
      AndroidMixedContentMode._internal(0, 0);

  static const MIXED_CONTENT_COMPATIBILITY_MODE =
      AndroidMixedContentMode._internal(2, 2);

  static const MIXED_CONTENT_NEVER_ALLOW =
      AndroidMixedContentMode._internal(1, 1);

  static final Set<AndroidMixedContentMode> values = [
    AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    AndroidMixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE,
    AndroidMixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
  ].toSet();

  static AndroidMixedContentMode? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidMixedContentMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidMixedContentMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidMixedContentMode.values
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
      case 0:
        return 'MIXED_CONTENT_ALWAYS_ALLOW';
      case 2:
        return 'MIXED_CONTENT_COMPATIBILITY_MODE';
      case 1:
        return 'MIXED_CONTENT_NEVER_ALLOW';
    }
    return _value.toString();
  }
}
