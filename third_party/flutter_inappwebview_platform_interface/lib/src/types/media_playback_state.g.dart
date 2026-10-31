
part of 'media_playback_state.dart';

class MediaPlaybackState {
  final int _value;
  final int _nativeValue;
  const MediaPlaybackState._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory MediaPlaybackState._internalMultiPlatform(
          int value, Function nativeValue) =>
      MediaPlaybackState._internal(value, nativeValue());

  static const NONE = MediaPlaybackState._internal(0, 0);

  static const PAUSED = MediaPlaybackState._internal(2, 2);

  static const PLAYING = MediaPlaybackState._internal(1, 1);

  static const SUSPENDED = MediaPlaybackState._internal(3, 3);

  static final Set<MediaPlaybackState> values = [
    MediaPlaybackState.NONE,
    MediaPlaybackState.PAUSED,
    MediaPlaybackState.PLAYING,
    MediaPlaybackState.SUSPENDED,
  ].toSet();

  static MediaPlaybackState? fromValue(int? value) {
    if (value != null) {
      try {
        return MediaPlaybackState.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static MediaPlaybackState? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return MediaPlaybackState.values
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
        return 'NONE';
      case 2:
        return 'PAUSED';
      case 1:
        return 'PLAYING';
      case 3:
        return 'SUSPENDED';
    }
    return _value.toString();
  }
}
