import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'fetch_request.dart';
import 'fetch_request_credential.dart';

part 'fetch_request_credential_default.g.dart';

@ExchangeableObject()
class FetchRequestCredentialDefault_ extends FetchRequestCredential_ {
  String? value;

  FetchRequestCredentialDefault_({type, this.value}) : super(type: type);
}
