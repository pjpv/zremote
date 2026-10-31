import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'ajax_request.dart';
import 'ajax_request_event_type.dart';

part 'ajax_request_event.g.dart';

@ExchangeableObject()
class AjaxRequestEvent_ {
  AjaxRequestEventType_? type;

  bool? lengthComputable;

  int? loaded;

  int? total;

  AjaxRequestEvent_(
      {this.type, this.lengthComputable, this.loaded, this.total});
}
