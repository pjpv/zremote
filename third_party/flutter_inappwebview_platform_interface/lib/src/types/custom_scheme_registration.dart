import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../webview_environment/webview_environment_settings.dart';

part 'custom_scheme_registration.g.dart';

@SupportedPlatforms(platforms: [WindowsPlatform()])
@ExchangeableObject()
class CustomSchemeRegistration_ {
  String scheme;

  List<String>? allowedOrigins;

  bool? treatAsSecure;

  bool? hasAuthorityComponent;

  CustomSchemeRegistration_({required this.scheme, this.allowedOrigins, this.treatAsSecure, this.hasAuthorityComponent});
}
