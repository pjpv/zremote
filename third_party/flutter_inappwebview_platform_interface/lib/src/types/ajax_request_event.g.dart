
part of 'ajax_request_event.dart';

class AjaxRequestEvent {
  bool? lengthComputable;

  int? loaded;

  int? total;

  AjaxRequestEventType? type;
  AjaxRequestEvent({this.lengthComputable, this.loaded, this.total, this.type});

  static AjaxRequestEvent? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = AjaxRequestEvent(
      lengthComputable: map['lengthComputable'],
      loaded: map['loaded'],
      total: map['total'],
      type: AjaxRequestEventType.fromNativeValue(map['type']),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "lengthComputable": lengthComputable,
      "loaded": loaded,
      "total": total,
      "type": type?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AjaxRequestEvent{lengthComputable: $lengthComputable, loaded: $loaded, total: $total, type: $type}';
  }
}
