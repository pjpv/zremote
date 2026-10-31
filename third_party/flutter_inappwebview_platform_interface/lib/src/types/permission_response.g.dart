
part of 'permission_response.dart';

class PermissionResponse {
  PermissionResponseAction? action;

  List<PermissionResourceType> resources;
  PermissionResponse(
      {this.action = PermissionResponseAction.DENY, this.resources = const []});

  static PermissionResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PermissionResponse();
    instance.action = PermissionResponseAction.fromNativeValue(map['action']);
    instance.resources = List<PermissionResourceType>.from(map['resources']
        .map((e) => PermissionResourceType.fromNativeValue(e)!));
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "resources": resources.map((e) => e.toNativeValue()).toList(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PermissionResponse{action: $action, resources: $resources}';
  }
}

@Deprecated('Use PermissionResponse instead')
class PermissionRequestResponse {
  PermissionRequestResponseAction? action;

  List<String> resources;
  PermissionRequestResponse(
      {this.action = PermissionRequestResponseAction.DENY,
      this.resources = const []});

  static PermissionRequestResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PermissionRequestResponse();
    instance.action =
        PermissionRequestResponseAction.fromNativeValue(map['action']);
    instance.resources = List<String>.from(map['resources']!.cast<String>());
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "resources": resources,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PermissionRequestResponse{action: $action, resources: $resources}';
  }
}
