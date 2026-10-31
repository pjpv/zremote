
part of 'geolocation_permission_show_prompt_response.dart';

class GeolocationPermissionShowPromptResponse {
  bool allow;

  String origin;

  bool retain;
  GeolocationPermissionShowPromptResponse(
      {required this.allow, required this.origin, this.retain = false});

  static GeolocationPermissionShowPromptResponse? fromMap(
      Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = GeolocationPermissionShowPromptResponse(
      allow: map['allow'],
      origin: map['origin'],
    );
    instance.retain = map['retain'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "allow": allow,
      "origin": origin,
      "retain": retain,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'GeolocationPermissionShowPromptResponse{allow: $allow, origin: $origin, retain: $retain}';
  }
}
