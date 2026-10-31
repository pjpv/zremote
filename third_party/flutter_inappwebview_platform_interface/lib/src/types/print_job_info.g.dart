
part of 'print_job_info.dart';

class PrintJobInfo {
  PrintJobAttributes? attributes;

  bool? canSpawnSeparateThread;

  int? copies;

  int? creationTime;

  int? currentPage;

  int? firstPage;

  bool? isCopyingOperation;

  String? label;

  int? lastPage;

  int? numberOfPages;

  PrintJobPageOrder? pageOrder;

  PrintJobRenderingQuality? preferredRenderingQuality;

  Printer? printer;

  bool? showsPrintPanel;

  bool? showsProgressPanel;

  PrintJobState? state;
  PrintJobInfo(
      {this.attributes,
      this.canSpawnSeparateThread,
      this.copies,
      this.creationTime,
      this.currentPage,
      this.firstPage,
      this.isCopyingOperation,
      this.label,
      this.lastPage,
      this.numberOfPages,
      this.pageOrder,
      this.preferredRenderingQuality,
      this.printer,
      this.showsPrintPanel,
      this.showsProgressPanel,
      this.state});

  static PrintJobInfo? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PrintJobInfo(
      attributes: PrintJobAttributes.fromMap(
          map['attributes']?.cast<String, dynamic>()),
      canSpawnSeparateThread: map['canSpawnSeparateThread'],
      copies: map['copies'],
      creationTime: map['creationTime'],
      currentPage: map['currentPage'],
      firstPage: map['firstPage'],
      isCopyingOperation: map['isCopyingOperation'],
      label: map['label'],
      lastPage: map['lastPage'],
      numberOfPages: map['numberOfPages'],
      pageOrder: PrintJobPageOrder.fromNativeValue(map['pageOrder']),
      preferredRenderingQuality: PrintJobRenderingQuality.fromNativeValue(
          map['preferredRenderingQuality']),
      printer: Printer.fromMap(map['printer']?.cast<String, dynamic>()),
      showsPrintPanel: map['showsPrintPanel'],
      showsProgressPanel: map['showsProgressPanel'],
      state: PrintJobState.fromNativeValue(map['state']),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "attributes": attributes?.toMap(),
      "canSpawnSeparateThread": canSpawnSeparateThread,
      "copies": copies,
      "creationTime": creationTime,
      "currentPage": currentPage,
      "firstPage": firstPage,
      "isCopyingOperation": isCopyingOperation,
      "label": label,
      "lastPage": lastPage,
      "numberOfPages": numberOfPages,
      "pageOrder": pageOrder?.toNativeValue(),
      "preferredRenderingQuality": preferredRenderingQuality?.toNativeValue(),
      "printer": printer?.toMap(),
      "showsPrintPanel": showsPrintPanel,
      "showsProgressPanel": showsProgressPanel,
      "state": state?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PrintJobInfo{attributes: $attributes, canSpawnSeparateThread: $canSpawnSeparateThread, copies: $copies, creationTime: $creationTime, currentPage: $currentPage, firstPage: $firstPage, isCopyingOperation: $isCopyingOperation, label: $label, lastPage: $lastPage, numberOfPages: $numberOfPages, pageOrder: $pageOrder, preferredRenderingQuality: $preferredRenderingQuality, printer: $printer, showsPrintPanel: $showsPrintPanel, showsProgressPanel: $showsProgressPanel, state: $state}';
  }
}
