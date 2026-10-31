import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'url_request_network_service_type.g.dart';

@ExchangeableEnum()
class URLRequestNetworkServiceType_ {
  // ignore: unused_field
  final int _value;
  const URLRequestNetworkServiceType_._internal(this._value);

  static const DEFAULT = const URLRequestNetworkServiceType_._internal(0);

  static const VIDEO = const URLRequestNetworkServiceType_._internal(2);

  static const BACKGROUND = const URLRequestNetworkServiceType_._internal(3);

  static const VOICE = const URLRequestNetworkServiceType_._internal(4);

  static const RESPONSIVE_DATA =
      const URLRequestNetworkServiceType_._internal(6);

  static const AV_STREAMING = const URLRequestNetworkServiceType_._internal(8);

  static const RESPONSIVE_AV = const URLRequestNetworkServiceType_._internal(9);

  static const CALL_SIGNALING =
      const URLRequestNetworkServiceType_._internal(11);
}

@Deprecated("Use URLRequestNetworkServiceType instead")
@ExchangeableEnum()
class IOSURLRequestNetworkServiceType_ {
  // ignore: unused_field
  final int _value;
  const IOSURLRequestNetworkServiceType_._internal(this._value);

  static const DEFAULT = const IOSURLRequestNetworkServiceType_._internal(0);

  static const VIDEO = const IOSURLRequestNetworkServiceType_._internal(2);

  static const BACKGROUND = const IOSURLRequestNetworkServiceType_._internal(3);

  static const VOICE = const IOSURLRequestNetworkServiceType_._internal(4);

  static const RESPONSIVE_DATA =
      const IOSURLRequestNetworkServiceType_._internal(6);

  static const AV_STREAMING =
      const IOSURLRequestNetworkServiceType_._internal(8);

  static const RESPONSIVE_AV =
      const IOSURLRequestNetworkServiceType_._internal(9);

  static const CALL_SIGNALING =
      const IOSURLRequestNetworkServiceType_._internal(11);
}
