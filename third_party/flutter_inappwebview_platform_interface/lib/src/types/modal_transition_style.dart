import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'modal_transition_style.g.dart';

@ExchangeableEnum()
class ModalTransitionStyle_ {
  // ignore: unused_field
  final int _value;
  const ModalTransitionStyle_._internal(this._value);

  static const COVER_VERTICAL = const ModalTransitionStyle_._internal(0);

  static const FLIP_HORIZONTAL = const ModalTransitionStyle_._internal(1);

  static const CROSS_DISSOLVE = const ModalTransitionStyle_._internal(2);

  static const PARTIAL_CURL = const ModalTransitionStyle_._internal(3);
}

@Deprecated("Use ModalTransitionStyle instead")
@ExchangeableEnum()
class IOSUIModalTransitionStyle_ {
  // ignore: unused_field
  final int _value;
  const IOSUIModalTransitionStyle_._internal(this._value);

  static const COVER_VERTICAL = const IOSUIModalTransitionStyle_._internal(0);

  static const FLIP_HORIZONTAL = const IOSUIModalTransitionStyle_._internal(1);

  static const CROSS_DISSOLVE = const IOSUIModalTransitionStyle_._internal(2);

  static const PARTIAL_CURL = const IOSUIModalTransitionStyle_._internal(3);
}
