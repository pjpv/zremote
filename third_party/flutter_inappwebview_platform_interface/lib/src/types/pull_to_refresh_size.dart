import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'pull_to_refresh_size.g.dart';

@ExchangeableEnum()
class PullToRefreshSize_ {
  // ignore: unused_field
  final int _value;
  const PullToRefreshSize_._internal(this._value);

  static const DEFAULT = const PullToRefreshSize_._internal(1);

  static const LARGE = const PullToRefreshSize_._internal(0);
}

@Deprecated("Use PullToRefreshSize instead")
@ExchangeableEnum()
class AndroidPullToRefreshSize_ {
  // ignore: unused_field
  final int _value;
  const AndroidPullToRefreshSize_._internal(this._value);

  static const DEFAULT = const AndroidPullToRefreshSize_._internal(1);

  static const LARGE = const AndroidPullToRefreshSize_._internal(0);
}
