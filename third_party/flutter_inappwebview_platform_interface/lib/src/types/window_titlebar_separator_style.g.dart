
part of 'window_titlebar_separator_style.dart';

class WindowTitlebarSeparatorStyle {
  final int _value;
  final int? _nativeValue;
  const WindowTitlebarSeparatorStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory WindowTitlebarSeparatorStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      WindowTitlebarSeparatorStyle._internal(value, nativeValue());

  static final AUTOMATIC =
      WindowTitlebarSeparatorStyle._internalMultiPlatform(0, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final LINE =
      WindowTitlebarSeparatorStyle._internalMultiPlatform(2, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final NONE =
      WindowTitlebarSeparatorStyle._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final SHADOW =
      WindowTitlebarSeparatorStyle._internalMultiPlatform(3, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 3;
      default:
        break;
    }
    return null;
  });

  static final Set<WindowTitlebarSeparatorStyle> values = [
    WindowTitlebarSeparatorStyle.AUTOMATIC,
    WindowTitlebarSeparatorStyle.LINE,
    WindowTitlebarSeparatorStyle.NONE,
    WindowTitlebarSeparatorStyle.SHADOW,
  ].toSet();

  static WindowTitlebarSeparatorStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return WindowTitlebarSeparatorStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static WindowTitlebarSeparatorStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return WindowTitlebarSeparatorStyle.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  int? toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 0:
        return 'AUTOMATIC';
      case 2:
        return 'LINE';
      case 1:
        return 'NONE';
      case 3:
        return 'SHADOW';
    }
    return _value.toString();
  }
}
