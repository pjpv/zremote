
part of 'permission_request.dart';

class PermissionRequest {
  FrameInfo? frame;

  WebUri origin;

  List<PermissionResourceType> resources;
  PermissionRequest(
      {this.frame, required this.origin, this.resources = const []});

  static PermissionRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PermissionRequest(
      frame: FrameInfo.fromMap(map['frame']?.cast<String, dynamic>()),
      origin: WebUri(map['origin']),
    );
    instance.resources = List<PermissionResourceType>.from(map['resources']
        .map((e) => PermissionResourceType.fromNativeValue(e)!));
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "frame": frame?.toMap(),
      "origin": origin.toString(),
      "resources": resources.map((e) => e.toNativeValue()).toList(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PermissionRequest{frame: $frame, origin: $origin, resources: $resources}';
  }
}
