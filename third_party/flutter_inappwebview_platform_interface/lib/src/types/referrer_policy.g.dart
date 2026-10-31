
part of 'referrer_policy.dart';

class ReferrerPolicy {
  final String _value;
  final String _nativeValue;
  const ReferrerPolicy._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ReferrerPolicy._internalMultiPlatform(
          String value, Function nativeValue) =>
      ReferrerPolicy._internal(value, nativeValue());

  static const NO_REFERRER =
      ReferrerPolicy._internal('no-referrer', 'no-referrer');

  static const NO_REFERRER_WHEN_DOWNGRADE = ReferrerPolicy._internal(
      'no-referrer-when-downgrade', 'no-referrer-when-downgrade');

  static const ORIGIN = ReferrerPolicy._internal('origin', 'origin');

  static const ORIGIN_WHEN_CROSS_ORIGIN = ReferrerPolicy._internal(
      'origin-when-cross-origin', 'origin-when-cross-origin');

  static const SAME_ORIGIN =
      ReferrerPolicy._internal('same-origin', 'same-origin');

  static const STRICT_ORIGIN =
      ReferrerPolicy._internal('strict-origin', 'strict-origin');

  static const STRICT_ORIGIN_WHEN_CROSS_ORIGIN = ReferrerPolicy._internal(
      'strict-origin-when-cross-origin', 'strict-origin-when-cross-origin');

  static const UNSAFE_URL =
      ReferrerPolicy._internal('unsafe-url', 'unsafe-url');

  static final Set<ReferrerPolicy> values = [
    ReferrerPolicy.NO_REFERRER,
    ReferrerPolicy.NO_REFERRER_WHEN_DOWNGRADE,
    ReferrerPolicy.ORIGIN,
    ReferrerPolicy.ORIGIN_WHEN_CROSS_ORIGIN,
    ReferrerPolicy.SAME_ORIGIN,
    ReferrerPolicy.STRICT_ORIGIN,
    ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN,
    ReferrerPolicy.UNSAFE_URL,
  ].toSet();

  static ReferrerPolicy? fromValue(String? value) {
    if (value != null) {
      try {
        return ReferrerPolicy.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ReferrerPolicy? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return ReferrerPolicy.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
