import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'search_result_display_style.g.dart';

@ExchangeableEnum()
class SearchResultDisplayStyle_ {
  // ignore: unused_field
  final int _value;
  const SearchResultDisplayStyle_._internal(this._value);

  static const CURRENT_AND_TOTAL = const SearchResultDisplayStyle_._internal(0);

  static const TOTAL = const SearchResultDisplayStyle_._internal(1);

  static const NONE = const SearchResultDisplayStyle_._internal(2);
}
