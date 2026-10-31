import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'fetch_request.dart';

part 'fetch_request_action.g.dart';

@ExchangeableEnum()
class FetchRequestAction_ {
  // ignore: unused_field
  final int _value;
  const FetchRequestAction_._internal(this._value);

  static const ABORT = const FetchRequestAction_._internal(0);

  static const PROCEED = const FetchRequestAction_._internal(1);
}
