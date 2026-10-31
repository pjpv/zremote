import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';

part 'ui_event_attribution.g.dart';

@ExchangeableObject()
class UIEventAttribution_ {
  int sourceIdentifier;

  WebUri destinationURL;

  String sourceDescription;

  String purchaser;

  @ExchangeableObjectConstructor()
  UIEventAttribution_(
      {required this.sourceIdentifier,
      required this.destinationURL,
      required this.sourceDescription,
      required this.purchaser});
}
