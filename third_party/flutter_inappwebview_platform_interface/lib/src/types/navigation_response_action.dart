import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
part 'navigation_response_action.g.dart';

@ExchangeableEnum()
class NavigationResponseAction_ {
  // ignore: unused_field
  final int _value;
  const NavigationResponseAction_._internal(this._value);

  static const CANCEL = const NavigationResponseAction_._internal(0);

  static const ALLOW = const NavigationResponseAction_._internal(1);

  static const DOWNLOAD = const NavigationResponseAction_._internal(2);
}

@Deprecated("Use NavigationResponseAction instead")
@ExchangeableEnum()
class IOSNavigationResponseAction_ {
  // ignore: unused_field
  final int _value;
  const IOSNavigationResponseAction_._internal(this._value);

  static const CANCEL = const IOSNavigationResponseAction_._internal(0);

  static const ALLOW = const IOSNavigationResponseAction_._internal(1);
}
