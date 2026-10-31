
part of 'loaded_resource.dart';

class LoadedResource {
  double? duration;

  String? initiatorType;

  double? startTime;

  WebUri? url;
  LoadedResource({this.duration, this.initiatorType, this.startTime, this.url});

  static LoadedResource? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = LoadedResource(
      duration: map['duration'],
      initiatorType: map['initiatorType'],
      startTime: map['startTime'],
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "duration": duration,
      "initiatorType": initiatorType,
      "startTime": startTime,
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'LoadedResource{duration: $duration, initiatorType: $initiatorType, startTime: $startTime, url: $url}';
  }
}
