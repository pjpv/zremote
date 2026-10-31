import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'safe_browsing_threat.g.dart';

@ExchangeableEnum()
class SafeBrowsingThreat_ {
  // ignore: unused_field
  final int _value;
  const SafeBrowsingThreat_._internal(this._value);

  static const SAFE_BROWSING_THREAT_UNKNOWN =
      const SafeBrowsingThreat_._internal(0);

  static const SAFE_BROWSING_THREAT_MALWARE =
      const SafeBrowsingThreat_._internal(1);

  static const SAFE_BROWSING_THREAT_PHISHING =
      const SafeBrowsingThreat_._internal(2);

  static const SAFE_BROWSING_THREAT_UNWANTED_SOFTWARE =
      const SafeBrowsingThreat_._internal(3);

  static const SAFE_BROWSING_THREAT_BILLING =
      const SafeBrowsingThreat_._internal(4);
}
