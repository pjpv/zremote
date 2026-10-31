import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
part 'navigation_action_policy.g.dart';

@ExchangeableEnum()
class NavigationActionPolicy_ {
  // ignore: unused_field
  final int _value;
  const NavigationActionPolicy_._internal(this._value);

  static const CANCEL = const NavigationActionPolicy_._internal(0);

  static const ALLOW = const NavigationActionPolicy_._internal(1);

  static const DOWNLOAD = const NavigationActionPolicy_._internal(2);
}
