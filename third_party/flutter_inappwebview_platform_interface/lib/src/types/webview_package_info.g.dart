
part of 'webview_package_info.dart';

class WebViewPackageInfo {
  String? packageName;

  String? versionName;
  WebViewPackageInfo({this.packageName, this.versionName});

  static WebViewPackageInfo? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebViewPackageInfo(
      packageName: map['packageName'],
      versionName: map['versionName'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "packageName": packageName,
      "versionName": versionName,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebViewPackageInfo{packageName: $packageName, versionName: $versionName}';
  }
}

@Deprecated('Use WebViewPackageInfo instead')
class AndroidWebViewPackageInfo {
  String? packageName;

  String? versionName;
  AndroidWebViewPackageInfo({this.packageName, this.versionName});

  static AndroidWebViewPackageInfo? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = AndroidWebViewPackageInfo(
      packageName: map['packageName'],
      versionName: map['versionName'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "packageName": packageName,
      "versionName": versionName,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AndroidWebViewPackageInfo{packageName: $packageName, versionName: $versionName}';
  }
}
