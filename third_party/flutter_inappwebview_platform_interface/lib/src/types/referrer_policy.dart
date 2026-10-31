import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'script_html_tag_attributes.dart';
import 'css_link_html_tag_attributes.dart';

part 'referrer_policy.g.dart';

@ExchangeableEnum()
class ReferrerPolicy_ {
  // ignore: unused_field
  final String _value;
  const ReferrerPolicy_._internal(this._value);

  static const NO_REFERRER = const ReferrerPolicy_._internal("no-referrer");

  static const NO_REFERRER_WHEN_DOWNGRADE =
      const ReferrerPolicy_._internal("no-referrer-when-downgrade");

  static const ORIGIN = const ReferrerPolicy_._internal("origin");

  static const ORIGIN_WHEN_CROSS_ORIGIN =
      const ReferrerPolicy_._internal("origin-when-cross-origin");

  static const SAME_ORIGIN = const ReferrerPolicy_._internal("same-origin");

  static const STRICT_ORIGIN = const ReferrerPolicy_._internal("strict-origin");

  static const STRICT_ORIGIN_WHEN_CROSS_ORIGIN =
      const ReferrerPolicy_._internal("strict-origin-when-cross-origin");

  static const UNSAFE_URL = const ReferrerPolicy_._internal("unsafe-url");
}
