import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'url_request.dart';
import 'navigation_type.dart';
import 'frame_info.dart';

part 'navigation_action.g.dart';

@ExchangeableObject()
class NavigationAction_ {
  URLRequest_ request;

  bool isForMainFrame;

  @Deprecated('Use hasGesture instead')
  bool? androidHasGesture;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "21",
        apiName: "WebResourceRequest.hasGesture",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebResourceRequest#hasGesture()",
        note: "On Android < 21, this is always `false`"),
    WindowsPlatform(
        note:
            "Available only if the request is associated to the [PlatformWebViewCreationParams.onCreateWindow] event")
  ])
  bool? hasGesture;

  @Deprecated('Use isRedirect instead')
  bool? androidIsRedirect;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "21",
        apiName: "WebResourceRequest.isRedirect",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebResourceRequest#isRedirect()"),
    WindowsPlatform()
  ])
  bool? isRedirect;

  @Deprecated("Use navigationType instead")
  IOSWKNavigationType_? iosWKNavigationType;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKNavigationAction.navigationType",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wknavigationaction/1401914-navigationtype"),
    MacOSPlatform(
        apiName: "WKNavigationAction.navigationType",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wknavigationaction/1401914-navigationtype"),
    WindowsPlatform()
  ])
  NavigationType_? navigationType;

  @Deprecated("Use sourceFrame instead")
  IOSWKFrameInfo_? iosSourceFrame;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKNavigationAction.sourceFrame",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wknavigationaction/1401926-sourceframe"),
    MacOSPlatform(
        apiName: "WKNavigationAction.sourceFrame",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wknavigationaction/1401926-sourceframe")
  ])
  FrameInfo_? sourceFrame;

  @Deprecated("Use targetFrame instead")
  IOSWKFrameInfo_? iosTargetFrame;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKNavigationAction.targetFrame",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wknavigationaction/1401918-targetframe"),
    MacOSPlatform(
        apiName: "WKNavigationAction.targetFrame",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wknavigationaction/1401918-targetframe")
  ])
  FrameInfo_? targetFrame;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "14.5",
        apiName: "WKNavigationAction.shouldPerformDownload",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wknavigationaction/3727357-shouldperformdownload"),
    MacOSPlatform(
        available: "11.3",
        apiName: "WKNavigationAction.shouldPerformDownload",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wknavigationaction/3727357-shouldperformdownload")
  ])
  bool? shouldPerformDownload;

  NavigationAction_(
      {required this.request,
      required this.isForMainFrame,
      @Deprecated('Use hasGesture instead') this.androidHasGesture,
      this.hasGesture,
      @Deprecated('Use isRedirect instead') this.androidIsRedirect,
      this.isRedirect,
      @Deprecated("Use navigationType instead") this.iosWKNavigationType,
      this.navigationType,
      @Deprecated("Use sourceFrame instead") this.iosSourceFrame,
      this.sourceFrame,
      @Deprecated("Use targetFrame instead") this.iosTargetFrame,
      this.targetFrame,
      this.shouldPerformDownload});
}
