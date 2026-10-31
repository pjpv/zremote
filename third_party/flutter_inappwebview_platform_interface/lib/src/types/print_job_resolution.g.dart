
part of 'print_job_resolution.dart';

class PrintJobResolution {
  final int horizontalDpi;

  final String id;

  final String label;

  final int verticalDpi;
  const PrintJobResolution(
      {required this.horizontalDpi,
      required this.id,
      required this.label,
      required this.verticalDpi});

  static PrintJobResolution? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PrintJobResolution(
      horizontalDpi: map['horizontalDpi'],
      id: map['id'],
      label: map['label'],
      verticalDpi: map['verticalDpi'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "horizontalDpi": horizontalDpi,
      "id": id,
      "label": label,
      "verticalDpi": verticalDpi,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PrintJobResolution{horizontalDpi: $horizontalDpi, id: $id, label: $label, verticalDpi: $verticalDpi}';
  }
}
