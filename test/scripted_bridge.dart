import 'dart:async';
import 'dart:convert';

import 'package:zremote/services/rpc_bridge.dart';
import 'package:zremote/services/rpc_dispatch.dart';

class ScriptedBridge {
  ScriptedBridge({this.script = const [], this.errors = const {}}) {
    _dispatch.onCommand = _onCommand;
  }

  final List<List<Map<String, dynamic>>> script;

  final Map<int, String> errors;

  final _FakeDispatch _dispatch = _FakeDispatch();
  late final RpcBridge bridge = RpcBridge(deviceId: 'd1', dispatch: _dispatch);

  List<Map<String, Object?>> get commands => _dispatch.commands;

  int _calls = 0;

  void _onCommand(Map<String, Object?> command) {
    final id = command['i']! as int;
    final index = _calls++;
    final error = errors[index];
    final hasValue = index < script.length;
    if (error == null && !hasValue) return;
    final r = hasValue ? jsonEncode(script[index]) : null;
    scheduleMicrotask(() {
      scheduleMicrotask(() {
        bridge.onSvcResult(jsonEncode(error == null
            ? {'i': id, 'ok': true, 'r': r}
            : {'i': id, 'ok': false, 'e': error}));
      });
    });
  }

  void deliver(String body) => bridge.onSvcResult(body);
}

class _FakeDispatch implements RpcDispatch {
  final List<Map<String, Object?>> commands = [];
  void Function(Map<String, Object?> command)? onCommand;

  @override
  int get port => 47832;

  @override
  Future<void> start() async {}

  @override
  void push(Map<String, Object?> command) {
    commands.add(command);
    onCommand?.call(command);
  }

  @override
  void dispose() {}
}

({String channel, String method, Object? params}) requestOf(
  Map<String, Object?> command,
) {
  final svcToChannel = {
    'offPeakTaskService': 'off-peak-task',
    'zcodeAgentService': 'zcode-agent',
    'usageStatsService': 'usage-stats',
    'codingPlanSubscriptionService': 'coding-plan-subscription',
    '__zrCaptcha': 'zr-captcha',
  };
  final channel = svcToChannel[command['s']] ?? command['s']! as String;
  final args = argsOf(command);
  final params = args.isNotEmpty ? args.first : null;
  return (channel: channel, method: command['m']! as String, params: params);
}

List<Object?> argsOf(Map<String, Object?> command) {
  final args = jsonDecode(utf8.decode(base64Decode(command['a']! as String)));
  return args is List ? args : [args];
}
