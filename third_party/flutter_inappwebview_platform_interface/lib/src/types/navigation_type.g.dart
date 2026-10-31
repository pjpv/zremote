
part of 'navigation_type.dart';

class NavigationType {
  final String _value;
  final int? _nativeValue;
  const NavigationType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory NavigationType._internalMultiPlatform(
          String value, Function nativeValue) =>
      NavigationType._internal(value, nativeValue());

  static final BACK_FORWARD =
      NavigationType._internalMultiPlatform('BACK_FORWARD', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 2;
      case TargetPlatform.macOS:
        return 2;
      case TargetPlatform.windows:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final FORM_RESUBMITTED =
      NavigationType._internalMultiPlatform('FORM_RESUBMITTED', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 4;
      case TargetPlatform.macOS:
        return 4;
      default:
        break;
    }
    return null;
  });

  static final FORM_SUBMITTED =
      NavigationType._internalMultiPlatform('FORM_SUBMITTED', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 1;
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final LINK_ACTIVATED =
      NavigationType._internalMultiPlatform('LINK_ACTIVATED', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 0;
      case TargetPlatform.macOS:
        return 0;
      case TargetPlatform.windows:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final OTHER = NavigationType._internalMultiPlatform('OTHER', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return -1;
      case TargetPlatform.macOS:
        return -1;
      case TargetPlatform.windows:
        return 3;
      default:
        break;
    }
    return null;
  });

  static final RELOAD = NavigationType._internalMultiPlatform('RELOAD', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 3;
      case TargetPlatform.macOS:
        return 3;
      case TargetPlatform.windows:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final Set<NavigationType> values = [
    NavigationType.BACK_FORWARD,
    NavigationType.FORM_RESUBMITTED,
    NavigationType.FORM_SUBMITTED,
    NavigationType.LINK_ACTIVATED,
    NavigationType.OTHER,
    NavigationType.RELOAD,
  ].toSet();

  static NavigationType? fromValue(String? value) {
    if (value != null) {
      try {
        return NavigationType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static NavigationType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return NavigationType.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  int? toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}

@Deprecated('Use NavigationType instead')
class IOSWKNavigationType {
  final int _value;
  final int _nativeValue;
  const IOSWKNavigationType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSWKNavigationType._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSWKNavigationType._internal(value, nativeValue());

  static const BACK_FORWARD = IOSWKNavigationType._internal(2, 2);

  static const FORM_RESUBMITTED = IOSWKNavigationType._internal(4, 4);

  static const FORM_SUBMITTED = IOSWKNavigationType._internal(1, 1);

  static const LINK_ACTIVATED = IOSWKNavigationType._internal(0, 0);

  static const OTHER = IOSWKNavigationType._internal(-1, -1);

  static const RELOAD = IOSWKNavigationType._internal(3, 3);

  static final Set<IOSWKNavigationType> values = [
    IOSWKNavigationType.BACK_FORWARD,
    IOSWKNavigationType.FORM_RESUBMITTED,
    IOSWKNavigationType.FORM_SUBMITTED,
    IOSWKNavigationType.LINK_ACTIVATED,
    IOSWKNavigationType.OTHER,
    IOSWKNavigationType.RELOAD,
  ].toSet();

  static IOSWKNavigationType? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSWKNavigationType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSWKNavigationType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSWKNavigationType.values
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
      case 2:
        return 'BACK_FORWARD';
      case 4:
        return 'FORM_RESUBMITTED';
      case 1:
        return 'FORM_SUBMITTED';
      case 0:
        return 'LINK_ACTIVATED';
      case -1:
        return 'OTHER';
      case 3:
        return 'RELOAD';
    }
    return _value.toString();
  }
}
