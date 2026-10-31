import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'web_archive_format.g.dart';

@ExchangeableEnum()
class WebArchiveFormat_ {
  // ignore: unused_field
  final String _value;
  const WebArchiveFormat_._internal(this._value);

  static const MHT = const WebArchiveFormat_._internal("mht");

  static const WEBARCHIVE = const WebArchiveFormat_._internal("webarchive");
}
