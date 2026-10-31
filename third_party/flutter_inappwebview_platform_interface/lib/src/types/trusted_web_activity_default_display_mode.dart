import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'trusted_web_activity_display_mode.dart';

part 'trusted_web_activity_default_display_mode.g.dart';

@ExchangeableObject(fromMapFactory: false)
class TrustedWebActivityDefaultDisplayMode_
    implements TrustedWebActivityDisplayMode_ {
  static final _type = "DEFAULT_MODE";

  @ExchangeableObjectMethod(toMapMergeWith: true)
  // ignore: unused_element
  Map<String, dynamic> _toMapMergeWith() {
    return {"type": _type};
  }

  @override
  @ExchangeableObjectMethod(ignore: true)
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
