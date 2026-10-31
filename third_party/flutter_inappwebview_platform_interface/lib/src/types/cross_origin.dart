import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'script_html_tag_attributes.dart';
import 'css_link_html_tag_attributes.dart';

part 'cross_origin.g.dart';

@ExchangeableEnum()
class CrossOrigin_ {
  // ignore: unused_field
  final String _value;
  const CrossOrigin_._internal(this._value);

  static const ANONYMOUS = const CrossOrigin_._internal("anonymous");

  static const USE_CREDENTIALS =
      const CrossOrigin_._internal("use-credentials");
}
