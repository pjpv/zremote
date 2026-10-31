
part of 'platform_webview_asset_loader.dart';

class WebViewAssetLoader {
  static final String DEFAULT_DOMAIN = "appassets.androidplatform.net";

  String? domain;

  bool? httpAllowed;

  List<PlatformPathHandler>? pathHandlers;
  WebViewAssetLoader({this.domain, this.httpAllowed, this.pathHandlers});

  static WebViewAssetLoader? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebViewAssetLoader(
      domain: map['domain'],
      httpAllowed: map['httpAllowed'],
      pathHandlers: map['pathHandlers'] != null
          ? List<PlatformPathHandler>.from(map['pathHandlers'].map((e) => e))
          : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "domain": domain,
      "httpAllowed": httpAllowed,
      "pathHandlers": pathHandlers?.map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  WebViewAssetLoader copy() {
    return WebViewAssetLoader.fromMap(toMap()) ?? WebViewAssetLoader();
  }

  @override
  String toString() {
    return 'WebViewAssetLoader{domain: $domain, httpAllowed: $httpAllowed, pathHandlers: $pathHandlers}';
  }
}
