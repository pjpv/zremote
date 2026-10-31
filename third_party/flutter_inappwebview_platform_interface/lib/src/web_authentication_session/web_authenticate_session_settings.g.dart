
part of 'web_authenticate_session_settings.dart';

class WebAuthenticationSessionSettings {
  bool? prefersEphemeralWebBrowserSession;
  WebAuthenticationSessionSettings(
      {this.prefersEphemeralWebBrowserSession = false});

  static WebAuthenticationSessionSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebAuthenticationSessionSettings();
    instance.prefersEphemeralWebBrowserSession =
        map['prefersEphemeralWebBrowserSession'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "prefersEphemeralWebBrowserSession": prefersEphemeralWebBrowserSession
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  WebAuthenticationSessionSettings copy() {
    return WebAuthenticationSessionSettings.fromMap(toMap()) ??
        WebAuthenticationSessionSettings();
  }

  @override
  String toString() {
    return 'WebAuthenticationSessionSettings{prefersEphemeralWebBrowserSession: $prefersEphemeralWebBrowserSession}';
  }
}
