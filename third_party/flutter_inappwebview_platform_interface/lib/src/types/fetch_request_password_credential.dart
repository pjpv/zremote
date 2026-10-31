import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';
import 'fetch_request_credential.dart';

part 'fetch_request_password_credential.g.dart';

@ExchangeableObject()
class FetchRequestPasswordCredential_ extends FetchRequestCredential_ {
  dynamic id;

  String? name;

  String? password;

  WebUri? iconURL;

  FetchRequestPasswordCredential_(
      {type, this.id, this.name, this.password, this.iconURL})
      : super(type: type);
}
