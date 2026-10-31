import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';

part 'printer.g.dart';

@ExchangeableObject()
class Printer_ {
  @SupportedPlatforms(platforms: [AndroidPlatform(), IOSPlatform()])
  String? id;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  String? type;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  int? languageLevel;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  String? name;

  Printer_({this.id, this.type, this.languageLevel, this.name});
}
