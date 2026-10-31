import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';
import 'fetch_request_credential.dart';

part 'fetch_request_federated_credential.g.dart';

@ExchangeableObject()
class FetchRequestFederatedCredential_ extends FetchRequestCredential_ {
  dynamic id;

  String? name;

  String? protocol;

  String? provider;

  WebUri? iconURL;

  FetchRequestFederatedCredential_(
      {type, this.id, this.name, this.protocol, this.provider, this.iconURL})
      : super(type: type);
}
