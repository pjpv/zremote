import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/in_app_webview_settings.dart';

part 'layout_algorithm.g.dart';

@ExchangeableEnum()
class LayoutAlgorithm_ {
  // ignore: unused_field
  final String _value;
  const LayoutAlgorithm_._internal(this._value);

  static const NORMAL = const LayoutAlgorithm_._internal("NORMAL");

  static const TEXT_AUTOSIZING =
      const LayoutAlgorithm_._internal("TEXT_AUTOSIZING");

  static const NARROW_COLUMNS =
      const LayoutAlgorithm_._internal("NARROW_COLUMNS");
}

@Deprecated("Use LayoutAlgorithm instead")
@ExchangeableEnum()
class AndroidLayoutAlgorithm_ {
  // ignore: unused_field
  final String _value;
  const AndroidLayoutAlgorithm_._internal(this._value);

  static const NORMAL = const AndroidLayoutAlgorithm_._internal("NORMAL");

  static const TEXT_AUTOSIZING =
      const AndroidLayoutAlgorithm_._internal("TEXT_AUTOSIZING");

  static const NARROW_COLUMNS =
      const AndroidLayoutAlgorithm_._internal("NARROW_COLUMNS");
}
