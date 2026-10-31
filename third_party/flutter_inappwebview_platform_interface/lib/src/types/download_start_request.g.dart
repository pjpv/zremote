
part of 'download_start_request.dart';

class DownloadStartRequest {
  String? contentDisposition;

  int contentLength;

  String? mimeType;

  String? suggestedFilename;

  String? textEncodingName;

  WebUri url;

  String? userAgent;
  DownloadStartRequest(
      {this.contentDisposition,
      required this.contentLength,
      this.mimeType,
      this.suggestedFilename,
      this.textEncodingName,
      required this.url,
      this.userAgent});

  static DownloadStartRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = DownloadStartRequest(
      contentDisposition: map['contentDisposition'],
      contentLength: map['contentLength'],
      mimeType: map['mimeType'],
      suggestedFilename: map['suggestedFilename'],
      textEncodingName: map['textEncodingName'],
      url: WebUri(map['url']),
      userAgent: map['userAgent'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "contentDisposition": contentDisposition,
      "contentLength": contentLength,
      "mimeType": mimeType,
      "suggestedFilename": suggestedFilename,
      "textEncodingName": textEncodingName,
      "url": url.toString(),
      "userAgent": userAgent,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'DownloadStartRequest{contentDisposition: $contentDisposition, contentLength: $contentLength, mimeType: $mimeType, suggestedFilename: $suggestedFilename, textEncodingName: $textEncodingName, url: $url, userAgent: $userAgent}';
  }
}
