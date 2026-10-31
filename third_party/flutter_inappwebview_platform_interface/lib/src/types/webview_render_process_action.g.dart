
part of 'webview_render_process_action.dart';

class WebViewRenderProcessAction {
  final int _value;
  final int _nativeValue;
  const WebViewRenderProcessAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory WebViewRenderProcessAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      WebViewRenderProcessAction._internal(value, nativeValue());

  static const TERMINATE = WebViewRenderProcessAction._internal(0, 0);

  static final Set<WebViewRenderProcessAction> values = [
    WebViewRenderProcessAction.TERMINATE,
  ].toSet();

  static WebViewRenderProcessAction? fromValue(int? value) {
    if (value != null) {
      try {
        return WebViewRenderProcessAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static WebViewRenderProcessAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return WebViewRenderProcessAction.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 0:
        return 'TERMINATE';
    }
    return _value.toString();
  }
}
