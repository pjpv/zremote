import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'server_trust_auth_response.dart';

part 'server_trust_auth_response_action.g.dart';

@ExchangeableEnum()
class ServerTrustAuthResponseAction_ {
  // ignore: unused_field
  final int _value;
  const ServerTrustAuthResponseAction_._internal(this._value);

  static const CANCEL = const ServerTrustAuthResponseAction_._internal(0);

  static const PROCEED = const ServerTrustAuthResponseAction_._internal(1);
}
