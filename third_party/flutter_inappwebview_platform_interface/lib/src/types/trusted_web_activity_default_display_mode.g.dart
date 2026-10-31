
part of 'trusted_web_activity_default_display_mode.dart';

class TrustedWebActivityDefaultDisplayMode
    implements TrustedWebActivityDisplayMode {
  static final String _type = "DEFAULT_MODE";
  TrustedWebActivityDefaultDisplayMode();
  @ExchangeableObjectMethod(toMapMergeWith: true)
  Map<String, dynamic> _toMapMergeWith() {
    return {"type": _type};
  }

  Map<String, dynamic> toMap() {
    return {
      ..._toMapMergeWith(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'TrustedWebActivityDefaultDisplayMode{}';
  }
}
