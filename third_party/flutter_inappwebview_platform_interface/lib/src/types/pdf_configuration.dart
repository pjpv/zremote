import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'in_app_webview_rect.dart';

part 'pdf_configuration.g.dart';

@ExchangeableObject()
class PDFConfiguration_ {
  InAppWebViewRect_? rect;

  PDFConfiguration_({this.rect});
}

@Deprecated("Use PDFConfiguration instead")
@ExchangeableObject()
class IOSWKPDFConfiguration_ {
  InAppWebViewRect_? rect;

  IOSWKPDFConfiguration_({this.rect});
}
