
part of 'safe_browsing_response.dart';

class SafeBrowsingResponse {
  SafeBrowsingResponseAction? action;

  bool report;
  SafeBrowsingResponse(
      {this.action = SafeBrowsingResponseAction.SHOW_INTERSTITIAL,
      this.report = true});

  static SafeBrowsingResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = SafeBrowsingResponse();
    instance.action = SafeBrowsingResponseAction.fromNativeValue(map['action']);
    instance.report = map['report'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "report": report,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'SafeBrowsingResponse{action: $action, report: $report}';
  }
}
