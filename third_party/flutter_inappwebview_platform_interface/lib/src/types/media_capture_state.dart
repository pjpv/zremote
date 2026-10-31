import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'media_capture_state.g.dart';

@ExchangeableEnum()
class MediaCaptureState_ {
  // ignore: unused_field
  final int _value;
  const MediaCaptureState_._internal(this._value);

  static const NONE = const MediaCaptureState_._internal(0);

  static const ACTIVE = const MediaCaptureState_._internal(1);

  static const MUTED = const MediaCaptureState_._internal(2);
}
