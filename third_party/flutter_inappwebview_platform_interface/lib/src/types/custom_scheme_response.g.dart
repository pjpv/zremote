
part of 'custom_scheme_response.dart';

class CustomSchemeResponse {
  String contentEncoding;

  String contentType;

  Uint8List data;
  CustomSchemeResponse(
      {this.contentEncoding = 'utf-8',
      required this.contentType,
      required this.data});

  static CustomSchemeResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = CustomSchemeResponse(
      contentType: map['contentType'],
      data: Uint8List.fromList(map['data'].cast<int>()),
    );
    instance.contentEncoding = map['contentEncoding'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "contentEncoding": contentEncoding,
      "contentType": contentType,
      "data": data,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CustomSchemeResponse{contentEncoding: $contentEncoding, contentType: $contentType, data: $data}';
  }
}
