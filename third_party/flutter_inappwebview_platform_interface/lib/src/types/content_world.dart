final _contentWorldNameRegExp = RegExp(r'[\s]');

class ContentWorld {
  final String name;

  ContentWorld.world({required this.name}) {
    assert(!this.name.startsWith("WINDOW-ID-") &&
        !this.name.contains(_contentWorldNameRegExp));
  }

  static final ContentWorld DEFAULT_CLIENT =
      ContentWorld.world(name: "defaultClient");

  static final ContentWorld PAGE = ContentWorld.world(name: "page");

  Map<String, dynamic> toMap() {
    return {"name": name};
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
