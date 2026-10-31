
part of 'script_html_tag_attributes.dart';

class ScriptHtmlTagAttributes {
  bool? async;

  CrossOrigin? crossOrigin;

  bool? defer;

  String? id;

  String? integrity;

  bool? noModule;

  String? nonce;

  Function? onError;

  Function? onLoad;

  ReferrerPolicy? referrerPolicy;

  String type;
  ScriptHtmlTagAttributes(
      {this.type = "text/javascript",
      this.id,
      this.async,
      this.defer,
      this.crossOrigin,
      this.integrity,
      this.noModule,
      this.nonce,
      this.referrerPolicy,
      this.onLoad,
      this.onError}) {
    if (this.onLoad != null || this.onError != null) {
      assert(this.id != null,
          'onLoad and onError callbacks require the id property to be set.');
    }
  }

  static ScriptHtmlTagAttributes? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ScriptHtmlTagAttributes(
      async: map['async'],
      crossOrigin: CrossOrigin.fromNativeValue(map['crossOrigin']),
      defer: map['defer'],
      id: map['id'],
      integrity: map['integrity'],
      noModule: map['noModule'],
      nonce: map['nonce'],
      referrerPolicy: ReferrerPolicy.fromNativeValue(map['referrerPolicy']),
    );
    instance.type = map['type'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "async": async,
      "crossOrigin": crossOrigin?.toNativeValue(),
      "defer": defer,
      "id": id,
      "integrity": integrity,
      "noModule": noModule,
      "nonce": nonce,
      "referrerPolicy": referrerPolicy?.toNativeValue(),
      "type": type,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ScriptHtmlTagAttributes{async: $async, crossOrigin: $crossOrigin, defer: $defer, id: $id, integrity: $integrity, noModule: $noModule, nonce: $nonce, referrerPolicy: $referrerPolicy, type: $type}';
  }
}
