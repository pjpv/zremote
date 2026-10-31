
part of 'url_response.dart';

class URLResponse {
  int expectedContentLength;

  Map<String, String>? headers;

  String? mimeType;

  int? statusCode;

  String? suggestedFilename;

  String? textEncodingName;

  WebUri? url;
  URLResponse(
      {required this.expectedContentLength,
      this.headers,
      this.mimeType,
      this.statusCode,
      this.suggestedFilename,
      this.textEncodingName,
      this.url});

  static URLResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = URLResponse(
      expectedContentLength: map['expectedContentLength'],
      headers: map['headers']?.cast<String, String>(),
      mimeType: map['mimeType'],
      statusCode: map['statusCode'],
      suggestedFilename: map['suggestedFilename'],
      textEncodingName: map['textEncodingName'],
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "expectedContentLength": expectedContentLength,
      "headers": headers,
      "mimeType": mimeType,
      "statusCode": statusCode,
      "suggestedFilename": suggestedFilename,
      "textEncodingName": textEncodingName,
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'URLResponse{expectedContentLength: $expectedContentLength, headers: $headers, mimeType: $mimeType, statusCode: $statusCode, suggestedFilename: $suggestedFilename, textEncodingName: $textEncodingName, url: $url}';
  }
}

@Deprecated('Use URLResponse instead')
class IOSURLResponse {
  int expectedContentLength;

  Map<String, String>? headers;

  String? mimeType;

  int? statusCode;

  String? suggestedFilename;

  String? textEncodingName;

  Uri? url;
  IOSURLResponse(
      {required this.expectedContentLength,
      this.headers,
      this.mimeType,
      this.statusCode,
      this.suggestedFilename,
      this.textEncodingName,
      this.url});

  static IOSURLResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = IOSURLResponse(
      expectedContentLength: map['expectedContentLength'],
      headers: map['headers']?.cast<String, String>(),
      mimeType: map['mimeType'],
      statusCode: map['statusCode'],
      suggestedFilename: map['suggestedFilename'],
      textEncodingName: map['textEncodingName'],
      url: map['url'] != null ? Uri.tryParse(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "expectedContentLength": expectedContentLength,
      "headers": headers,
      "mimeType": mimeType,
      "statusCode": statusCode,
      "suggestedFilename": suggestedFilename,
      "textEncodingName": textEncodingName,
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'IOSURLResponse{expectedContentLength: $expectedContentLength, headers: $headers, mimeType: $mimeType, statusCode: $statusCode, suggestedFilename: $suggestedFilename, textEncodingName: $textEncodingName, url: $url}';
  }
}
