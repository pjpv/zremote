
part of 'platform_proxy_controller.dart';

class ProxySettings {
  List<String> bypassRules;

  bool? bypassSimpleHostnames;

  List<String> directs;

  List<ProxyRule> proxyRules;

  bool? removeImplicitRules;

  bool reverseBypassEnabled;
  ProxySettings(
      {this.bypassRules = const [],
      this.bypassSimpleHostnames,
      this.directs = const [],
      this.proxyRules = const [],
      this.removeImplicitRules,
      this.reverseBypassEnabled = false});

  static ProxySettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ProxySettings(
      bypassSimpleHostnames: map['bypassSimpleHostnames'],
      removeImplicitRules: map['removeImplicitRules'],
    );
    instance.bypassRules =
        List<String>.from(map['bypassRules']!.cast<String>());
    instance.directs = List<String>.from(map['directs']!.cast<String>());
    instance.proxyRules = List<ProxyRule>.from(map['proxyRules']
        .map((e) => ProxyRule.fromMap(e?.cast<String, dynamic>())!));
    instance.reverseBypassEnabled = map['reverseBypassEnabled'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "bypassRules": bypassRules,
      "bypassSimpleHostnames": bypassSimpleHostnames,
      "directs": directs,
      "proxyRules": proxyRules.map((e) => e.toMap()).toList(),
      "removeImplicitRules": removeImplicitRules,
      "reverseBypassEnabled": reverseBypassEnabled,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  ProxySettings copy() {
    return ProxySettings.fromMap(toMap()) ?? ProxySettings();
  }

  @override
  String toString() {
    return 'ProxySettings{bypassRules: $bypassRules, bypassSimpleHostnames: $bypassSimpleHostnames, directs: $directs, proxyRules: $proxyRules, removeImplicitRules: $removeImplicitRules, reverseBypassEnabled: $reverseBypassEnabled}';
  }
}
