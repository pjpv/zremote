
part of 'web_resource_response.dart';

class WebResourceResponse {
  String? contentEncoding;

  String? contentType;

  Uint8List? data;

  Map<String, String>? headers;

  String? reasonPhrase;

  int? statusCode;
  WebResourceResponse(
      {this.contentEncoding = "utf-8",
      this.contentType = "",
      this.data,
      this.headers,
      this.reasonPhrase,
      this.statusCode});

  static WebResourceResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebResourceResponse(
      data: map['data'] != null
          ? Uint8List.fromList(map['data'].cast<int>())
          : null,
      headers: map['headers']?.cast<String, String>(),
      reasonPhrase: map['reasonPhrase'],
      statusCode: map['statusCode'],
    );
    instance.contentEncoding = map['contentEncoding'];
    instance.contentType = map['contentType'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "contentEncoding": contentEncoding,
      "contentType": contentType,
      "data": data,
      "headers": headers,
      "reasonPhrase": reasonPhrase,
      "statusCode": statusCode,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebResourceResponse{contentEncoding: $contentEncoding, contentType: $contentType, data: $data, headers: $headers, reasonPhrase: $reasonPhrase, statusCode: $statusCode}';
  }
}
