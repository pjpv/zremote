
part of 'media_capture_state.dart';

class MediaCaptureState {
  final int _value;
  final int _nativeValue;
  const MediaCaptureState._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory MediaCaptureState._internalMultiPlatform(
          int value, Function nativeValue) =>
      MediaCaptureState._internal(value, nativeValue());

  static const ACTIVE = MediaCaptureState._internal(1, 1);

  static const MUTED = MediaCaptureState._internal(2, 2);

  static const NONE = MediaCaptureState._internal(0, 0);

  static final Set<MediaCaptureState> values = [
    MediaCaptureState.ACTIVE,
    MediaCaptureState.MUTED,
    MediaCaptureState.NONE,
  ].toSet();

  static MediaCaptureState? fromValue(int? value) {
    if (value != null) {
      try {
        return MediaCaptureState.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static MediaCaptureState? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return MediaCaptureState.values
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
        return 'ACTIVE';
      case 2:
        return 'MUTED';
      case 0:
        return 'NONE';
    }
    return _value.toString();
  }
}
