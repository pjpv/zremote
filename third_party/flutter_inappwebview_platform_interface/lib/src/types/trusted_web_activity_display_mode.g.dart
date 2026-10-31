
part of 'trusted_web_activity_display_mode.dart';

abstract class TrustedWebActivityDisplayMode {
  TrustedWebActivityDisplayMode();

  Map<String, dynamic> toMap() {
    return {};
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'TrustedWebActivityDisplayMode{}';
  }
}
