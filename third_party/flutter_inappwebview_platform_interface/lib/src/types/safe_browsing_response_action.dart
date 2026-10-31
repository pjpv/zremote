import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'safe_browsing_response.dart';

part 'safe_browsing_response_action.g.dart';

@ExchangeableEnum()
class SafeBrowsingResponseAction_ {
  // ignore: unused_field
  final int _value;
  const SafeBrowsingResponseAction_._internal(this._value);

  static const BACK_TO_SAFETY = const SafeBrowsingResponseAction_._internal(0);

  static const PROCEED = const SafeBrowsingResponseAction_._internal(1);

  static const SHOW_INTERSTITIAL =
      const SafeBrowsingResponseAction_._internal(2);
}
