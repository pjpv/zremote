import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'cache_mode.g.dart';

@ExchangeableEnum()
class CacheMode_ {
  // ignore: unused_field
  final int _value;
  const CacheMode_._internal(this._value);

  static const LOAD_DEFAULT = const CacheMode_._internal(-1);

  static const LOAD_CACHE_ELSE_NETWORK = const CacheMode_._internal(1);

  static const LOAD_NO_CACHE = const CacheMode_._internal(2);

  static const LOAD_CACHE_ONLY = const CacheMode_._internal(3);
}

@Deprecated("Use CacheMode instead")
@ExchangeableEnum()
class AndroidCacheMode_ {
  // ignore: unused_field
  final int _value;
  const AndroidCacheMode_._internal(this._value);

  static const LOAD_DEFAULT = const AndroidCacheMode_._internal(-1);

  static const LOAD_CACHE_ELSE_NETWORK = const AndroidCacheMode_._internal(1);

  static const LOAD_NO_CACHE = const AndroidCacheMode_._internal(2);

  static const LOAD_CACHE_ONLY = const AndroidCacheMode_._internal(3);
}
