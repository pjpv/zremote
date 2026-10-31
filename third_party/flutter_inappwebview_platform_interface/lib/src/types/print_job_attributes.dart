import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../util.dart';
import '../print_job/main.dart';
import '../web_uri.dart';
import 'in_app_webview_rect.dart';
import 'print_job_color_mode.dart';
import 'print_job_duplex_mode.dart';
import 'print_job_orientation.dart';
import 'print_job_media_size.dart';
import 'print_job_resolution.dart';
import 'print_job_pagination_mode.dart';
import 'print_job_disposition.dart';

part 'print_job_attributes.g.dart';

@ExchangeableObject()
class PrintJobAttributes_ {
  @SupportedPlatforms(platforms: [AndroidPlatform(), MacOSPlatform()])
  PrintJobColorMode_? colorMode;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(available: "23"),
    IOSPlatform(),
    MacOSPlatform()
  ])
  PrintJobDuplexMode_? duplex;

  PrintJobOrientation_? orientation;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  PrintJobMediaSize_? mediaSize;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  PrintJobResolution_? resolution;

  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  EdgeInsets? margins;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  double? footerHeight;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  double? headerHeight;

  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  InAppWebViewRect_? printableRect;

  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  InAppWebViewRect_? paperRect;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  double? maximumContentHeight;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  double? maximumContentWidth;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  String? paperName;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  String? localizedPaperName;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  PrintJobPaginationMode_? horizontalPagination;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  PrintJobPaginationMode_? verticalPagination;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  PrintJobDisposition_? jobDisposition;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  bool? isHorizontallyCentered;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  bool? isVerticallyCentered;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  bool? isSelectionOnly;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  double? scalingFactor;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  WebUri? jobSavingURL;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  bool? detailedErrorReporting;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  String? faxNumber;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  bool? headerAndFooter;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  bool? mustCollate;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  int? pagesAcross;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  int? pagesDown;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  int? time;

  PrintJobAttributes_(
      {this.colorMode,
      this.duplex,
      this.orientation,
      this.mediaSize,
      this.resolution,
      this.margins,
      this.maximumContentHeight,
      this.maximumContentWidth,
      this.footerHeight,
      this.headerHeight,
      this.paperRect,
      this.printableRect,
      this.paperName,
      this.localizedPaperName,
      this.horizontalPagination,
      this.verticalPagination,
      this.jobDisposition,
      this.isHorizontallyCentered,
      this.isVerticallyCentered,
      this.isSelectionOnly,
      this.scalingFactor,
      this.jobSavingURL,
      this.detailedErrorReporting,
      this.faxNumber,
      this.headerAndFooter,
      this.mustCollate,
      this.pagesAcross,
      this.pagesDown,
      this.time});
}
