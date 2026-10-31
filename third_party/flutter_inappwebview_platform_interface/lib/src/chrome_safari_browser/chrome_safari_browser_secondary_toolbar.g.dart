
part of 'chrome_safari_browser_secondary_toolbar.dart';

class ChromeSafariBrowserSecondaryToolbar {
  List<ChromeSafariBrowserSecondaryToolbarClickableID> clickableIDs;

  AndroidResource layout;

  ChromeSafariBrowserSecondaryToolbar(
      {this.clickableIDs = const [], required this.layout});

  static ChromeSafariBrowserSecondaryToolbar? fromMap(
      Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ChromeSafariBrowserSecondaryToolbar(
      layout: AndroidResource.fromMap(map['layout']?.cast<String, dynamic>())!,
    );
    instance.clickableIDs =
        List<ChromeSafariBrowserSecondaryToolbarClickableID>.from(
            map['clickableIDs'].map((e) =>
                ChromeSafariBrowserSecondaryToolbarClickableID.fromMap(
                    e?.cast<String, dynamic>())!));
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "clickableIDs": clickableIDs.map((e) => e.toMap()).toList(),
      "layout": layout.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ChromeSafariBrowserSecondaryToolbar{clickableIDs: $clickableIDs, layout: $layout}';
  }
}

class ChromeSafariBrowserSecondaryToolbarClickableID {
  AndroidResource id;

  void Function(WebUri?)? onClick;

  ChromeSafariBrowserSecondaryToolbarClickableID(
      {required this.id, this.onClick});

  static ChromeSafariBrowserSecondaryToolbarClickableID? fromMap(
      Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ChromeSafariBrowserSecondaryToolbarClickableID(
      id: AndroidResource.fromMap(map['id']?.cast<String, dynamic>())!,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ChromeSafariBrowserSecondaryToolbarClickableID{id: $id}';
  }
}
