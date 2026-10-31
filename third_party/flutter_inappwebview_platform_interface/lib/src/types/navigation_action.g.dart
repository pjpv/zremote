
part of 'navigation_action.dart';

class NavigationAction {
  @Deprecated('Use hasGesture instead')
  bool? androidHasGesture;

  @Deprecated('Use isRedirect instead')
  bool? androidIsRedirect;

  bool? hasGesture;

  @Deprecated('Use sourceFrame instead')
  IOSWKFrameInfo? iosSourceFrame;

  @Deprecated('Use targetFrame instead')
  IOSWKFrameInfo? iosTargetFrame;

  @Deprecated('Use navigationType instead')
  IOSWKNavigationType? iosWKNavigationType;

  bool isForMainFrame;

  bool? isRedirect;

  NavigationType? navigationType;

  URLRequest request;

  bool? shouldPerformDownload;

  FrameInfo? sourceFrame;

  FrameInfo? targetFrame;
  NavigationAction(
      {@Deprecated('Use hasGesture instead') this.androidHasGesture,
      @Deprecated('Use isRedirect instead') this.androidIsRedirect,
      this.hasGesture,
      @Deprecated('Use sourceFrame instead') this.iosSourceFrame,
      @Deprecated('Use targetFrame instead') this.iosTargetFrame,
      @Deprecated('Use navigationType instead') this.iosWKNavigationType,
      required this.isForMainFrame,
      this.isRedirect,
      this.navigationType,
      required this.request,
      this.shouldPerformDownload,
      this.sourceFrame,
      this.targetFrame}) {
    hasGesture = hasGesture ?? androidHasGesture;
    isRedirect = isRedirect ?? androidIsRedirect;
    sourceFrame = sourceFrame ?? FrameInfo.fromMap(iosSourceFrame?.toMap());
    targetFrame = targetFrame ?? FrameInfo.fromMap(iosTargetFrame?.toMap());
    navigationType = navigationType ??
        NavigationType.fromNativeValue(iosWKNavigationType?.toNativeValue());
  }

  static NavigationAction? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = NavigationAction(
      androidHasGesture: map['hasGesture'],
      androidIsRedirect: map['isRedirect'],
      hasGesture: map['hasGesture'],
      iosSourceFrame:
          IOSWKFrameInfo.fromMap(map['sourceFrame']?.cast<String, dynamic>()),
      iosTargetFrame:
          IOSWKFrameInfo.fromMap(map['targetFrame']?.cast<String, dynamic>()),
      iosWKNavigationType:
          IOSWKNavigationType.fromNativeValue(map['navigationType']),
      isForMainFrame: map['isForMainFrame'],
      isRedirect: map['isRedirect'],
      navigationType: NavigationType.fromNativeValue(map['navigationType']),
      request: URLRequest.fromMap(map['request']?.cast<String, dynamic>())!,
      shouldPerformDownload: map['shouldPerformDownload'],
      sourceFrame:
          FrameInfo.fromMap(map['sourceFrame']?.cast<String, dynamic>()),
      targetFrame:
          FrameInfo.fromMap(map['targetFrame']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "hasGesture": hasGesture,
      "isForMainFrame": isForMainFrame,
      "isRedirect": isRedirect,
      "navigationType": navigationType?.toNativeValue(),
      "request": request.toMap(),
      "shouldPerformDownload": shouldPerformDownload,
      "sourceFrame": sourceFrame?.toMap(),
      "targetFrame": targetFrame?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'NavigationAction{hasGesture: $hasGesture, isForMainFrame: $isForMainFrame, isRedirect: $isRedirect, navigationType: $navigationType, request: $request, shouldPerformDownload: $shouldPerformDownload, sourceFrame: $sourceFrame, targetFrame: $targetFrame}';
  }
}
