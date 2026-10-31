
part of 'ui_event_attribution.dart';

class UIEventAttribution {
  WebUri destinationURL;

  String purchaser;

  String sourceDescription;

  int sourceIdentifier;
  UIEventAttribution(
      {required this.sourceIdentifier,
      required this.destinationURL,
      required this.sourceDescription,
      required this.purchaser});

  static UIEventAttribution? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = UIEventAttribution(
      destinationURL: WebUri(map['destinationURL']),
      purchaser: map['purchaser'],
      sourceDescription: map['sourceDescription'],
      sourceIdentifier: map['sourceIdentifier'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "destinationURL": destinationURL.toString(),
      "purchaser": purchaser,
      "sourceDescription": sourceDescription,
      "sourceIdentifier": sourceIdentifier,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'UIEventAttribution{destinationURL: $destinationURL, purchaser: $purchaser, sourceDescription: $sourceDescription, sourceIdentifier: $sourceIdentifier}';
  }
}
