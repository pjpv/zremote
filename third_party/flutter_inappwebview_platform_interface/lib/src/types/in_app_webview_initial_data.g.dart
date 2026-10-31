
part of 'in_app_webview_initial_data.dart';

class InAppWebViewInitialData {
  @Deprecated('Use historyUrl instead')
  Uri? androidHistoryUrl;

  WebUri? baseUrl;

  String data;

  String encoding;

  WebUri? historyUrl;

  String mimeType;
  InAppWebViewInitialData(
      {@Deprecated('Use historyUrl instead') this.androidHistoryUrl,
      this.baseUrl,
      required this.data,
      this.encoding = "utf8",
      this.historyUrl,
      this.mimeType = "text/html"}) {
    historyUrl = historyUrl ??
        (androidHistoryUrl != null ? WebUri.uri(androidHistoryUrl!) : null);
  }

  static InAppWebViewInitialData? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = InAppWebViewInitialData(
      androidHistoryUrl:
          map['historyUrl'] != null ? Uri.tryParse(map['historyUrl']) : null,
      baseUrl: map['baseUrl'] != null ? WebUri(map['baseUrl']) : null,
      data: map['data'],
      historyUrl: map['historyUrl'] != null ? WebUri(map['historyUrl']) : null,
    );
    instance.encoding = map['encoding'];
    instance.mimeType = map['mimeType'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "baseUrl": baseUrl?.toString(),
      "data": data,
      "encoding": encoding,
      "historyUrl": historyUrl?.toString(),
      "mimeType": mimeType,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'InAppWebViewInitialData{baseUrl: $baseUrl, data: $data, encoding: $encoding, historyUrl: $historyUrl, mimeType: $mimeType}';
  }
}
