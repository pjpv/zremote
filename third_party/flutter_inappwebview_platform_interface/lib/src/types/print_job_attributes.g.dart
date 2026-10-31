
part of 'print_job_attributes.dart';

class PrintJobAttributes {
  PrintJobColorMode? colorMode;

  bool? detailedErrorReporting;

  PrintJobDuplexMode? duplex;

  String? faxNumber;

  double? footerHeight;

  bool? headerAndFooter;

  double? headerHeight;

  PrintJobPaginationMode? horizontalPagination;

  bool? isHorizontallyCentered;

  bool? isSelectionOnly;

  bool? isVerticallyCentered;

  PrintJobDisposition? jobDisposition;

  WebUri? jobSavingURL;

  String? localizedPaperName;

  EdgeInsets? margins;

  double? maximumContentHeight;

  double? maximumContentWidth;

  PrintJobMediaSize? mediaSize;

  bool? mustCollate;

  PrintJobOrientation? orientation;

  int? pagesAcross;

  int? pagesDown;

  String? paperName;

  InAppWebViewRect? paperRect;

  InAppWebViewRect? printableRect;

  PrintJobResolution? resolution;

  double? scalingFactor;

  int? time;

  PrintJobPaginationMode? verticalPagination;
  PrintJobAttributes(
      {this.colorMode,
      this.detailedErrorReporting,
      this.duplex,
      this.faxNumber,
      this.footerHeight,
      this.headerAndFooter,
      this.headerHeight,
      this.horizontalPagination,
      this.isHorizontallyCentered,
      this.isSelectionOnly,
      this.isVerticallyCentered,
      this.jobDisposition,
      this.jobSavingURL,
      this.localizedPaperName,
      this.margins,
      this.maximumContentHeight,
      this.maximumContentWidth,
      this.mediaSize,
      this.mustCollate,
      this.orientation,
      this.pagesAcross,
      this.pagesDown,
      this.paperName,
      this.paperRect,
      this.printableRect,
      this.resolution,
      this.scalingFactor,
      this.time,
      this.verticalPagination});

  static PrintJobAttributes? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PrintJobAttributes(
      colorMode: PrintJobColorMode.fromNativeValue(map['colorMode']),
      detailedErrorReporting: map['detailedErrorReporting'],
      duplex: PrintJobDuplexMode.fromNativeValue(map['duplex']),
      faxNumber: map['faxNumber'],
      footerHeight: map['footerHeight'],
      headerAndFooter: map['headerAndFooter'],
      headerHeight: map['headerHeight'],
      horizontalPagination:
          PrintJobPaginationMode.fromNativeValue(map['horizontalPagination']),
      isHorizontallyCentered: map['isHorizontallyCentered'],
      isSelectionOnly: map['isSelectionOnly'],
      isVerticallyCentered: map['isVerticallyCentered'],
      jobDisposition:
          PrintJobDisposition.fromNativeValue(map['jobDisposition']),
      jobSavingURL:
          map['jobSavingURL'] != null ? WebUri(map['jobSavingURL']) : null,
      localizedPaperName: map['localizedPaperName'],
      margins: MapEdgeInsets.fromMap(map['margins']?.cast<String, dynamic>()),
      maximumContentHeight: map['maximumContentHeight'],
      maximumContentWidth: map['maximumContentWidth'],
      mediaSize:
          PrintJobMediaSize.fromMap(map['mediaSize']?.cast<String, dynamic>()),
      mustCollate: map['mustCollate'],
      orientation: PrintJobOrientation.fromNativeValue(map['orientation']),
      pagesAcross: map['pagesAcross'],
      pagesDown: map['pagesDown'],
      paperName: map['paperName'],
      paperRect:
          InAppWebViewRect.fromMap(map['paperRect']?.cast<String, dynamic>()),
      printableRect: InAppWebViewRect.fromMap(
          map['printableRect']?.cast<String, dynamic>()),
      resolution: PrintJobResolution.fromMap(
          map['resolution']?.cast<String, dynamic>()),
      scalingFactor: map['scalingFactor'],
      time: map['time'],
      verticalPagination:
          PrintJobPaginationMode.fromNativeValue(map['verticalPagination']),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "colorMode": colorMode?.toNativeValue(),
      "detailedErrorReporting": detailedErrorReporting,
      "duplex": duplex?.toNativeValue(),
      "faxNumber": faxNumber,
      "footerHeight": footerHeight,
      "headerAndFooter": headerAndFooter,
      "headerHeight": headerHeight,
      "horizontalPagination": horizontalPagination?.toNativeValue(),
      "isHorizontallyCentered": isHorizontallyCentered,
      "isSelectionOnly": isSelectionOnly,
      "isVerticallyCentered": isVerticallyCentered,
      "jobDisposition": jobDisposition?.toNativeValue(),
      "jobSavingURL": jobSavingURL?.toString(),
      "localizedPaperName": localizedPaperName,
      "margins": margins?.toMap(),
      "maximumContentHeight": maximumContentHeight,
      "maximumContentWidth": maximumContentWidth,
      "mediaSize": mediaSize?.toMap(),
      "mustCollate": mustCollate,
      "orientation": orientation?.toNativeValue(),
      "pagesAcross": pagesAcross,
      "pagesDown": pagesDown,
      "paperName": paperName,
      "paperRect": paperRect?.toMap(),
      "printableRect": printableRect?.toMap(),
      "resolution": resolution?.toMap(),
      "scalingFactor": scalingFactor,
      "time": time,
      "verticalPagination": verticalPagination?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PrintJobAttributes{colorMode: $colorMode, detailedErrorReporting: $detailedErrorReporting, duplex: $duplex, faxNumber: $faxNumber, footerHeight: $footerHeight, headerAndFooter: $headerAndFooter, headerHeight: $headerHeight, horizontalPagination: $horizontalPagination, isHorizontallyCentered: $isHorizontallyCentered, isSelectionOnly: $isSelectionOnly, isVerticallyCentered: $isVerticallyCentered, jobDisposition: $jobDisposition, jobSavingURL: $jobSavingURL, localizedPaperName: $localizedPaperName, margins: $margins, maximumContentHeight: $maximumContentHeight, maximumContentWidth: $maximumContentWidth, mediaSize: $mediaSize, mustCollate: $mustCollate, orientation: $orientation, pagesAcross: $pagesAcross, pagesDown: $pagesDown, paperName: $paperName, paperRect: $paperRect, printableRect: $printableRect, resolution: $resolution, scalingFactor: $scalingFactor, time: $time, verticalPagination: $verticalPagination}';
  }
}
