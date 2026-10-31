import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'context_menu.dart';
import '../util.dart';

part 'context_menu_item.g.dart';

@ExchangeableObject()
class ContextMenuItem_ {
  @Deprecated("Use id instead")
  int? androidId;

  @Deprecated("Use id instead")
  String? iosId;

  dynamic id;

  String title;

  Function()? action;

  @ExchangeableObjectConstructor()
  ContextMenuItem_(
      {this.id,
      @Deprecated("Use id instead") this.androidId,
      @Deprecated("Use id instead") this.iosId,
      required this.title,
      this.action}) {
    if (Util.isAndroid) {
      // ignore: deprecated_member_use_from_same_package
      this.id = this.id ?? this.androidId;
      assert(this.id is int);
    } else if (Util.isIOS) {
      // ignore: deprecated_member_use_from_same_package
      this.id = this.id ?? this.iosId;
    }
    assert(this.id != null && (this.id is int || this.id is String));
  }

  @ExchangeableObjectMethod(toMapMergeWith: true)
  // ignore: unused_element
  Map<String, dynamic> _toMapMergeWith() {
    return {"androidId": androidId, "iosId": iosId};
  }
}
