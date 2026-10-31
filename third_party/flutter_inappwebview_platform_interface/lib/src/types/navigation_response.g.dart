
part of 'navigation_response.dart';

class NavigationResponse {
  bool canShowMIMEType;

  bool isForMainFrame;

  URLResponse? response;
  NavigationResponse(
      {required this.canShowMIMEType,
      required this.isForMainFrame,
      this.response});

  static NavigationResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = NavigationResponse(
      canShowMIMEType: map['canShowMIMEType'],
      isForMainFrame: map['isForMainFrame'],
      response: URLResponse.fromMap(map['response']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "canShowMIMEType": canShowMIMEType,
      "isForMainFrame": isForMainFrame,
      "response": response?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'NavigationResponse{canShowMIMEType: $canShowMIMEType, isForMainFrame: $isForMainFrame, response: $response}';
  }
}

@Deprecated('Use NavigationResponse instead')
class IOSWKNavigationResponse {
  bool canShowMIMEType;

  bool isForMainFrame;

  IOSURLResponse? response;
  IOSWKNavigationResponse(
      {required this.canShowMIMEType,
      required this.isForMainFrame,
      this.response});

  static IOSWKNavigationResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = IOSWKNavigationResponse(
      canShowMIMEType: map['canShowMIMEType'],
      isForMainFrame: map['isForMainFrame'],
      response:
          IOSURLResponse.fromMap(map['response']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "canShowMIMEType": canShowMIMEType,
      "isForMainFrame": isForMainFrame,
      "response": response?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'IOSWKNavigationResponse{canShowMIMEType: $canShowMIMEType, isForMainFrame: $isForMainFrame, response: $response}';
  }
}
