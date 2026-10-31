
part of 'create_window_action.dart';

class CreateWindowAction extends NavigationAction {
  @Deprecated('Use isDialog instead')
  bool? androidIsDialog;

  @Deprecated('Use windowFeatures instead')
  IOSWKWindowFeatures? iosWindowFeatures;

  bool? isDialog;

  WindowFeatures? windowFeatures;

  int windowId;
  CreateWindowAction(
      {@Deprecated('Use isDialog instead') this.androidIsDialog,
      @Deprecated('Use windowFeatures instead') this.iosWindowFeatures,
      this.isDialog,
      this.windowFeatures,
      required this.windowId,
      required URLRequest request,
      required bool isForMainFrame,
      @Deprecated('Use hasGesture instead') bool? androidHasGesture,
      bool? hasGesture,
      @Deprecated('Use isRedirect instead') bool? androidIsRedirect,
      bool? isRedirect,
      @Deprecated('Use navigationType instead')
      IOSWKNavigationType? iosWKNavigationType,
      NavigationType? navigationType,
      @Deprecated('Use sourceFrame instead') IOSWKFrameInfo? iosSourceFrame,
      FrameInfo? sourceFrame,
      @Deprecated('Use targetFrame instead') IOSWKFrameInfo? iosTargetFrame,
      FrameInfo? targetFrame,
      bool? shouldPerformDownload})
      : super(
            request: request,
            isForMainFrame: isForMainFrame,
            androidHasGesture: androidHasGesture,
            hasGesture: hasGesture,
            androidIsRedirect: androidIsRedirect,
            isRedirect: isRedirect,
            iosWKNavigationType: iosWKNavigationType,
            navigationType: navigationType,
            iosSourceFrame: iosSourceFrame,
            sourceFrame: sourceFrame,
            iosTargetFrame: iosTargetFrame,
            targetFrame: targetFrame,
            shouldPerformDownload: shouldPerformDownload) {
    isDialog = isDialog ?? androidIsDialog;
    windowFeatures =
        windowFeatures ?? WindowFeatures.fromMap(iosWindowFeatures?.toMap());
  }

  static CreateWindowAction? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = CreateWindowAction(
      request: URLRequest.fromMap(map['request']?.cast<String, dynamic>())!,
      isForMainFrame: map['isForMainFrame'],
      androidIsDialog: map['isDialog'],
      iosWindowFeatures: IOSWKWindowFeatures.fromMap(
          map['windowFeatures']?.cast<String, dynamic>()),
      isDialog: map['isDialog'],
      windowFeatures: WindowFeatures.fromMap(
          map['windowFeatures']?.cast<String, dynamic>()),
      windowId: map['windowId'],
    );
    instance.androidHasGesture = map['hasGesture'];
    instance.hasGesture = map['hasGesture'];
    instance.androidIsRedirect = map['isRedirect'];
    instance.isRedirect = map['isRedirect'];
    instance.iosWKNavigationType =
        IOSWKNavigationType.fromNativeValue(map['navigationType']);
    instance.navigationType =
        NavigationType.fromNativeValue(map['navigationType']);
    instance.iosSourceFrame =
        IOSWKFrameInfo.fromMap(map['sourceFrame']?.cast<String, dynamic>());
    instance.sourceFrame =
        FrameInfo.fromMap(map['sourceFrame']?.cast<String, dynamic>());
    instance.iosTargetFrame =
        IOSWKFrameInfo.fromMap(map['targetFrame']?.cast<String, dynamic>());
    instance.targetFrame =
        FrameInfo.fromMap(map['targetFrame']?.cast<String, dynamic>());
    instance.shouldPerformDownload = map['shouldPerformDownload'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "request": request.toMap(),
      "isForMainFrame": isForMainFrame,
      "hasGesture": hasGesture,
      "isRedirect": isRedirect,
      "navigationType": navigationType?.toNativeValue(),
      "sourceFrame": sourceFrame?.toMap(),
      "targetFrame": targetFrame?.toMap(),
      "shouldPerformDownload": shouldPerformDownload,
      "isDialog": isDialog,
      "windowFeatures": windowFeatures?.toMap(),
      "windowId": windowId,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CreateWindowAction{request: $request, isForMainFrame: $isForMainFrame, hasGesture: $hasGesture, isRedirect: $isRedirect, navigationType: $navigationType, sourceFrame: $sourceFrame, targetFrame: $targetFrame, shouldPerformDownload: $shouldPerformDownload, isDialog: $isDialog, windowFeatures: $windowFeatures, windowId: $windowId}';
  }
}
