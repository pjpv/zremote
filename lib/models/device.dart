class RemoteDevice {
  final String id;
  final String baseUrl;
  final Map<String, String> params;
  final String label;
  final DateTime createdAt;

  RemoteDevice({
    required this.id,
    required this.baseUrl,
    required this.params,
    required this.label,
    required this.createdAt,
  });

  String get sid => params['sid'] ?? '';

  String get sidSuffix => sid.length <= 6 ? sid : sid.substring(sid.length - 6);

  Map<String, dynamic> toJson() => {
    'id': id,
    'baseUrl': baseUrl,
    'params': params,
    'label': label,
    'createdAt': createdAt.toIso8601String(),
  };

  static RemoteDevice fromJson(Map<String, dynamic> json) => RemoteDevice(
    id: json['id'] as String,
    baseUrl: json['baseUrl'] as String,
    params: (json['params'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, v as String),
    ),
    label: json['label'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  RemoteDevice copyWith({String? label}) => RemoteDevice(
    id: id,
    baseUrl: baseUrl,
    params: Map.of(params),
    label: label ?? this.label,
    createdAt: createdAt,
  );
}
