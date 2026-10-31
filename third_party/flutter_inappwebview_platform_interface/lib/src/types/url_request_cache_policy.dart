import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'url_request_cache_policy.g.dart';

@ExchangeableEnum()
class URLRequestCachePolicy_ {
  // ignore: unused_field
  final int _value;
  const URLRequestCachePolicy_._internal(this._value);

  static const USE_PROTOCOL_CACHE_POLICY =
      const URLRequestCachePolicy_._internal(0);

  static const RELOAD_IGNORING_LOCAL_CACHE_DATA =
      const URLRequestCachePolicy_._internal(1);

  static const RETURN_CACHE_DATA_ELSE_LOAD =
      const URLRequestCachePolicy_._internal(2);

  static const RETURN_CACHE_DATA_DONT_LOAD =
      const URLRequestCachePolicy_._internal(3);

  static const RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA =
      const URLRequestCachePolicy_._internal(4);

  static const RELOAD_REVALIDATING_CACHE_DATA =
      const URLRequestCachePolicy_._internal(5);
}

@Deprecated("Use URLRequestCachePolicy instead")
@ExchangeableEnum()
class IOSURLRequestCachePolicy_ {
  // ignore: unused_field
  final int _value;
  const IOSURLRequestCachePolicy_._internal(this._value);

  static const USE_PROTOCOL_CACHE_POLICY =
      const IOSURLRequestCachePolicy_._internal(0);

  static const RELOAD_IGNORING_LOCAL_CACHE_DATA =
      const IOSURLRequestCachePolicy_._internal(1);

  static const RETURN_CACHE_DATA_ELSE_LOAD =
      const IOSURLRequestCachePolicy_._internal(2);

  static const RETURN_CACHE_DATA_DONT_LOAD =
      const IOSURLRequestCachePolicy_._internal(3);

  static const RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA =
      const IOSURLRequestCachePolicy_._internal(4);

  static const RELOAD_REVALIDATING_CACHE_DATA =
      const IOSURLRequestCachePolicy_._internal(5);
}
