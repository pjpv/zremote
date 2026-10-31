import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'selection_granularity.g.dart';

@ExchangeableEnum()
class SelectionGranularity_ {
  // ignore: unused_field
  final int _value;
  const SelectionGranularity_._internal(this._value);

  static const DYNAMIC = const SelectionGranularity_._internal(0);

  static const CHARACTER = const SelectionGranularity_._internal(1);
}

@Deprecated("Use SelectionGranularity instead")
@ExchangeableEnum()
class IOSWKSelectionGranularity_ {
  // ignore: unused_field
  final int _value;
  const IOSWKSelectionGranularity_._internal(this._value);

  static const DYNAMIC = const IOSWKSelectionGranularity_._internal(0);

  static const CHARACTER = const IOSWKSelectionGranularity_._internal(1);
}
