import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'inappwebview_platform.dart';
import 'types/web_resource_response.dart';

part 'platform_webview_asset_loader.g.dart';

@ExchangeableObject(copyMethod: true)
class WebViewAssetLoader_ {
  static final String DEFAULT_DOMAIN = "appassets.androidplatform.net";

  String? domain;

  bool? httpAllowed;

  List<PlatformPathHandler>? pathHandlers;

  WebViewAssetLoader_({this.domain, this.httpAllowed, this.pathHandlers});
}

@immutable
class PlatformPathHandlerCreationParams {
  const PlatformPathHandlerCreationParams({required this.path});

  final String path;
}

abstract class PlatformPathHandler {
  late final PlatformPathHandlerEvents? eventHandler;

  String get type {
    throw UnimplementedError('type is not implemented on the current platform');
  }

  String get path {
    throw UnimplementedError('path is not implemented on the current platform');
  }

  Map<String, dynamic> toMap() {
    throw UnimplementedError(
        'toMap is not implemented on the current platform');
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError(
        'toJson is not implemented on the current platform');
  }
}

abstract class PlatformPathHandlerEvents {
  Future<WebResourceResponse?> handle(String path) {
    throw UnimplementedError(
        'handle is not implemented on the current platform');
  }
}

@immutable
class PlatformAssetsPathHandlerCreationParams
    extends PlatformPathHandlerCreationParams {
  PlatformAssetsPathHandlerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformPathHandlerCreationParams params,
  ) : super(path: params.path);

  factory PlatformAssetsPathHandlerCreationParams.fromPlatformPathHandlerCreationParams(
      PlatformPathHandlerCreationParams params) {
    return PlatformAssetsPathHandlerCreationParams(params);
  }
}

abstract class PlatformAssetsPathHandler extends PlatformInterface
    implements PlatformPathHandler {
  factory PlatformAssetsPathHandler(
      PlatformAssetsPathHandlerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformAssetsPathHandler assetsPathHandler =
        InAppWebViewPlatform.instance!.createPlatformAssetsPathHandler(params);
    PlatformInterface.verify(assetsPathHandler, _token);
    return assetsPathHandler;
  }

  @protected
  PlatformAssetsPathHandler.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformAssetsPathHandlerCreationParams params;

  @override
  String get type => 'AssetsPathHandler';

  @override
  String get path => params.path;
}

@immutable
class PlatformResourcesPathHandlerCreationParams
    extends PlatformPathHandlerCreationParams {
  PlatformResourcesPathHandlerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformPathHandlerCreationParams params,
  ) : super(path: params.path);

  factory PlatformResourcesPathHandlerCreationParams.fromPlatformPathHandlerCreationParams(
      PlatformPathHandlerCreationParams params) {
    return PlatformResourcesPathHandlerCreationParams(params);
  }
}

abstract class PlatformResourcesPathHandler extends PlatformInterface
    implements PlatformPathHandler {
  factory PlatformResourcesPathHandler(
      PlatformResourcesPathHandlerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformResourcesPathHandler resourcesPathHandler =
        InAppWebViewPlatform.instance!
            .createPlatformResourcesPathHandler(params);
    PlatformInterface.verify(resourcesPathHandler, _token);
    return resourcesPathHandler;
  }

  @protected
  PlatformResourcesPathHandler.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformResourcesPathHandlerCreationParams params;

  @override
  String get type => 'ResourcesPathHandler';

  @override
  String get path => params.path;
}

@immutable
class PlatformInternalStoragePathHandlerCreationParams
    extends PlatformPathHandlerCreationParams {
  PlatformInternalStoragePathHandlerCreationParams(
      // ignore: avoid_unused_constructor_parameters
      PlatformPathHandlerCreationParams params,
      {required this.directory})
      : super(path: params.path);

  factory PlatformInternalStoragePathHandlerCreationParams.fromPlatformPathHandlerCreationParams(
      PlatformPathHandlerCreationParams params,
      {required String directory}) {
    return PlatformInternalStoragePathHandlerCreationParams(params,
        directory: directory);
  }

  final String directory;
}

abstract class PlatformInternalStoragePathHandler extends PlatformInterface
    implements PlatformPathHandler {
  factory PlatformInternalStoragePathHandler(
      PlatformInternalStoragePathHandlerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformInternalStoragePathHandler internalStoragePathHandler =
        InAppWebViewPlatform.instance!
            .createPlatformInternalStoragePathHandler(params);
    PlatformInterface.verify(internalStoragePathHandler, _token);
    return internalStoragePathHandler;
  }

  @protected
  PlatformInternalStoragePathHandler.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformInternalStoragePathHandlerCreationParams params;

  @override
  String get type => 'InternalStoragePathHandler';

  @override
  String get path => params.path;

  String get directory => params.directory;
}

@immutable
class PlatformCustomPathHandlerCreationParams
    extends PlatformPathHandlerCreationParams {
  PlatformCustomPathHandlerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformPathHandlerCreationParams params,
  ) : super(path: params.path);

  factory PlatformCustomPathHandlerCreationParams.fromPlatformPathHandlerCreationParams(
      PlatformPathHandlerCreationParams params) {
    return PlatformCustomPathHandlerCreationParams(params);
  }
}

abstract class PlatformCustomPathHandler extends PlatformInterface
    implements PlatformPathHandler {
  factory PlatformCustomPathHandler(
      PlatformCustomPathHandlerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformCustomPathHandler customPathHandler =
        InAppWebViewPlatform.instance!.createPlatformCustomPathHandler(params);
    PlatformInterface.verify(customPathHandler, _token);
    return customPathHandler;
  }

  @protected
  PlatformCustomPathHandler.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformCustomPathHandlerCreationParams params;

  @override
  String get type => 'CustomPathHandler';

  @override
  String get path => params.path;
}
