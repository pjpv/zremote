
part of 'pull_to_refresh_size.dart';

class PullToRefreshSize {
  final int _value;
  final int _nativeValue;
  const PullToRefreshSize._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PullToRefreshSize._internalMultiPlatform(
          int value, Function nativeValue) =>
      PullToRefreshSize._internal(value, nativeValue());

  static const DEFAULT = PullToRefreshSize._internal(1, 1);

  static const LARGE = PullToRefreshSize._internal(0, 0);

  static final Set<PullToRefreshSize> values = [
    PullToRefreshSize.DEFAULT,
    PullToRefreshSize.LARGE,
  ].toSet();

  static PullToRefreshSize? fromValue(int? value) {
    if (value != null) {
      try {
        return PullToRefreshSize.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PullToRefreshSize? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PullToRefreshSize.values
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
      case 1:
        return 'DEFAULT';
      case 0:
        return 'LARGE';
    }
    return _value.toString();
  }
}

@Deprecated('Use PullToRefreshSize instead')
class AndroidPullToRefreshSize {
  final int _value;
  final int _nativeValue;
  const AndroidPullToRefreshSize._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidPullToRefreshSize._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidPullToRefreshSize._internal(value, nativeValue());

  static const DEFAULT = AndroidPullToRefreshSize._internal(1, 1);

  static const LARGE = AndroidPullToRefreshSize._internal(0, 0);

  static final Set<AndroidPullToRefreshSize> values = [
    AndroidPullToRefreshSize.DEFAULT,
    AndroidPullToRefreshSize.LARGE,
  ].toSet();

  static AndroidPullToRefreshSize? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidPullToRefreshSize.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidPullToRefreshSize? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidPullToRefreshSize.values
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
      case 1:
        return 'DEFAULT';
      case 0:
        return 'LARGE';
    }
    return _value.toString();
  }
}
