import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'media_playback_state.g.dart';

@ExchangeableEnum()
class MediaPlaybackState_ {
  // ignore: unused_field
  final int _value;
  const MediaPlaybackState_._internal(this._value);

  static const NONE = const MediaPlaybackState_._internal(0);

  static const PLAYING = const MediaPlaybackState_._internal(1);

  static const PAUSED = const MediaPlaybackState_._internal(2);

  static const SUSPENDED = const MediaPlaybackState_._internal(3);
}
