import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

@immutable
class AndroidPathHandlerCreationParams
    extends PlatformPathHandlerCreationParams {
  AndroidPathHandlerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformPathHandlerCreationParams params,
  ) : super(path: params.path);

  factory AndroidPathHandlerCreationParams.fromPlatformPathHandlerCreationParams(
      PlatformPathHandlerCreationParams params) {
    return AndroidPathHandlerCreationParams(params);
  }
}

abstract mixin class AndroidPathHandler
    implements ChannelController, PlatformPathHandler {
  final String _id = IdGenerator.generate();

  @override
  late final PlatformPathHandlerEvents? eventHandler;

  @override
  late final String path;

  void _init(PlatformPathHandlerCreationParams params) {
    this.path = params.path;
    channel = MethodChannel(
        'com.pichillilorenzo/flutter_inappwebview_custompathhandler_${_id}');
    handler = _handleMethod;
    initMethodCallHandler();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "handle":
        String path = call.arguments["path"];
        return (await eventHandler?.handle(path))?.toMap();
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {"path": path, "type": type, "id": _id};
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AndroidPathHandler{path: $path, type: $type}';
  }

  @override
  void dispose() {
    disposeChannel();
    eventHandler = null;
  }
}

@immutable
class AndroidAssetsPathHandlerCreationParams
    extends PlatformAssetsPathHandlerCreationParams {
  AndroidAssetsPathHandlerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformAssetsPathHandlerCreationParams params,
  ) : super(params);

  factory AndroidAssetsPathHandlerCreationParams.fromPlatformAssetsPathHandlerCreationParams(
      PlatformAssetsPathHandlerCreationParams params) {
    return AndroidAssetsPathHandlerCreationParams(params);
  }
}

class AndroidAssetsPathHandler extends PlatformAssetsPathHandler
    with AndroidPathHandler, ChannelController {
  AndroidAssetsPathHandler(PlatformAssetsPathHandlerCreationParams params)
      : super.implementation(
          params is AndroidAssetsPathHandlerCreationParams
              ? params
              : AndroidAssetsPathHandlerCreationParams
                  .fromPlatformAssetsPathHandlerCreationParams(params),
        ) {
    _init(params);
  }
}

@immutable
class AndroidResourcesPathHandlerCreationParams
    extends PlatformResourcesPathHandlerCreationParams {
  AndroidResourcesPathHandlerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformResourcesPathHandlerCreationParams params,
  ) : super(params);

  factory AndroidResourcesPathHandlerCreationParams.fromPlatformResourcesPathHandlerCreationParams(
      PlatformResourcesPathHandlerCreationParams params) {
    return AndroidResourcesPathHandlerCreationParams(params);
  }
}

class AndroidResourcesPathHandler extends PlatformResourcesPathHandler
    with AndroidPathHandler, ChannelController {
  AndroidResourcesPathHandler(PlatformResourcesPathHandlerCreationParams params)
      : super.implementation(
          params is AndroidResourcesPathHandlerCreationParams
              ? params
              : AndroidResourcesPathHandlerCreationParams
                  .fromPlatformResourcesPathHandlerCreationParams(params),
        ) {
    _init(params);
  }
}

@immutable
class AndroidInternalStoragePathHandlerCreationParams
    extends PlatformInternalStoragePathHandlerCreationParams {
  AndroidInternalStoragePathHandlerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformInternalStoragePathHandlerCreationParams params,
  ) : super(params, directory: params.directory);

  factory AndroidInternalStoragePathHandlerCreationParams.fromPlatformInternalStoragePathHandlerCreationParams(
      PlatformInternalStoragePathHandlerCreationParams params) {
    return AndroidInternalStoragePathHandlerCreationParams(params);
  }
}

class AndroidInternalStoragePathHandler
    extends PlatformInternalStoragePathHandler
    with AndroidPathHandler, ChannelController {
  AndroidInternalStoragePathHandler(
      PlatformInternalStoragePathHandlerCreationParams params)
      : super.implementation(
          params is AndroidInternalStoragePathHandlerCreationParams
              ? params
              : AndroidInternalStoragePathHandlerCreationParams
                  .fromPlatformInternalStoragePathHandlerCreationParams(params),
        ) {
    _init(params);
  }

  AndroidInternalStoragePathHandlerCreationParams get _internalParams =>
      params as AndroidInternalStoragePathHandlerCreationParams;

  @override
  String get directory => _internalParams.directory;

  @override
  Map<String, dynamic> toMap() {
    return {...toMap(), 'directory': directory};
  }
}

@immutable
class AndroidCustomPathHandlerCreationParams
    extends PlatformCustomPathHandlerCreationParams {
  AndroidCustomPathHandlerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformCustomPathHandlerCreationParams params,
  ) : super(params);

  factory AndroidCustomPathHandlerCreationParams.fromPlatformCustomPathHandlerCreationParams(
      PlatformCustomPathHandlerCreationParams params) {
    return AndroidCustomPathHandlerCreationParams(params);
  }
}

class AndroidCustomPathHandler extends PlatformCustomPathHandler
    with AndroidPathHandler, ChannelController {
  AndroidCustomPathHandler(PlatformCustomPathHandlerCreationParams params)
      : super.implementation(
          params is AndroidCustomPathHandlerCreationParams
              ? params
              : AndroidCustomPathHandlerCreationParams
                  .fromPlatformCustomPathHandlerCreationParams(params),
        ) {
    _init(params);
  }
}
