import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';
import 'fetch_request_action.dart';
import 'fetch_request_credential.dart';
import 'fetch_request_credential_default.dart';
import 'fetch_request_federated_credential.dart';
import 'fetch_request_password_credential.dart';
import 'referrer_policy.dart';

part 'fetch_request.g.dart';

FetchRequestCredential? _fetchRequestCredentialDeserializer(dynamic value) {
  Map<String, dynamic>? credentialMap = value?.cast<String, dynamic>();
  FetchRequestCredential? credentials;
  if (credentialMap != null) {
    if (credentialMap["type"] == "default") {
      credentials = FetchRequestCredentialDefault.fromMap(credentialMap);
    } else if (credentialMap["type"] == "federated") {
      credentials = FetchRequestFederatedCredential.fromMap(credentialMap);
    } else if (credentialMap["type"] == "password") {
      credentials = FetchRequestPasswordCredential.fromMap(credentialMap);
    }
  }
  return credentials;
}

@ExchangeableObject()
class FetchRequest_ {
  WebUri? url;

  String? method;

  Map<String, dynamic>? headers;

  dynamic body;

  String? mode;

  @ExchangeableObjectProperty(deserializer: _fetchRequestCredentialDeserializer)
  FetchRequestCredential_? credentials;

  String? cache;

  String? redirect;

  String? referrer;

  ReferrerPolicy_? referrerPolicy;

  String? integrity;

  bool? keepalive;

  FetchRequestAction_? action;

  FetchRequest_(
      {this.url,
      this.method,
      this.headers,
      this.body,
      this.mode,
      this.credentials,
      this.cache,
      this.redirect,
      this.referrer,
      this.referrerPolicy,
      this.integrity,
      this.keepalive,
      this.action = FetchRequestAction_.PROCEED});
}
