
part of 'renderer_priority.dart';

class RendererPriority {
  final int _value;
  final int _nativeValue;
  const RendererPriority._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory RendererPriority._internalMultiPlatform(
          int value, Function nativeValue) =>
      RendererPriority._internal(value, nativeValue());

  static const RENDERER_PRIORITY_BOUND = RendererPriority._internal(1, 1);

  static const RENDERER_PRIORITY_IMPORTANT = RendererPriority._internal(2, 2);

  static const RENDERER_PRIORITY_WAIVED = RendererPriority._internal(0, 0);

  static final Set<RendererPriority> values = [
    RendererPriority.RENDERER_PRIORITY_BOUND,
    RendererPriority.RENDERER_PRIORITY_IMPORTANT,
    RendererPriority.RENDERER_PRIORITY_WAIVED,
  ].toSet();

  static RendererPriority? fromValue(int? value) {
    if (value != null) {
      try {
        return RendererPriority.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static RendererPriority? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return RendererPriority.values
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
        return 'RENDERER_PRIORITY_BOUND';
      case 2:
        return 'RENDERER_PRIORITY_IMPORTANT';
      case 0:
        return 'RENDERER_PRIORITY_WAIVED';
    }
    return _value.toString();
  }
}
