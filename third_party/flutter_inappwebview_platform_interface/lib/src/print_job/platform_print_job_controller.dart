import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../in_app_webview/platform_inappwebview_controller.dart';
import '../inappwebview_platform.dart';
import '../types/disposable.dart';
import '../types/print_job_info.dart';

typedef PrintJobCompletionHandler = Future<void> Function(
    bool completed, String? error)?;

@immutable
class PlatformPrintJobControllerCreationParams {
  const PlatformPrintJobControllerCreationParams(
      {required this.id, this.onComplete});

  final String id;

  final PrintJobCompletionHandler? onComplete;
}

abstract class PlatformPrintJobController extends PlatformInterface
    implements Disposable {
  factory PlatformPrintJobController(
      PlatformPrintJobControllerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformPrintJobController printJobController =
        InAppWebViewPlatform.instance!.createPlatformPrintJobController(params);
    PlatformInterface.verify(printJobController, _token);
    return printJobController;
  }

  @protected
  PlatformPrintJobController.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformPrintJobControllerCreationParams params;

  String get id => params.id;

  PrintJobCompletionHandler? onComplete;

  Future<void> cancel() {
    throw UnimplementedError(
        'cancel is not implemented on the current platform');
  }

  Future<void> restart() {
    throw UnimplementedError(
        'restart is not implemented on the current platform');
  }

  Future<void> dismiss({bool animated = true}) {
    throw UnimplementedError(
        'dismiss is not implemented on the current platform');
  }

  Future<PrintJobInfo?> getInfo() {
    throw UnimplementedError(
        'getInfo is not implemented on the current platform');
  }

  @override
  void dispose() {
    throw UnimplementedError(
        'dispose is not implemented on the current platform');
  }
}
