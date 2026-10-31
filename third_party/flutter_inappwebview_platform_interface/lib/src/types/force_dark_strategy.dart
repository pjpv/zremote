import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'force_dark_strategy.g.dart';

@ExchangeableEnum()
class ForceDarkStrategy_ {
  // ignore: unused_field
  final int _value;
  const ForceDarkStrategy_._internal(this._value);

  static const USER_AGENT_DARKENING_ONLY =
      const ForceDarkStrategy_._internal(0);

  static const WEB_THEME_DARKENING_ONLY = const ForceDarkStrategy_._internal(1);

  static const PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING =
      const ForceDarkStrategy_._internal(2);
}
