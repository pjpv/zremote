
part of 'proxy_rule.dart';

class ProxyRule {
  ProxySchemeFilter? schemeFilter;

  String url;
  ProxyRule({this.schemeFilter, required this.url});

  static ProxyRule? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ProxyRule(
      schemeFilter: ProxySchemeFilter.fromNativeValue(map['schemeFilter']),
      url: map['url'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "schemeFilter": schemeFilter?.toNativeValue(),
      "url": url,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ProxyRule{schemeFilter: $schemeFilter, url: $url}';
  }
}
