import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'website_data_type.dart';

part 'website_data_record.g.dart';

@ExchangeableObject()
class WebsiteDataRecord_ {
  String? displayName;

  Set<WebsiteDataType_>? dataTypes;

  WebsiteDataRecord_({this.displayName, this.dataTypes});
}

@Deprecated("Use WebsiteDataRecord instead")
@ExchangeableObject()
class IOSWKWebsiteDataRecord_ {
  String? displayName;

  Set<IOSWKWebsiteDataType_>? dataTypes;

  IOSWKWebsiteDataRecord_({this.displayName, this.dataTypes});
}
