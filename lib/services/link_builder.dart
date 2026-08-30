import 'dart:core';

import 'package:uuid/uuid.dart';

import '../models/device.dart';

class LinkBuilder {
  static const _sidKey = 'sid';
  static const _hashKey = 'hash';
  static const _tKey = 't';
  static const _nameKey = 'name';

  static RemoteDevice? parse(String input, {String? id, DateTime? now}) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;
    if (uri.host.isEmpty) return null;

    final params = <String, String>{};
    uri.queryParameters.forEach((k, v) {
      if (k.isNotEmpty && v.isNotEmpty) params[k] = v;
    });

    final sid = params[_sidKey];
    final hash = params[_hashKey];
    if (sid == null || sid.isEmpty || hash == null || hash.isEmpty) return null;

    final base = uri.hasPort
        ? Uri(
            scheme: uri.scheme,
            userInfo: uri.userInfo,
            host: uri.host,
            port: uri.port,
            path: uri.path,
          )
        : Uri(
            scheme: uri.scheme,
            userInfo: uri.userInfo,
            host: uri.host,
            path: uri.path,
          );

    final label = params[_nameKey];
    return RemoteDevice(
      id: id ?? const Uuid().v4(),
      baseUrl: base.toString(),
      params: params,
      label: label == null || label.isEmpty ? '未命名设备' : label,
      createdAt: now ?? DateTime.now(),
    );
  }

  static Uri buildUrl(RemoteDevice device, {DateTime? now}) {
    final params = Map<String, String>.of(device.params);
    params[_tKey] = (now ?? DateTime.now()).millisecondsSinceEpoch.toString();
    return Uri.parse(device.baseUrl).replace(queryParameters: params);
  }
}
