
part of 'pdf_configuration.dart';

class PDFConfiguration {
  InAppWebViewRect? rect;
  PDFConfiguration({this.rect});

  static PDFConfiguration? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PDFConfiguration(
      rect: InAppWebViewRect.fromMap(map['rect']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "rect": rect?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PDFConfiguration{rect: $rect}';
  }
}

@Deprecated('Use PDFConfiguration instead')
class IOSWKPDFConfiguration {
  InAppWebViewRect? rect;
  IOSWKPDFConfiguration({this.rect});

  static IOSWKPDFConfiguration? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = IOSWKPDFConfiguration(
      rect: InAppWebViewRect.fromMap(map['rect']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "rect": rect?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'IOSWKPDFConfiguration{rect: $rect}';
  }
}
