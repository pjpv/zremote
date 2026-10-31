
part of 'user_script.dart';

class UserScript {
  late Set<String> allowedOriginRules;

  late ContentWorld contentWorld;

  bool forMainFrameOnly;

  String? groupName;

  UserScriptInjectionTime injectionTime;

  @Deprecated('Use forMainFrameOnly instead')
  bool? iosForMainFrameOnly;

  String source;
  UserScript(
      {this.groupName,
      required this.source,
      required this.injectionTime,
      @Deprecated("Use forMainFrameOnly instead") this.iosForMainFrameOnly,
      this.forMainFrameOnly = true,
      Set<String>? allowedOriginRules,
      ContentWorld? contentWorld}) {
    this.allowedOriginRules =
        allowedOriginRules != null ? allowedOriginRules : Set.from(["*"]);
    this.contentWorld = contentWorld ?? ContentWorld.PAGE;
    this.forMainFrameOnly = this.iosForMainFrameOnly != null
        ? this.iosForMainFrameOnly!
        : this.forMainFrameOnly;
  }

  static UserScript? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = UserScript(
      groupName: map['groupName'],
      injectionTime:
          UserScriptInjectionTime.fromNativeValue(map['injectionTime'])!,
      iosForMainFrameOnly: map['forMainFrameOnly'],
      source: map['source'],
    );
    instance.allowedOriginRules =
        Set<String>.from(map['allowedOriginRules']!.cast<String>());
    instance.contentWorld = map['contentWorld'];
    instance.forMainFrameOnly = map['forMainFrameOnly'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "allowedOriginRules": allowedOriginRules.toList(),
      "contentWorld": contentWorld.toMap(),
      "forMainFrameOnly": forMainFrameOnly,
      "groupName": groupName,
      "injectionTime": injectionTime.toNativeValue(),
      "source": source,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'UserScript{allowedOriginRules: $allowedOriginRules, contentWorld: $contentWorld, forMainFrameOnly: $forMainFrameOnly, groupName: $groupName, injectionTime: $injectionTime, source: $source}';
  }
}
