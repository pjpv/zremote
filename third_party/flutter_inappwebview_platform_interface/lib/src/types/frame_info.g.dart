
part of 'frame_info.dart';

class FrameInfo {
  bool isMainFrame;

  URLRequest? request;

  SecurityOrigin? securityOrigin;
  FrameInfo({required this.isMainFrame, this.request, this.securityOrigin});

  static FrameInfo? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FrameInfo(
      isMainFrame: map['isMainFrame'],
      request: URLRequest.fromMap(map['request']?.cast<String, dynamic>()),
      securityOrigin: SecurityOrigin.fromMap(
          map['securityOrigin']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "isMainFrame": isMainFrame,
      "request": request?.toMap(),
      "securityOrigin": securityOrigin?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FrameInfo{isMainFrame: $isMainFrame, request: $request, securityOrigin: $securityOrigin}';
  }
}

@Deprecated('Use FrameInfo instead')
class IOSWKFrameInfo {
  bool isMainFrame;

  URLRequest? request;

  IOSWKSecurityOrigin? securityOrigin;
  IOSWKFrameInfo(
      {required this.isMainFrame, this.request, this.securityOrigin});

  static IOSWKFrameInfo? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = IOSWKFrameInfo(
      isMainFrame: map['isMainFrame'],
      request: URLRequest.fromMap(map['request']?.cast<String, dynamic>()),
      securityOrigin: IOSWKSecurityOrigin.fromMap(
          map['securityOrigin']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "isMainFrame": isMainFrame,
      "request": request?.toMap(),
      "securityOrigin": securityOrigin?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'IOSWKFrameInfo{isMainFrame: $isMainFrame, request: $request, securityOrigin: $securityOrigin}';
  }
}
