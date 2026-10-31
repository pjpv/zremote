
part of 'screenshot_configuration.dart';

class ScreenshotConfiguration {
  bool afterScreenUpdates;

  CompressFormat compressFormat;

  @Deprecated('Use afterScreenUpdates instead')
  bool? iosAfterScreenUpdates;

  int quality;

  InAppWebViewRect? rect;

  double? snapshotWidth;
  ScreenshotConfiguration(
      {this.rect,
      this.snapshotWidth,
      this.compressFormat = CompressFormat.PNG,
      this.quality = 100,
      @Deprecated("Use afterScreenUpdates instead") this.iosAfterScreenUpdates,
      this.afterScreenUpdates = true}) {
    assert(this.quality >= 0);
    this.afterScreenUpdates = this.iosAfterScreenUpdates != null
        ? this.iosAfterScreenUpdates!
        : this.afterScreenUpdates;
  }

  static ScreenshotConfiguration? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ScreenshotConfiguration(
      iosAfterScreenUpdates: map['afterScreenUpdates'],
      rect: InAppWebViewRect.fromMap(map['rect']?.cast<String, dynamic>()),
      snapshotWidth: map['snapshotWidth'],
    );
    instance.afterScreenUpdates = map['afterScreenUpdates'];
    instance.compressFormat =
        CompressFormat.fromNativeValue(map['compressFormat'])!;
    instance.quality = map['quality'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "afterScreenUpdates": afterScreenUpdates,
      "compressFormat": compressFormat.toNativeValue(),
      "quality": quality,
      "rect": rect?.toMap(),
      "snapshotWidth": snapshotWidth,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ScreenshotConfiguration{afterScreenUpdates: $afterScreenUpdates, compressFormat: $compressFormat, quality: $quality, rect: $rect, snapshotWidth: $snapshotWidth}';
  }
}
