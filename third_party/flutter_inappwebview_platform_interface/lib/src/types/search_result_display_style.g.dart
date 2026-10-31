
part of 'search_result_display_style.dart';

class SearchResultDisplayStyle {
  final int _value;
  final int _nativeValue;
  const SearchResultDisplayStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory SearchResultDisplayStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      SearchResultDisplayStyle._internal(value, nativeValue());

  static const CURRENT_AND_TOTAL = SearchResultDisplayStyle._internal(0, 0);

  static const NONE = SearchResultDisplayStyle._internal(2, 2);

  static const TOTAL = SearchResultDisplayStyle._internal(1, 1);

  static final Set<SearchResultDisplayStyle> values = [
    SearchResultDisplayStyle.CURRENT_AND_TOTAL,
    SearchResultDisplayStyle.NONE,
    SearchResultDisplayStyle.TOTAL,
  ].toSet();

  static SearchResultDisplayStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return SearchResultDisplayStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static SearchResultDisplayStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return SearchResultDisplayStyle.values
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
        return 'CURRENT_AND_TOTAL';
      case 2:
        return 'NONE';
      case 1:
        return 'TOTAL';
    }
    return _value.toString();
  }
}
