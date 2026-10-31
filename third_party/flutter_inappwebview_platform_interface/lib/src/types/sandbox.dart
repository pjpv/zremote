import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'sandbox.g.dart';

@ExchangeableEnum()
class Sandbox_ {
  final String? _value;
  const Sandbox_._internal(this._value);

  static Sandbox? fromNativeValue(String? value) {
    if (value == null) {
      return Sandbox._ALL;
    } else if (value == "") {
      return Sandbox._NONE;
    }
    try {
      return Sandbox.values
          .firstWhere((element) => element.toNativeValue() == value);
    } catch (e) {
      return null;
    }
  }

  static Sandbox? fromValue(String? value) {
    if (value == null) {
      return Sandbox._ALL;
    } else if (value == "") {
      return Sandbox._NONE;
    }
    try {
      return Sandbox.values.firstWhere((element) => element.toValue() == value);
    } catch (e) {
      return null;
    }
  }

  String? toValue() => _value;

  @override
  String toString() {
    if (_value == null) return 'allow-all';
    if (_value == '') return 'allow-none';
    return _value ?? '';
  }

  static const _ALL = const Sandbox_._internal(null);
  static const _NONE = const Sandbox_._internal("");

  @ExchangeableEnumCustomValue()
  static const ALLOW_ALL = const [_ALL];

  @ExchangeableEnumCustomValue()
  static const ALLOW_NONE = const [_NONE];

  static const ALLOW_DOWNLOADS = const Sandbox_._internal("allow-downloads");

  static const ALLOW_FORMS = const Sandbox_._internal("allow-forms");

  static const ALLOW_MODALS = const Sandbox_._internal("allow-modals");

  static const ALLOW_ORIENTATION_LOCK =
      const Sandbox_._internal("allow-orientation-lock");

  static const ALLOW_POINTER_LOCK =
      const Sandbox_._internal("allow-pointer-lock");

  static const ALLOW_POPUPS = const Sandbox_._internal("allow-popups");

  static const ALLOW_POPUPS_TO_ESCAPE_SANDBOX =
      const Sandbox_._internal("allow-popups-to-escape-sandbox");

  static const ALLOW_PRESENTATION =
      const Sandbox_._internal("allow-presentation");

  static const ALLOW_SAME_ORIGIN =
      const Sandbox_._internal("allow-same-origin");

  static const ALLOW_SCRIPTS = const Sandbox_._internal("allow-scripts");

  static const ALLOW_TOP_NAVIGATION =
      const Sandbox_._internal("allow-top-navigation");

  static const ALLOW_TOP_NAVIGATION_BY_USER_ACTIVATION =
      const Sandbox_._internal("allow-top-navigation-by-user-activation");
}
