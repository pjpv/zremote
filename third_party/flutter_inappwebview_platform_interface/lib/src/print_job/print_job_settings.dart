import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../types/main.dart';
import '../types/print_job_color_mode.dart';
import '../types/print_job_disposition.dart';
import '../types/print_job_duplex_mode.dart';
import '../types/print_job_media_size.dart';
import '../types/print_job_orientation.dart';
import '../types/print_job_output_type.dart';
import '../types/print_job_page_order.dart';
import '../types/print_job_pagination_mode.dart';
import '../types/print_job_rendering_quality.dart';
import '../types/print_job_resolution.dart';
import '../util.dart';
import '../web_uri.dart';
import 'platform_print_job_controller.dart';

part 'print_job_settings.g.dart';

@ExchangeableObject(copyMethod: true)
class PrintJobSettings_ {
  bool? handledByClient;

  String? jobName;

  bool? animated;

  PrintJobOrientation_? orientation;

  int? numberOfPages;

  PrintJobRenderingQuality_? forceRenderingQuality;

  EdgeInsets? margins;

  PrintJobMediaSize_? mediaSize;

  PrintJobColorMode_? colorMode;

  PrintJobDuplexMode_? duplexMode;

  PrintJobOutputType_? outputType;

  PrintJobResolution_? resolution;

  bool? showsNumberOfCopies;

  bool? showsPaperSelectionForLoadedPapers;

  bool? showsPaperOrientation;

  bool? showsPaperSize;

  bool? showsScaling;

  bool? showsPageRange;

  bool? showsPageSetupAccessory;

  bool? showsPreview;

  bool? showsPrintSelection;

  bool? showsPrintPanel;

  bool? showsProgressPanel;

  double? footerHeight;

  double? headerHeight;

  double? maximumContentHeight;

  double? maximumContentWidth;

  double? scalingFactor;

  PrintJobDisposition_? jobDisposition;

  WebUri? jobSavingURL;

  String? paperName;

  PrintJobPaginationMode_? horizontalPagination;

  PrintJobPaginationMode_? verticalPagination;

  bool? isHorizontallyCentered;

  bool? isVerticallyCentered;

  PrintJobPageOrder_? pageOrder;

  bool? canSpawnSeparateThread;

  int? copies;

  int? firstPage;

  int? lastPage;

  bool? detailedErrorReporting;

  String? faxNumber;

  bool? headerAndFooter;

  bool? mustCollate;

  int? pagesAcross;

  int? pagesDown;

  int? time;

  PrintJobSettings_(
      {this.handledByClient = false,
      this.jobName,
      this.animated = true,
      this.orientation,
      this.numberOfPages,
      this.forceRenderingQuality,
      this.margins,
      this.mediaSize,
      this.colorMode,
      this.duplexMode,
      this.outputType,
      this.resolution,
      this.showsNumberOfCopies = true,
      this.showsPaperSelectionForLoadedPapers = false,
      this.showsPaperOrientation = true,
      this.maximumContentHeight,
      this.maximumContentWidth,
      this.footerHeight,
      this.headerHeight,
      this.showsPaperSize = true,
      this.showsScaling = true,
      this.showsPageRange = true,
      this.showsPageSetupAccessory = true,
      this.showsPreview = true,
      this.showsPrintSelection = true,
      this.scalingFactor,
      this.showsPrintPanel = true,
      this.showsProgressPanel = true,
      this.jobDisposition,
      this.jobSavingURL,
      this.paperName,
      this.horizontalPagination,
      this.verticalPagination,
      this.isHorizontallyCentered = true,
      this.isVerticallyCentered = true,
      this.pageOrder,
      this.canSpawnSeparateThread = true,
      this.copies = 1,
      this.firstPage,
      this.lastPage,
      this.detailedErrorReporting = false,
      this.faxNumber,
      this.headerAndFooter = true,
      this.mustCollate,
      this.pagesAcross,
      this.pagesDown,
      this.time});
}
