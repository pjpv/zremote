
part of 'window_type.dart';

class WindowType {
  final String _value;
  final String _nativeValue;
  const WindowType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory WindowType._internalMultiPlatform(
          String value, Function nativeValue) =>
      WindowType._internal(value, nativeValue());

  static final CHILD = WindowType._internalMultiPlatform('CHILD', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 'CHILD';
      case TargetPlatform.windows:
        return 'CHILD';
      default:
        break;
    }
    return null;
  });

  static final TABBED = WindowType._internalMultiPlatform('TABBED', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 'TABBED';
      default:
        break;
    }
    return null;
  });

  static final WINDOW = WindowType._internalMultiPlatform('WINDOW', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 'WINDOW';
      case TargetPlatform.windows:
        return 'WINDOW';
      default:
        break;
    }
    return null;
  });

  static final Set<WindowType> values = [
    WindowType.CHILD,
    WindowType.TABBED,
    WindowType.WINDOW,
  ].toSet();

  static WindowType? fromValue(String? value) {
    if (value != null) {
      try {
        return WindowType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static WindowType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return WindowType.values
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
