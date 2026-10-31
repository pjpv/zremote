
part of 'fetch_request.dart';

class FetchRequest {
  FetchRequestAction? action;

  dynamic body;

  String? cache;

  FetchRequestCredential? credentials;

  Map<String, dynamic>? headers;

  String? integrity;

  bool? keepalive;

  String? method;

  String? mode;

  String? redirect;

  String? referrer;

  ReferrerPolicy? referrerPolicy;

  WebUri? url;
  FetchRequest(
      {this.action = FetchRequestAction.PROCEED,
      this.body,
      this.cache,
      this.credentials,
      this.headers,
      this.integrity,
      this.keepalive,
      this.method,
      this.mode,
      this.redirect,
      this.referrer,
      this.referrerPolicy,
      this.url});

  static FetchRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FetchRequest(
      body: map['body'],
      cache: map['cache'],
      credentials: _fetchRequestCredentialDeserializer(map['credentials']),
      headers: map['headers']?.cast<String, dynamic>(),
      integrity: map['integrity'],
      keepalive: map['keepalive'],
      method: map['method'],
      mode: map['mode'],
      redirect: map['redirect'],
      referrer: map['referrer'],
      referrerPolicy: ReferrerPolicy.fromNativeValue(map['referrerPolicy']),
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    instance.action = FetchRequestAction.fromNativeValue(map['action']);
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "body": body,
      "cache": cache,
      "credentials": credentials?.toMap(),
      "headers": headers,
      "integrity": integrity,
      "keepalive": keepalive,
      "method": method,
      "mode": mode,
      "redirect": redirect,
      "referrer": referrer,
      "referrerPolicy": referrerPolicy?.toNativeValue(),
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FetchRequest{action: $action, body: $body, cache: $cache, credentials: $credentials, headers: $headers, integrity: $integrity, keepalive: $keepalive, method: $method, mode: $mode, redirect: $redirect, referrer: $referrer, referrerPolicy: $referrerPolicy, url: $url}';
  }
}
