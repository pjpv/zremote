
part of 'url_request_network_service_type.dart';

class URLRequestNetworkServiceType {
  final int _value;
  final int _nativeValue;
  const URLRequestNetworkServiceType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory URLRequestNetworkServiceType._internalMultiPlatform(
          int value, Function nativeValue) =>
      URLRequestNetworkServiceType._internal(value, nativeValue());

  static const AV_STREAMING = URLRequestNetworkServiceType._internal(8, 8);

  static const BACKGROUND = URLRequestNetworkServiceType._internal(3, 3);

  static const CALL_SIGNALING = URLRequestNetworkServiceType._internal(11, 11);

  static const DEFAULT = URLRequestNetworkServiceType._internal(0, 0);

  static const RESPONSIVE_AV = URLRequestNetworkServiceType._internal(9, 9);

  static const RESPONSIVE_DATA = URLRequestNetworkServiceType._internal(6, 6);

  static const VIDEO = URLRequestNetworkServiceType._internal(2, 2);

  static const VOICE = URLRequestNetworkServiceType._internal(4, 4);

  static final Set<URLRequestNetworkServiceType> values = [
    URLRequestNetworkServiceType.AV_STREAMING,
    URLRequestNetworkServiceType.BACKGROUND,
    URLRequestNetworkServiceType.CALL_SIGNALING,
    URLRequestNetworkServiceType.DEFAULT,
    URLRequestNetworkServiceType.RESPONSIVE_AV,
    URLRequestNetworkServiceType.RESPONSIVE_DATA,
    URLRequestNetworkServiceType.VIDEO,
    URLRequestNetworkServiceType.VOICE,
  ].toSet();

  static URLRequestNetworkServiceType? fromValue(int? value) {
    if (value != null) {
      try {
        return URLRequestNetworkServiceType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static URLRequestNetworkServiceType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return URLRequestNetworkServiceType.values
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
      case 8:
        return 'AV_STREAMING';
      case 3:
        return 'BACKGROUND';
      case 11:
        return 'CALL_SIGNALING';
      case 0:
        return 'DEFAULT';
      case 9:
        return 'RESPONSIVE_AV';
      case 6:
        return 'RESPONSIVE_DATA';
      case 2:
        return 'VIDEO';
      case 4:
        return 'VOICE';
    }
    return _value.toString();
  }
}

@Deprecated('Use URLRequestNetworkServiceType instead')
class IOSURLRequestNetworkServiceType {
  final int _value;
  final int _nativeValue;
  const IOSURLRequestNetworkServiceType._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory IOSURLRequestNetworkServiceType._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSURLRequestNetworkServiceType._internal(value, nativeValue());

  static const AV_STREAMING = IOSURLRequestNetworkServiceType._internal(8, 8);

  static const BACKGROUND = IOSURLRequestNetworkServiceType._internal(3, 3);

  static const CALL_SIGNALING =
      IOSURLRequestNetworkServiceType._internal(11, 11);

  static const DEFAULT = IOSURLRequestNetworkServiceType._internal(0, 0);

  static const RESPONSIVE_AV = IOSURLRequestNetworkServiceType._internal(9, 9);

  static const RESPONSIVE_DATA =
      IOSURLRequestNetworkServiceType._internal(6, 6);

  static const VIDEO = IOSURLRequestNetworkServiceType._internal(2, 2);

  static const VOICE = IOSURLRequestNetworkServiceType._internal(4, 4);

  static final Set<IOSURLRequestNetworkServiceType> values = [
    IOSURLRequestNetworkServiceType.AV_STREAMING,
    IOSURLRequestNetworkServiceType.BACKGROUND,
    IOSURLRequestNetworkServiceType.CALL_SIGNALING,
    IOSURLRequestNetworkServiceType.DEFAULT,
    IOSURLRequestNetworkServiceType.RESPONSIVE_AV,
    IOSURLRequestNetworkServiceType.RESPONSIVE_DATA,
    IOSURLRequestNetworkServiceType.VIDEO,
    IOSURLRequestNetworkServiceType.VOICE,
  ].toSet();

  static IOSURLRequestNetworkServiceType? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSURLRequestNetworkServiceType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSURLRequestNetworkServiceType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSURLRequestNetworkServiceType.values
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
      case 8:
        return 'AV_STREAMING';
      case 3:
        return 'BACKGROUND';
      case 11:
        return 'CALL_SIGNALING';
      case 0:
        return 'DEFAULT';
      case 9:
        return 'RESPONSIVE_AV';
      case 6:
        return 'RESPONSIVE_DATA';
      case 2:
        return 'VIDEO';
      case 4:
        return 'VOICE';
    }
    return _value.toString();
  }
}
