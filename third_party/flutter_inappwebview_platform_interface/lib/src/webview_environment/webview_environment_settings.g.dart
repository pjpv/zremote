
part of 'webview_environment_settings.dart';

class WebViewEnvironmentSettings {
  final String? additionalBrowserArguments;

  final bool? allowSingleSignOnUsingOSPrimaryAccount;

  final String? browserExecutableFolder;

  final List<CustomSchemeRegistration>? customSchemeRegistrations;

  final String? language;

  final String? targetCompatibleBrowserVersion;

  final String? userDataFolder;

  WebViewEnvironmentSettings(
      {this.additionalBrowserArguments,
      this.allowSingleSignOnUsingOSPrimaryAccount,
      this.browserExecutableFolder,
      this.customSchemeRegistrations,
      this.language,
      this.targetCompatibleBrowserVersion,
      this.userDataFolder});

  static WebViewEnvironmentSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebViewEnvironmentSettings(
      additionalBrowserArguments: map['additionalBrowserArguments'],
      allowSingleSignOnUsingOSPrimaryAccount:
          map['allowSingleSignOnUsingOSPrimaryAccount'],
      browserExecutableFolder: map['browserExecutableFolder'],
      customSchemeRegistrations: map['customSchemeRegistrations'] != null
          ? List<CustomSchemeRegistration>.from(map['customSchemeRegistrations']
              .map((e) => CustomSchemeRegistration.fromMap(
                  e?.cast<String, dynamic>())!))
          : null,
      language: map['language'],
      targetCompatibleBrowserVersion: map['targetCompatibleBrowserVersion'],
      userDataFolder: map['userDataFolder'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "additionalBrowserArguments": additionalBrowserArguments,
      "allowSingleSignOnUsingOSPrimaryAccount":
          allowSingleSignOnUsingOSPrimaryAccount,
      "browserExecutableFolder": browserExecutableFolder,
      "customSchemeRegistrations":
          customSchemeRegistrations?.map((e) => e.toMap()).toList(),
      "language": language,
      "targetCompatibleBrowserVersion": targetCompatibleBrowserVersion,
      "userDataFolder": userDataFolder,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  WebViewEnvironmentSettings copy() {
    return WebViewEnvironmentSettings.fromMap(toMap()) ??
        WebViewEnvironmentSettings();
  }

  @override
  String toString() {
    return 'WebViewEnvironmentSettings{additionalBrowserArguments: $additionalBrowserArguments, allowSingleSignOnUsingOSPrimaryAccount: $allowSingleSignOnUsingOSPrimaryAccount, browserExecutableFolder: $browserExecutableFolder, customSchemeRegistrations: $customSchemeRegistrations, language: $language, targetCompatibleBrowserVersion: $targetCompatibleBrowserVersion, userDataFolder: $userDataFolder}';
  }
}
