import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../content_blocker.dart';

part 'content_blocker_trigger_load_type.g.dart';

@ExchangeableEnum()
class ContentBlockerTriggerLoadType_ {
  // ignore: unused_field
  final String _value;
  const ContentBlockerTriggerLoadType_._internal(this._value);

  static const FIRST_PARTY =
      const ContentBlockerTriggerLoadType_._internal('first-party');

  static const THIRD_PARTY =
      const ContentBlockerTriggerLoadType_._internal('third-party');
}
