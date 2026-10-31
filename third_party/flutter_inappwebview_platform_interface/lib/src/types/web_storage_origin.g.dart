
part of 'web_storage_origin.dart';

class WebStorageOrigin {
  String? origin;

  int? quota;

  int? usage;
  WebStorageOrigin({this.origin, this.quota, this.usage});

  static WebStorageOrigin? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebStorageOrigin(
      origin: map['origin'],
      quota: map['quota'],
      usage: map['usage'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "origin": origin,
      "quota": quota,
      "usage": usage,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebStorageOrigin{origin: $origin, quota: $quota, usage: $usage}';
  }
}

@Deprecated('Use WebStorageOrigin instead')
class AndroidWebStorageOrigin {
  String? origin;

  int? quota;

  int? usage;
  AndroidWebStorageOrigin({this.origin, this.quota, this.usage});

  static AndroidWebStorageOrigin? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = AndroidWebStorageOrigin(
      origin: map['origin'],
      quota: map['quota'],
      usage: map['usage'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "origin": origin,
      "quota": quota,
      "usage": usage,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AndroidWebStorageOrigin{origin: $origin, quota: $quota, usage: $usage}';
  }
}
