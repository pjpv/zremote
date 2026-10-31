
part of 'window_style_mask.dart';

class WindowStyleMask {
  final int _value;
  final int? _nativeValue;
  const WindowStyleMask._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory WindowStyleMask._internalMultiPlatform(
          int value, Function nativeValue) =>
      WindowStyleMask._internal(value, nativeValue());

  static final BORDERLESS = WindowStyleMask._internalMultiPlatform(0, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final CLOSABLE = WindowStyleMask._internalMultiPlatform(2, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final DOC_MODAL_WINDOW =
      WindowStyleMask._internalMultiPlatform(64, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 64;
      default:
        break;
    }
    return null;
  });

  static final FULLSCREEN = WindowStyleMask._internalMultiPlatform(16384, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 16384;
      default:
        break;
    }
    return null;
  });

  static final FULL_SIZE_CONTENT_VIEW =
      WindowStyleMask._internalMultiPlatform(32768, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 32768;
      default:
        break;
    }
    return null;
  });

  static final HUD_WINDOW = WindowStyleMask._internalMultiPlatform(8192, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 8192;
      default:
        break;
    }
    return null;
  });

  static final MINIATURIZABLE = WindowStyleMask._internalMultiPlatform(4, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 4;
      default:
        break;
    }
    return null;
  });

  static final NONACTIVATING_PANEL =
      WindowStyleMask._internalMultiPlatform(128, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 128;
      default:
        break;
    }
    return null;
  });

  static final RESIZABLE = WindowStyleMask._internalMultiPlatform(8, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 8;
      default:
        break;
    }
    return null;
  });

  static final TITLED = WindowStyleMask._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final UTILITY_WINDOW = WindowStyleMask._internalMultiPlatform(16, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 16;
      default:
        break;
    }
    return null;
  });

  static final Set<WindowStyleMask> values = [
    WindowStyleMask.BORDERLESS,
    WindowStyleMask.CLOSABLE,
    WindowStyleMask.DOC_MODAL_WINDOW,
    WindowStyleMask.FULLSCREEN,
    WindowStyleMask.FULL_SIZE_CONTENT_VIEW,
    WindowStyleMask.HUD_WINDOW,
    WindowStyleMask.MINIATURIZABLE,
    WindowStyleMask.NONACTIVATING_PANEL,
    WindowStyleMask.RESIZABLE,
    WindowStyleMask.TITLED,
    WindowStyleMask.UTILITY_WINDOW,
  ].toSet();

  static WindowStyleMask? fromValue(int? value) {
    if (value != null) {
      try {
        return WindowStyleMask.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return WindowStyleMask._internal(value, value);
      }
    }
    return null;
  }

  static WindowStyleMask? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return WindowStyleMask.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return WindowStyleMask._internal(value, value);
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

  WindowStyleMask operator |(WindowStyleMask value) =>
      WindowStyleMask._internal(
          value.toValue() | _value,
          value.toNativeValue() != null && _nativeValue != null
              ? value.toNativeValue()! | _nativeValue!
              : _nativeValue);
  @override
  String toString() {
    switch (_value) {
      case 0:
        return 'BORDERLESS';
      case 2:
        return 'CLOSABLE';
      case 64:
        return 'DOC_MODAL_WINDOW';
      case 16384:
        return 'FULLSCREEN';
      case 32768:
        return 'FULL_SIZE_CONTENT_VIEW';
      case 8192:
        return 'HUD_WINDOW';
      case 4:
        return 'MINIATURIZABLE';
      case 128:
        return 'NONACTIVATING_PANEL';
      case 8:
        return 'RESIZABLE';
      case 1:
        return 'TITLED';
      case 16:
        return 'UTILITY_WINDOW';
    }
    return _value.toString();
  }
}
