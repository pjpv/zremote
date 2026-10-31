import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'client_cert_response.dart';

part 'client_cert_response_action.g.dart';

@ExchangeableEnum()
class ClientCertResponseAction_ {
  // ignore: unused_field
  final int _value;
  const ClientCertResponseAction_._internal(this._value);

  static const CANCEL = const ClientCertResponseAction_._internal(0);

  static const PROCEED = const ClientCertResponseAction_._internal(1);

  static const IGNORE = const ClientCertResponseAction_._internal(2);
}
