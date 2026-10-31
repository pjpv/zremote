import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'security_origin.g.dart';

@ExchangeableObject()
class SecurityOrigin_ {
  String host;

  int port;

  String protocol;

  SecurityOrigin_(
      {required this.host, required this.port, required this.protocol});
}

@Deprecated("Use SecurityOrigin instead")
@ExchangeableObject()
class IOSWKSecurityOrigin_ {
  String host;

  int port;

  String protocol;

  IOSWKSecurityOrigin_(
      {required this.host, required this.port, required this.protocol});
}
