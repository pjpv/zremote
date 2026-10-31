import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'modal_presentation_style.g.dart';

@ExchangeableEnum()
class ModalPresentationStyle_ {
  // ignore: unused_field
  final int _value;
  const ModalPresentationStyle_._internal(this._value);

  static const FULL_SCREEN = const ModalPresentationStyle_._internal(0);

  static const PAGE_SHEET = const ModalPresentationStyle_._internal(1);

  static const FORM_SHEET = const ModalPresentationStyle_._internal(2);

  static const CURRENT_CONTEXT = const ModalPresentationStyle_._internal(3);

  static const CUSTOM = const ModalPresentationStyle_._internal(4);

  static const OVER_FULL_SCREEN = const ModalPresentationStyle_._internal(5);

  static const OVER_CURRENT_CONTEXT =
      const ModalPresentationStyle_._internal(6);

  static const POPOVER = const ModalPresentationStyle_._internal(7);

  static const NONE = const ModalPresentationStyle_._internal(8);

  static const AUTOMATIC = const ModalPresentationStyle_._internal(9);
}

@Deprecated("Use ModalPresentationStyle instead")
@ExchangeableEnum()
class IOSUIModalPresentationStyle_ {
  // ignore: unused_field
  final int _value;
  const IOSUIModalPresentationStyle_._internal(this._value);

  static const FULL_SCREEN = const IOSUIModalPresentationStyle_._internal(0);

  static const PAGE_SHEET = const IOSUIModalPresentationStyle_._internal(1);

  static const FORM_SHEET = const IOSUIModalPresentationStyle_._internal(2);

  static const CURRENT_CONTEXT =
      const IOSUIModalPresentationStyle_._internal(3);

  static const CUSTOM = const IOSUIModalPresentationStyle_._internal(4);

  static const OVER_FULL_SCREEN =
      const IOSUIModalPresentationStyle_._internal(5);

  static const OVER_CURRENT_CONTEXT =
      const IOSUIModalPresentationStyle_._internal(6);

  static const POPOVER = const IOSUIModalPresentationStyle_._internal(7);

  static const NONE = const IOSUIModalPresentationStyle_._internal(8);

  static const AUTOMATIC = const IOSUIModalPresentationStyle_._internal(9);
}
