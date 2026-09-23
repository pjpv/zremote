import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/rpc_bridge.dart';
import 'package:zremote/services/rpc_dispatch.dart';

class _FakeDispatch implements RpcDispatch {
  final List<Map<String, Object?>> commands = [];

  @override
  int get port => 47832;

  @override
  Future<void> start() async {}

  @override
  void push(Map<String, Object?> command) => commands.add(command);

  @override
  void dispose() {}
}

({int id, String svc, String method, Object? args}) callOf(
  Map<String, Object?> command,
) {
  final args = jsonDecode(utf8.decode(base64Decode(command['a']! as String)));
  return (
    id: command['i']! as int,
    svc: command['s']! as String,
    method: command['m']! as String,
    args: args,
  );
}

void main() {
  test('call 派发：argsB64 内含 service/method/参数', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    final pending = bridge.call('zcode-agent', 'listAllAutomations');
    await pumpEventQueue();
    final c = callOf(dispatch.commands.single);
    expect(c.svc, 'zcodeAgentService');
    expect(c.method, 'listAllAutomations');
    expect(c.args, isEmpty);
    bridge.onSvcResult(
      jsonEncode({
        'i': c.id,
        'ok': true,
        'r': jsonEncode([
          {'automationId': 'a1'},
        ]),
      }),
    );
    final response = await pending;
    expect(response.id, c.id);
    expect(response.firstObject, {'automationId': 'a1'});
  });

  test('未知频道 → RpcNotReadyException（不进派发层）', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    await expectLater(
      bridge.call('no-such-channel', 'x'),
      throwsA(isA<RpcNotReadyException>()),
    );
    expect(dispatch.commands, isEmpty);
  });

  test('字符串参数（taskId）进 args 首元素；超时摘除 pending', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    final pending = bridge.call(
      'off-peak-task',
      'pauseTask',
      params: 't1',
      timeout: const Duration(milliseconds: 50),
    );
    await pumpEventQueue();
    final c = callOf(dispatch.commands.single);
    expect(c.method, 'pauseTask');
    expect(c.args, ['t1']);
    await expectLater(pending, throwsA(isA<RpcTimeoutException>()));
    bridge.onSvcResult(jsonEncode({'i': c.id, 'ok': true, 'r': 'null'}));
  });

  test('对象参数进 args 首元素；返回数组原样入 values', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    final pending = bridge.call(
      'zcode-agent',
      'createAutomation',
      params: {'title': "It's 中文", 'n': 1},
    );
    await pumpEventQueue();
    final c = callOf(dispatch.commands.single);
    expect(c.args, [
      {'title': "It's 中文", 'n': 1},
    ]);
    bridge.onSvcResult(
      jsonEncode({
        'i': c.id,
        'ok': true,
        'r': jsonEncode([
          {'automationId': 'a1'},
          {'automationId': 'a2'},
        ]),
      }),
    );
    final response = await pending;
    expect(response.values, hasLength(2));
  });

  test('host 失败（promise reject）→ RpcRemoteException 携带消息', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    final pending = bridge.call('zcode-agent', 'setAutomationEnabled');
    await pumpEventQueue();
    final c = callOf(dispatch.commands.single);
    bridge.onSvcResult(
      jsonEncode({
        'i': c.id,
        'ok': false,
        'e': 'Provided value cannot be bound to SQLite parameter 4.',
      }),
    );
    await expectLater(
      pending,
      throwsA(
        isA<RpcRemoteException>().having(
          (e) => e.message,
          'message',
          contains('SQLite'),
        ),
      ),
    );
  });

  test('void 返回（r=null）→ 空 values；截断载荷给 zrTruncated 标记', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    final p1 = bridge.call('off-peak-task', 'deleteTask', params: 't9');
    await pumpEventQueue();
    final c1 = callOf(dispatch.commands[0]);
    bridge.onSvcResult(jsonEncode({'i': c1.id, 'ok': true}));
    final r1 = await p1;
    expect(r1.values, isEmpty);

    final p2 = bridge.call('off-peak-task', 'deleteTask', params: 't8');
    await pumpEventQueue();
    final c2 = callOf(dispatch.commands[1]);
    bridge.onSvcResult(
      jsonEncode({'i': c2.id, 'ok': true, 'r': '{"broken": tr'}),
    );
    final r2 = await p2;
    expect((r2.values.single as Map)['zrTruncated'], isTrue);
  });

  test('重复/无关 id 不炸：迟到回执与双重投递静默忽略', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    final pending = bridge.call('zcode-agent', 'listAllAutomations');
    await pumpEventQueue();
    final c = callOf(dispatch.commands.single);
    bridge.onSvcResult(jsonEncode({'i': 999, 'ok': true, 'r': '[]'}));
    bridge.onSvcResult(jsonEncode({'i': c.id, 'ok': true, 'r': '[]'}));
    bridge.onSvcResult(jsonEncode({'i': c.id, 'ok': true, 'r': '[]'}));
    final response = await pending;
    expect(response.values, isEmpty);
  });

  test('dispose：在途调用 fail-fast', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    final pending = bridge.call('zcode-agent', 'listAllAutomations');
    await Future<void>.delayed(Duration.zero);
    bridge.dispose();
    await expectLater(pending, throwsA(isA<RpcNotReadyException>()));
  });

  test('callArgs：多参进 args 数组（3.14 两参 updateTask）', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    final pending = bridge.callArgs(
      'off-peak-task',
      'updateTask',
      args: [
        't-1',
        {'title': '改名'},
      ],
    );
    await pumpEventQueue();
    final c = callOf(dispatch.commands.single);
    expect(c.svc, 'offPeakTaskService');
    expect(c.method, 'updateTask');
    expect(c.args, [
      't-1',
      {'title': '改名'},
    ]);
    bridge.onSvcResult(
      jsonEncode({
        'i': c.id,
        'ok': true,
        'r': jsonEncode([
          {'offPeakTaskId': 't-1'},
        ]),
      }),
    );
    final response = await pending;
    expect(response.firstObject, {'offPeakTaskId': 't-1'});
  });

  test('callArgs：未知频道同样 RpcNotReadyException', () async {
    final dispatch = _FakeDispatch();
    final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
    await expectLater(
      bridge.callArgs('no-such-channel', 'x', args: const []),
      throwsA(isA<RpcNotReadyException>()),
    );
    expect(dispatch.commands, isEmpty);
  });

  group('offPeakUpdateTwoArgs 代际探测（3.14 对齐）', () {
    test('getCodingPlanSupport 成功 → 新代（true）且缓存', () async {
      final dispatch = _FakeDispatch();
      final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
      final probing = bridge.offPeakUpdateTwoArgs();
      await pumpEventQueue();
      final c = callOf(dispatch.commands.single);
      expect(c.svc, 'offPeakTaskService');
      expect(c.method, 'getCodingPlanSupport');
      bridge.onSvcResult(
        jsonEncode({
          'i': c.id,
          'ok': true,
          'r': jsonEncode([
            {'supported': false},
          ]),
        }),
      );
      expect(await probing, isTrue);
      expect(await bridge.offPeakUpdateTwoArgs(), isTrue);
      expect(dispatch.commands, hasLength(1));
    });

    test('host 业务报错（方法在）→ 新代（true）', () async {
      final dispatch = _FakeDispatch();
      final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
      final probing = bridge.offPeakUpdateTwoArgs();
      await pumpEventQueue();
      final c = callOf(dispatch.commands.single);
      bridge.onSvcResult(
        jsonEncode({'i': c.id, 'ok': false, 'e': 'subscription unavailable'}),
      );
      expect(await probing, isTrue);
    });

    test('no-method → 旧代（false）且缓存', () async {
      final dispatch = _FakeDispatch();
      final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
      final probing = bridge.offPeakUpdateTwoArgs();
      await pumpEventQueue();
      final c = callOf(dispatch.commands.single);
      bridge.onSvcResult(jsonEncode({'i': c.id, 'ok': false, 'e': 'no-method'}));
      expect(await probing, isFalse);
      expect(await bridge.offPeakUpdateTwoArgs(), isFalse);
      expect(dispatch.commands, hasLength(1));
    });

    test('no-services（页面未就绪）→ 默认旧代且不缓存，下次再探', () async {
      final dispatch = _FakeDispatch();
      final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
      final probing = bridge.offPeakUpdateTwoArgs();
      await pumpEventQueue();
      final c1 = callOf(dispatch.commands.single);
      bridge.onSvcResult(jsonEncode({'i': c1.id, 'ok': false, 'e': 'no-services'}));
      expect(await probing, isFalse);
      final probing2 = bridge.offPeakUpdateTwoArgs();
      await pumpEventQueue();
      expect(dispatch.commands, hasLength(2));
      final c2 = callOf(dispatch.commands[1]);
      bridge.onSvcResult(jsonEncode({'i': c2.id, 'ok': true, 'r': 'null'}));
      expect(await probing2, isTrue);
    });

    test('探测超时（传输层失败）→ 默认旧代且不缓存', () async {
      final dispatch = _FakeDispatch();
      final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
      final probing = bridge.offPeakUpdateTwoArgs(
        timeout: const Duration(milliseconds: 50),
      );
      await pumpEventQueue();
      expect(await probing, isFalse);
      final probing2 = bridge.offPeakUpdateTwoArgs(
        timeout: const Duration(milliseconds: 50),
      );
      await pumpEventQueue();
      expect(dispatch.commands, hasLength(2));
      expect(await probing2, isFalse);
    });

    test('resetOffPeakProbe：页面重载后缓存失效重探', () async {
      final dispatch = _FakeDispatch();
      final bridge = RpcBridge(deviceId: 'd1', dispatch: dispatch);
      final probing = bridge.offPeakUpdateTwoArgs();
      await pumpEventQueue();
      final c = callOf(dispatch.commands.single);
      bridge.onSvcResult(
        jsonEncode({
          'i': c.id,
          'ok': true,
          'r': jsonEncode([
            {'supported': true},
          ]),
        }),
      );
      expect(await probing, isTrue);
      bridge.resetOffPeakProbe();
      final probing2 = bridge.offPeakUpdateTwoArgs();
      await pumpEventQueue();
      expect(dispatch.commands, hasLength(2));
      final c2 = callOf(dispatch.commands[1]);
      bridge.onSvcResult(jsonEncode({'i': c2.id, 'ok': false, 'e': 'no-method'}));
      expect(await probing2, isFalse);
    });
  });

  group('LoopbackDispatchServer（真 socket，页面侧模拟）', () {
    test('长轮询：命令即时整批送达 + 空批 CORS 头', () async {
      final server = LoopbackDispatchServer(
        hold: const Duration(milliseconds: 200),
      );
      addTearDown(server.dispose);
      await server.start();
      expect(server.port, greaterThan(0));
      final client = HttpClient();
      addTearDown(client.close);

      final poll = client.getUrl(
        Uri.parse('http://127.0.0.1:${server.port}${server.pollPath}'),
      );
      final held = await poll.then((r) => r.close()).then((r) async {
        return (r, await r.transform(const Utf8Decoder()).join());
      });
      expect(held.$2, '{"c":[]}');
      expect(held.$1.headers.value('Access-Control-Allow-Origin'), '*');

      final pendingPoll = _poll(client, server.port, server.pollPath);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      server.push({
        'i': 7,
        's': 'zcodeAgentService',
        'm': 'listAllAutomations',
        'a': 'W10=',
      });
      final body = await pendingPoll;
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final batch = decoded['c'] as List;
      expect(batch, hasLength(1));
      expect(batch.first['i'], 7);
      expect(batch.first['m'], 'listAllAutomations');
    });

    test('OPTIONS 预检：CORS + Private Network Access 放行', () async {
      final server = LoopbackDispatchServer();
      addTearDown(server.dispose);
      await server.start();
      final client = HttpClient();
      addTearDown(client.close);
      final request = await client.openUrl(
        'OPTIONS',
        Uri.parse('http://127.0.0.1:${server.port}${server.pollPath}'),
      );
      final response = await request.close();
      expect(response.statusCode, 204);
      expect(
        response.headers.value('Access-Control-Allow-Private-Network'),
        'true',
      );
      expect(response.headers.value('Access-Control-Allow-Origin'), '*');
    });

    test('404 兜底 + 重复 start 幂等', () async {
      final server = LoopbackDispatchServer();
      addTearDown(server.dispose);
      await server.start();
      final port = server.port;
      await server.start();
      expect(server.port, port);
      final client = HttpClient();
      addTearDown(client.close);
      final response = await client
          .getUrl(Uri.parse('http://127.0.0.1:$port/nope'))
          .then((r) => r.close());
      expect(response.statusCode, 404);
      final tokenless = await client
          .getUrl(Uri.parse('http://127.0.0.1:$port/poll'))
          .then((r) => r.close());
      expect(tokenless.statusCode, 404);
    });
  });
}

Future<String> _poll(
  HttpClient client,
  int port,
  String pollPath,
) async {
  final request = await client.getUrl(
    Uri.parse('http://127.0.0.1:$port$pollPath'),
  );
  final response = await request.close();
  return response.transform(const Utf8Decoder()).join();
}
