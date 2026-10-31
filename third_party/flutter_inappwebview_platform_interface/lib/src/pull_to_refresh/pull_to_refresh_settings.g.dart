
part of 'pull_to_refresh_settings.dart';

class PullToRefreshSettings {
  AttributedString? attributedTitle;

  Color? backgroundColor;

  Color? color;

  int? distanceToTriggerSync;

  bool? enabled;

  PullToRefreshSize? size;

  int? slingshotDistance;
  PullToRefreshSettings(
      {this.attributedTitle,
      this.backgroundColor,
      this.color,
      this.distanceToTriggerSync,
      this.enabled = true,
      this.size,
      this.slingshotDistance});

  static PullToRefreshSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PullToRefreshSettings(
      attributedTitle: AttributedString.fromMap(
          map['attributedTitle']?.cast<String, dynamic>()),
      backgroundColor: map['backgroundColor'] != null
          ? UtilColor.fromStringRepresentation(map['backgroundColor'])
          : null,
      color: map['color'] != null
          ? UtilColor.fromStringRepresentation(map['color'])
          : null,
      distanceToTriggerSync: map['distanceToTriggerSync'],
      size: PullToRefreshSize.fromNativeValue(map['size']),
      slingshotDistance: map['slingshotDistance'],
    );
    instance.enabled = map['enabled'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "attributedTitle": attributedTitle?.toMap(),
      "backgroundColor": backgroundColor?.toHex(),
      "color": color?.toHex(),
      "distanceToTriggerSync": distanceToTriggerSync,
      "enabled": enabled,
      "size": size?.toNativeValue(),
      "slingshotDistance": slingshotDistance,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  PullToRefreshSettings copy() {
    return PullToRefreshSettings.fromMap(toMap()) ?? PullToRefreshSettings();
  }

  @override
  String toString() {
    return 'PullToRefreshSettings{attributedTitle: $attributedTitle, backgroundColor: $backgroundColor, color: $color, distanceToTriggerSync: $distanceToTriggerSync, enabled: $enabled, size: $size, slingshotDistance: $slingshotDistance}';
  }
}
