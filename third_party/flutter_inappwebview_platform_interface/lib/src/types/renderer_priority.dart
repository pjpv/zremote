import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'renderer_priority_policy.dart';

part 'renderer_priority.g.dart';

@ExchangeableEnum()
class RendererPriority_ {
  // ignore: unused_field
  final int _value;
  const RendererPriority_._internal(this._value);

  static const RENDERER_PRIORITY_WAIVED = const RendererPriority_._internal(0);

  static const RENDERER_PRIORITY_BOUND = const RendererPriority_._internal(1);

  static const RENDERER_PRIORITY_IMPORTANT =
      const RendererPriority_._internal(2);
}
