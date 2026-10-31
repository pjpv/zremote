
part of 'print_job_settings.dart';

class PrintJobSettings {
  bool? animated;

  bool? canSpawnSeparateThread;

  PrintJobColorMode? colorMode;

  int? copies;

  bool? detailedErrorReporting;

  PrintJobDuplexMode? duplexMode;

  String? faxNumber;

  int? firstPage;

  double? footerHeight;

  PrintJobRenderingQuality? forceRenderingQuality;

  bool? handledByClient;

  bool? headerAndFooter;

  double? headerHeight;

  PrintJobPaginationMode? horizontalPagination;

  bool? isHorizontallyCentered;

  bool? isVerticallyCentered;

  PrintJobDisposition? jobDisposition;

  String? jobName;

  WebUri? jobSavingURL;

  int? lastPage;

  EdgeInsets? margins;

  double? maximumContentHeight;

  double? maximumContentWidth;

  PrintJobMediaSize? mediaSize;

  bool? mustCollate;

  int? numberOfPages;

  PrintJobOrientation? orientation;

  PrintJobOutputType? outputType;

  PrintJobPageOrder? pageOrder;

  int? pagesAcross;

  int? pagesDown;

  String? paperName;

  PrintJobResolution? resolution;

  double? scalingFactor;

  bool? showsNumberOfCopies;

  bool? showsPageRange;

  bool? showsPageSetupAccessory;

  bool? showsPaperOrientation;

  bool? showsPaperSelectionForLoadedPapers;

  bool? showsPaperSize;

  bool? showsPreview;

  bool? showsPrintPanel;

  bool? showsPrintSelection;

  bool? showsProgressPanel;

  bool? showsScaling;

  int? time;

  PrintJobPaginationMode? verticalPagination;
  PrintJobSettings(
      {this.animated = true,
      this.canSpawnSeparateThread = true,
      this.colorMode,
      this.copies = 1,
      this.detailedErrorReporting = false,
      this.duplexMode,
      this.faxNumber,
      this.firstPage,
      this.footerHeight,
      this.forceRenderingQuality,
      this.handledByClient = false,
      this.headerAndFooter = true,
      this.headerHeight,
      this.horizontalPagination,
      this.isHorizontallyCentered = true,
      this.isVerticallyCentered = true,
      this.jobDisposition,
      this.jobName,
      this.jobSavingURL,
      this.lastPage,
      this.margins,
      this.maximumContentHeight,
      this.maximumContentWidth,
      this.mediaSize,
      this.mustCollate,
      this.numberOfPages,
      this.orientation,
      this.outputType,
      this.pageOrder,
      this.pagesAcross,
      this.pagesDown,
      this.paperName,
      this.resolution,
      this.scalingFactor,
      this.showsNumberOfCopies = true,
      this.showsPageRange = true,
      this.showsPageSetupAccessory = true,
      this.showsPaperOrientation = true,
      this.showsPaperSelectionForLoadedPapers = false,
      this.showsPaperSize = true,
      this.showsPreview = true,
      this.showsPrintPanel = true,
      this.showsPrintSelection = true,
      this.showsProgressPanel = true,
      this.showsScaling = true,
      this.time,
      this.verticalPagination});

  static PrintJobSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PrintJobSettings(
      colorMode: PrintJobColorMode.fromNativeValue(map['colorMode']),
      duplexMode: PrintJobDuplexMode.fromNativeValue(map['duplexMode']),
      faxNumber: map['faxNumber'],
      firstPage: map['firstPage'],
      footerHeight: map['footerHeight'],
      forceRenderingQuality: PrintJobRenderingQuality.fromNativeValue(
          map['forceRenderingQuality']),
      headerHeight: map['headerHeight'],
      horizontalPagination:
          PrintJobPaginationMode.fromNativeValue(map['horizontalPagination']),
      jobDisposition:
          PrintJobDisposition.fromNativeValue(map['jobDisposition']),
      jobName: map['jobName'],
      jobSavingURL:
          map['jobSavingURL'] != null ? WebUri(map['jobSavingURL']) : null,
      lastPage: map['lastPage'],
      margins: MapEdgeInsets.fromMap(map['margins']?.cast<String, dynamic>()),
      maximumContentHeight: map['maximumContentHeight'],
      maximumContentWidth: map['maximumContentWidth'],
      mediaSize:
          PrintJobMediaSize.fromMap(map['mediaSize']?.cast<String, dynamic>()),
      mustCollate: map['mustCollate'],
      numberOfPages: map['numberOfPages'],
      orientation: PrintJobOrientation.fromNativeValue(map['orientation']),
      outputType: PrintJobOutputType.fromNativeValue(map['outputType']),
      pageOrder: PrintJobPageOrder.fromNativeValue(map['pageOrder']),
      pagesAcross: map['pagesAcross'],
      pagesDown: map['pagesDown'],
      paperName: map['paperName'],
      resolution: PrintJobResolution.fromMap(
          map['resolution']?.cast<String, dynamic>()),
      scalingFactor: map['scalingFactor'],
      time: map['time'],
      verticalPagination:
          PrintJobPaginationMode.fromNativeValue(map['verticalPagination']),
    );
    instance.animated = map['animated'];
    instance.canSpawnSeparateThread = map['canSpawnSeparateThread'];
    instance.copies = map['copies'];
    instance.detailedErrorReporting = map['detailedErrorReporting'];
    instance.handledByClient = map['handledByClient'];
    instance.headerAndFooter = map['headerAndFooter'];
    instance.isHorizontallyCentered = map['isHorizontallyCentered'];
    instance.isVerticallyCentered = map['isVerticallyCentered'];
    instance.showsNumberOfCopies = map['showsNumberOfCopies'];
    instance.showsPageRange = map['showsPageRange'];
    instance.showsPageSetupAccessory = map['showsPageSetupAccessory'];
    instance.showsPaperOrientation = map['showsPaperOrientation'];
    instance.showsPaperSelectionForLoadedPapers =
        map['showsPaperSelectionForLoadedPapers'];
    instance.showsPaperSize = map['showsPaperSize'];
    instance.showsPreview = map['showsPreview'];
    instance.showsPrintPanel = map['showsPrintPanel'];
    instance.showsPrintSelection = map['showsPrintSelection'];
    instance.showsProgressPanel = map['showsProgressPanel'];
    instance.showsScaling = map['showsScaling'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "animated": animated,
      "canSpawnSeparateThread": canSpawnSeparateThread,
      "colorMode": colorMode?.toNativeValue(),
      "copies": copies,
      "detailedErrorReporting": detailedErrorReporting,
      "duplexMode": duplexMode?.toNativeValue(),
      "faxNumber": faxNumber,
      "firstPage": firstPage,
      "footerHeight": footerHeight,
      "forceRenderingQuality": forceRenderingQuality?.toNativeValue(),
      "handledByClient": handledByClient,
      "headerAndFooter": headerAndFooter,
      "headerHeight": headerHeight,
      "horizontalPagination": horizontalPagination?.toNativeValue(),
      "isHorizontallyCentered": isHorizontallyCentered,
      "isVerticallyCentered": isVerticallyCentered,
      "jobDisposition": jobDisposition?.toNativeValue(),
      "jobName": jobName,
      "jobSavingURL": jobSavingURL?.toString(),
      "lastPage": lastPage,
      "margins": margins?.toMap(),
      "maximumContentHeight": maximumContentHeight,
      "maximumContentWidth": maximumContentWidth,
      "mediaSize": mediaSize?.toMap(),
      "mustCollate": mustCollate,
      "numberOfPages": numberOfPages,
      "orientation": orientation?.toNativeValue(),
      "outputType": outputType?.toNativeValue(),
      "pageOrder": pageOrder?.toNativeValue(),
      "pagesAcross": pagesAcross,
      "pagesDown": pagesDown,
      "paperName": paperName,
      "resolution": resolution?.toMap(),
      "scalingFactor": scalingFactor,
      "showsNumberOfCopies": showsNumberOfCopies,
      "showsPageRange": showsPageRange,
      "showsPageSetupAccessory": showsPageSetupAccessory,
      "showsPaperOrientation": showsPaperOrientation,
      "showsPaperSelectionForLoadedPapers": showsPaperSelectionForLoadedPapers,
      "showsPaperSize": showsPaperSize,
      "showsPreview": showsPreview,
      "showsPrintPanel": showsPrintPanel,
      "showsPrintSelection": showsPrintSelection,
      "showsProgressPanel": showsProgressPanel,
      "showsScaling": showsScaling,
      "time": time,
      "verticalPagination": verticalPagination?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  PrintJobSettings copy() {
    return PrintJobSettings.fromMap(toMap()) ?? PrintJobSettings();
  }

  @override
  String toString() {
    return 'PrintJobSettings{animated: $animated, canSpawnSeparateThread: $canSpawnSeparateThread, colorMode: $colorMode, copies: $copies, detailedErrorReporting: $detailedErrorReporting, duplexMode: $duplexMode, faxNumber: $faxNumber, firstPage: $firstPage, footerHeight: $footerHeight, forceRenderingQuality: $forceRenderingQuality, handledByClient: $handledByClient, headerAndFooter: $headerAndFooter, headerHeight: $headerHeight, horizontalPagination: $horizontalPagination, isHorizontallyCentered: $isHorizontallyCentered, isVerticallyCentered: $isVerticallyCentered, jobDisposition: $jobDisposition, jobName: $jobName, jobSavingURL: $jobSavingURL, lastPage: $lastPage, margins: $margins, maximumContentHeight: $maximumContentHeight, maximumContentWidth: $maximumContentWidth, mediaSize: $mediaSize, mustCollate: $mustCollate, numberOfPages: $numberOfPages, orientation: $orientation, outputType: $outputType, pageOrder: $pageOrder, pagesAcross: $pagesAcross, pagesDown: $pagesDown, paperName: $paperName, resolution: $resolution, scalingFactor: $scalingFactor, showsNumberOfCopies: $showsNumberOfCopies, showsPageRange: $showsPageRange, showsPageSetupAccessory: $showsPageSetupAccessory, showsPaperOrientation: $showsPaperOrientation, showsPaperSelectionForLoadedPapers: $showsPaperSelectionForLoadedPapers, showsPaperSize: $showsPaperSize, showsPreview: $showsPreview, showsPrintPanel: $showsPrintPanel, showsPrintSelection: $showsPrintSelection, showsProgressPanel: $showsProgressPanel, showsScaling: $showsScaling, time: $time, verticalPagination: $verticalPagination}';
  }
}
