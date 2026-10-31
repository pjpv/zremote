import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';
import 'print_job_attributes.dart';
import 'print_job_rendering_quality.dart';
import 'print_job_state.dart';
import 'print_job_page_order.dart';
import 'printer.dart';

part 'print_job_info.g.dart';

@ExchangeableObject()
class PrintJobInfo_ {
  PrintJobState_? state;

  int? copies;

  int? numberOfPages;

  int? creationTime;

  String? label;

  Printer_? printer;

  PrintJobPageOrder_? pageOrder;

  PrintJobRenderingQuality_? preferredRenderingQuality;

  bool? showsProgressPanel;

  bool? showsPrintPanel;

  bool? canSpawnSeparateThread;

  bool? isCopyingOperation;

  int? currentPage;

  int? firstPage;

  int? lastPage;

  PrintJobAttributes_? attributes;

  PrintJobInfo_(
      {this.state,
      this.copies,
      this.numberOfPages,
      this.creationTime,
      this.label,
      this.printer,
      this.pageOrder,
      this.preferredRenderingQuality,
      this.showsProgressPanel,
      this.showsPrintPanel,
      this.canSpawnSeparateThread,
      this.isCopyingOperation,
      this.currentPage,
      this.firstPage,
      this.lastPage,
      this.attributes});
}
