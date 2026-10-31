import 'types/main.dart';

class ContentBlocker {
  ContentBlockerTrigger trigger;

  ContentBlockerAction action;

  ContentBlocker({required this.trigger, required this.action});

  Map<String, Map<String, dynamic>> toMap() {
    return {"trigger": trigger.toMap(), "action": action.toMap()};
  }

  static ContentBlocker fromMap(Map<dynamic, Map<dynamic, dynamic>> map) {
    return ContentBlocker(
        trigger: ContentBlockerTrigger.fromMap(
            Map<String, dynamic>.from(map["trigger"]!)),
        action: ContentBlockerAction.fromMap(
            Map<String, dynamic>.from(map["action"]!)));
  }

  @override
  String toString() {
    return 'ContentBlocker{trigger: $trigger, action: $action}';
  }
}

class ContentBlockerTrigger {
  String urlFilter;

  List<String> ifFrameUrl;

  bool urlFilterIsCaseSensitive;

  List<ContentBlockerTriggerResourceType> resourceType;

  List<String> ifDomain;

  List<String> unlessDomain;

  List<ContentBlockerTriggerLoadType> loadType;

  List<String> ifTopUrl;

  List<String> unlessTopUrl;

  List<ContentBlockerTriggerLoadContext> loadContext;

  ContentBlockerTrigger(
      {required this.urlFilter,
      this.ifFrameUrl = const <String>[],
      this.urlFilterIsCaseSensitive = false,
      this.resourceType = const <ContentBlockerTriggerResourceType>[],
      this.ifDomain = const <String>[],
      this.unlessDomain = const <String>[],
      this.loadType = const <ContentBlockerTriggerLoadType>[],
      this.ifTopUrl = const <String>[],
      this.unlessTopUrl = const <String>[],
      this.loadContext = const <ContentBlockerTriggerLoadContext>[]}) {
    assert(!(this.ifDomain.isEmpty || this.unlessDomain.isEmpty) == false);
    assert(this.loadType.length <= 2);
    assert(!(this.ifTopUrl.isEmpty || this.unlessTopUrl.isEmpty) == false);
  }

  Map<String, dynamic> toMap() {
    List<String> resourceTypeStringList = [];
    resourceType.forEach((type) {
      resourceTypeStringList.add(type.toNativeValue());
    });
    List<String> loadTypeStringList = [];
    loadType.forEach((type) {
      loadTypeStringList.add(type.toNativeValue());
    });
    List<String> loadContextStringList = [];
    loadContext.forEach((type) {
      loadContextStringList.add(type.toNativeValue());
    });

    Map<String, dynamic> map = {
      "url-filter": urlFilter,
      "if-frame-url": ifFrameUrl,
      "url-filter-is-case-sensitive": urlFilterIsCaseSensitive,
      "if-domain": ifDomain,
      "unless-domain": unlessDomain,
      "resource-type": resourceTypeStringList,
      "load-type": loadTypeStringList,
      "if-top-url": ifTopUrl,
      "unless-top-url": unlessTopUrl,
      "load-context": loadContextStringList
    };

    map.keys
        .where((key) =>
            map[key] == null ||
            (map[key] is List && (map[key] as List).length == 0))
        .toList()
        .forEach(map.remove);

    return map;
  }

  static ContentBlockerTrigger fromMap(Map<String, dynamic> map) {
    List<ContentBlockerTriggerResourceType> resourceType = [];
    List<ContentBlockerTriggerLoadType> loadType = [];
    List<ContentBlockerTriggerLoadContext> loadContext = [];

    List<String> resourceTypeStringList =
        List<String>.from(map["resource-type"] ?? []);
    resourceTypeStringList.forEach((typeValue) {
      var type = ContentBlockerTriggerResourceType.fromNativeValue(typeValue);
      if (type != null) {
        resourceType.add(type);
      }
    });

    List<String> loadTypeStringList = List<String>.from(map["load-type"] ?? []);
    loadTypeStringList.forEach((typeValue) {
      var type = ContentBlockerTriggerLoadType.fromNativeValue(typeValue);
      if (type != null) {
        loadType.add(type);
      }
    });

    List<String> loadContextStringList =
        List<String>.from(map["load-context"] ?? []);
    loadContextStringList.forEach((typeValue) {
      var context = ContentBlockerTriggerLoadContext.fromNativeValue(typeValue);
      if (context != null) {
        loadContext.add(context);
      }
    });

    return ContentBlockerTrigger(
        urlFilter: map["url-filter"],
        ifFrameUrl: List<String>.from(map["if-frame-url"] ?? []),
        urlFilterIsCaseSensitive: map["url-filter-is-case-sensitive"],
        ifDomain: List<String>.from(map["if-domain"] ?? []),
        unlessDomain: List<String>.from(map["unless-domain"] ?? []),
        resourceType: resourceType,
        loadType: loadType,
        ifTopUrl: List<String>.from(map["if-top-url"] ?? []),
        unlessTopUrl: List<String>.from(map["unless-top-url"] ?? []),
        loadContext: loadContext);
  }

  @override
  String toString() {
    return 'ContentBlockerTrigger{urlFilter: $urlFilter, ifFrameUrl: $ifFrameUrl, urlFilterIsCaseSensitive: $urlFilterIsCaseSensitive, resourceType: $resourceType, ifDomain: $ifDomain, unlessDomain: $unlessDomain, loadType: $loadType, ifTopUrl: $ifTopUrl, unlessTopUrl: $unlessTopUrl, loadContext: $loadContext}';
  }
}

class ContentBlockerAction {
  ContentBlockerActionType type;

  String? selector;

  ContentBlockerAction({required this.type, this.selector}) {
    if (this.type == ContentBlockerActionType.CSS_DISPLAY_NONE) {
      assert(this.selector != null);
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "type": type.toNativeValue(),
      "selector": selector
    };

    map.keys
        .where((key) =>
            map[key] == null ||
            (map[key] is List && (map[key] as List).length == 0))
        .toList()
        .forEach(map.remove);

    return map;
  }

  static ContentBlockerAction fromMap(Map<String, dynamic> map) {
    return ContentBlockerAction(
        type: ContentBlockerActionType.fromNativeValue(map["type"])!,
        selector: map["selector"]);
  }

  @override
  String toString() {
    return 'ContentBlockerAction{type: $type, selector: $selector}';
  }
}
