
part of 'website_data_record.dart';

class WebsiteDataRecord {
  Set<WebsiteDataType>? dataTypes;

  String? displayName;
  WebsiteDataRecord({this.dataTypes, this.displayName});

  static WebsiteDataRecord? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebsiteDataRecord(
      dataTypes: map['dataTypes'] != null
          ? Set<WebsiteDataType>.from(
              map['dataTypes'].map((e) => WebsiteDataType.fromNativeValue(e)!))
          : null,
      displayName: map['displayName'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "dataTypes": dataTypes?.map((e) => e.toNativeValue()).toList(),
      "displayName": displayName,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebsiteDataRecord{dataTypes: $dataTypes, displayName: $displayName}';
  }
}

@Deprecated('Use WebsiteDataRecord instead')
class IOSWKWebsiteDataRecord {
  Set<IOSWKWebsiteDataType>? dataTypes;

  String? displayName;
  IOSWKWebsiteDataRecord({this.dataTypes, this.displayName});

  static IOSWKWebsiteDataRecord? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = IOSWKWebsiteDataRecord(
      dataTypes: map['dataTypes'] != null
          ? Set<IOSWKWebsiteDataType>.from(map['dataTypes']
              .map((e) => IOSWKWebsiteDataType.fromNativeValue(e)!))
          : null,
      displayName: map['displayName'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "dataTypes": dataTypes?.map((e) => e.toNativeValue()).toList(),
      "displayName": displayName,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'IOSWKWebsiteDataRecord{dataTypes: $dataTypes, displayName: $displayName}';
  }
}
