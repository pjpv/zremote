import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'rpc_dispatch.dart';

class RpcNotReadyException implements Exception {
  const RpcNotReadyException(this.reason);

  final String reason;

  @override
  String toString() => 'RpcNotReadyException($reason)';
}

class RpcTimeoutException implements Exception {
  const RpcTimeoutException(this.label);

  final String label;

  @override
  String toString() => 'RpcTimeoutException($label)';
}

class RpcRemoteException implements Exception {
  const RpcRemoteException(this.label, this.message);

  final String label;
  final String message;

  @override
  String toString() => 'RpcRemoteException($label: $message)';
}

class RpcResponse {
  const RpcResponse({required this.id, required this.values});

  final int id;
  final List<Object?> values;

  Map<String, dynamic>? get firstObject {
    for (final value in values) {
      if (value is Map<String, dynamic>) return value;
    }
    return null;
  }
}

class RpcBridge {
  RpcBridge({required this.deviceId, required this.dispatch});

  static const Map<String, String> _serviceByChannel = {
    'off-peak-task': 'offPeakTaskService',
    'zcode-agent': 'zcodeAgentService',
    'usage-stats': 'usageStatsService',
    'zr-probe': '__zrProbe',
    'coding-plan-subscription': 'codingPlanSubscriptionService',
    'zr-captcha': '__zrCaptcha',
  };

  final String deviceId;

  final RpcDispatch dispatch;

  final Map<int, Completer<RpcResponse>> _pending = {};
  int _nextId = 1;

  bool? _offPeakUpdateTwoArgs;

  Future<RpcResponse> call(
    String channel,
    String method, {
    Object? params,
    Duration timeout = const Duration(seconds: 25),
  }) => callArgs(
    channel,
    method,
    args: params == null ? const [] : [params],
    timeout: timeout,
  );

  Future<RpcResponse> callArgs(
    String channel,
    String method, {
    required List<Object?> args,
    Duration timeout = const Duration(seconds: 25),
  }) async {
    final service = _serviceByChannel[channel];
    if (service == null) {
      throw RpcNotReadyException('unknown channel: $channel');
    }
    final id = _nextId++;
    final argsJson = jsonEncode(args);
    final argsB64 = base64Encode(utf8.encode(argsJson));
    final completer = Completer<RpcResponse>();
    _pending[id] = completer;
    dispatch.push({'i': id, 's': service, 'm': method, 'a': argsB64});
    if (kDebugMode) {
      debugPrint('[zr-diag] -> $channel.$method id=$id port=${dispatch.port}');
    }
    try {
      final response = await completer.future.timeout(timeout);
      if (kDebugMode) {
        debugPrint(
          '[zr-diag] <- $channel.$method id=$id values=${response.values.length}',
        );
      }
      return response;
    } on TimeoutException {
      if (kDebugMode) {
        debugPrint('[zr-diag] !! $channel.$method id=$id TIMEOUT');
      }
      throw RpcTimeoutException('$channel.$method');
    } finally {
      _pending.remove(id);
    }
  }

  void onSvcResult(String body) {
    try {
      final map = jsonDecode(body);
      if (map is! Map) return;
      final id = map['i'];
      if (id is! int) return;
      final completer = _pending.remove(id);
      if (completer == null || completer.isCompleted) return;
      if (map['ok'] == true) {
        final r = map['r'];
        completer.complete(RpcResponse(id: id, values: _valuesOf(r)));
      } else {
        completer.completeError(
          RpcRemoteException('call#$id', '${map['e'] ?? 'unknown'}'),
        );
      }
    } catch (_) {}
  }

  Future<bool> offPeakUpdateTwoArgs({
    Duration timeout = const Duration(seconds: 25),
  }) async {
    final cached = _offPeakUpdateTwoArgs;
    if (cached != null) return cached;
    try {
      await call(
        'off-peak-task',
        'getCodingPlanSupport',
        timeout: timeout,
      );
    } on RpcRemoteException catch (e) {
      if (e.message.contains('no-method')) {
        return _offPeakUpdateTwoArgs = false;
      }
      if (e.message.contains('no-services')) return false;
      return _offPeakUpdateTwoArgs = true;
    } catch (_) {
      return false;
    }
    return _offPeakUpdateTwoArgs = true;
  }

  void resetOffPeakProbe() => _offPeakUpdateTwoArgs = null;

  static List<Object?> _valuesOf(dynamic r) {
    if (r is! String || r.isEmpty || r == 'null') return const [];
    final dynamic decoded;
    try {
      decoded = jsonDecode(r);
    } catch (_) {
      return const [
        {'zrTruncated': true},
      ];
    }
    if (decoded is List) return decoded;
    if (decoded is Map) return [decoded];
    return const [];
  }

  void dispose() {
    _failAllPending(const RpcNotReadyException('bridge disposed'));
  }

  void _failAllPending(Object error) {
    if (_pending.isEmpty) return;
    final pending = Map.of(_pending);
    _pending.clear();
    for (final completer in pending.values) {
      if (!completer.isCompleted) completer.completeError(error);
    }
  }
}
