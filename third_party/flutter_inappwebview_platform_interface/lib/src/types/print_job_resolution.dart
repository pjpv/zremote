import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';

part 'print_job_resolution.g.dart';

@ExchangeableObject()
class PrintJobResolution_ {
  final String id;

  final String label;

  final int verticalDpi;

  final int horizontalDpi;

  const PrintJobResolution_(
      {required this.id,
      required this.label,
      required this.verticalDpi,
      required this.horizontalDpi});
}
