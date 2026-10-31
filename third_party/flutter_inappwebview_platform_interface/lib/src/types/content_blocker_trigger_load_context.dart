import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../content_blocker.dart';

part 'content_blocker_trigger_load_context.g.dart';

@ExchangeableEnum()
class ContentBlockerTriggerLoadContext_ {
  // ignore: unused_field
  final String _value;

  const ContentBlockerTriggerLoadContext_._internal(this._value);

  static const TOP_FRAME =
      const ContentBlockerTriggerLoadContext_._internal('top-frame');

  static const CHILD_FRAME =
      const ContentBlockerTriggerLoadContext_._internal('child-frame');
}
