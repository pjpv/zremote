
part of 'sandbox.dart';

class Sandbox {
  final String? _value;
  final String? _nativeValue;
  const Sandbox._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory Sandbox._internalMultiPlatform(String? value, Function nativeValue) =>
      Sandbox._internal(value, nativeValue());

  static const ALLOW_ALL = const [_ALL];

  static const ALLOW_DOWNLOADS =
      Sandbox._internal('allow-downloads', 'allow-downloads');

  static const ALLOW_FORMS = Sandbox._internal('allow-forms', 'allow-forms');

  static const ALLOW_MODALS = Sandbox._internal('allow-modals', 'allow-modals');

  static const ALLOW_NONE = const [_NONE];

  static const ALLOW_ORIENTATION_LOCK =
      Sandbox._internal('allow-orientation-lock', 'allow-orientation-lock');

  static const ALLOW_POINTER_LOCK =
      Sandbox._internal('allow-pointer-lock', 'allow-pointer-lock');

  static const ALLOW_POPUPS = Sandbox._internal('allow-popups', 'allow-popups');

  static const ALLOW_POPUPS_TO_ESCAPE_SANDBOX = Sandbox._internal(
      'allow-popups-to-escape-sandbox', 'allow-popups-to-escape-sandbox');

  static const ALLOW_PRESENTATION =
      Sandbox._internal('allow-presentation', 'allow-presentation');

  static const ALLOW_SAME_ORIGIN =
      Sandbox._internal('allow-same-origin', 'allow-same-origin');

  static const ALLOW_SCRIPTS =
      Sandbox._internal('allow-scripts', 'allow-scripts');

  static const ALLOW_TOP_NAVIGATION =
      Sandbox._internal('allow-top-navigation', 'allow-top-navigation');

  static const ALLOW_TOP_NAVIGATION_BY_USER_ACTIVATION = Sandbox._internal(
      'allow-top-navigation-by-user-activation',
      'allow-top-navigation-by-user-activation');
  static const _ALL = Sandbox._internal(null, null);
  static const _NONE = Sandbox._internal('', '');

  static final Set<Sandbox> values = [
    Sandbox.ALLOW_DOWNLOADS,
    Sandbox.ALLOW_FORMS,
    Sandbox.ALLOW_MODALS,
    Sandbox.ALLOW_ORIENTATION_LOCK,
    Sandbox.ALLOW_POINTER_LOCK,
    Sandbox.ALLOW_POPUPS,
    Sandbox.ALLOW_POPUPS_TO_ESCAPE_SANDBOX,
    Sandbox.ALLOW_PRESENTATION,
    Sandbox.ALLOW_SAME_ORIGIN,
    Sandbox.ALLOW_SCRIPTS,
    Sandbox.ALLOW_TOP_NAVIGATION,
    Sandbox.ALLOW_TOP_NAVIGATION_BY_USER_ACTIVATION,
  ].toSet();

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

  String? toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;
}
