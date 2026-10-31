import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'fetch_request_credential_default.dart';
import 'fetch_request_federated_credential.dart';
import 'fetch_request_password_credential.dart';

part 'fetch_request_credential.g.dart';

@ExchangeableObject()
class FetchRequestCredential_ {
  String? type;

  FetchRequestCredential_({this.type});
}
