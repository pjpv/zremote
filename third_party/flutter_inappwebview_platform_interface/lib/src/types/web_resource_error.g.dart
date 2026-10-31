
part of 'web_resource_error.dart';

class WebResourceError {
  String description;

  WebResourceErrorType type;
  WebResourceError({required this.description, required this.type});

  static WebResourceError? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebResourceError(
      description: map['description'],
      type: WebResourceErrorType.fromNativeValue(map['type'])!,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "type": type.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebResourceError{description: $description, type: $type}';
  }
}
