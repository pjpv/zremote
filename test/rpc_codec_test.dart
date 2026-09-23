import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/rpc_codec.dart';

void main() {
  group('crc32 已知向量', () {
    test('"123456789" == 0xCBF43926', () {
      expect(RpcCodec.crc32(utf8.encode('123456789')), 0xCBF43926);
    });

    test('空串 == 0', () {
      expect(RpcCodec.crc32(const []), 0);
      expect(RpcCodec.crc32Hex(const []), '00000000');
    });

    test('hex 输出 8 位小写补零', () {
      expect(
        RpcCodec.crc32Hex(utf8.encode('123456789')),
        'cbf43926',
      );
    });
  });

  group('varint LEB128', () {
    test('往返：0/1/127/128/103/152/4447/大值', () {
      final builder = BytesBuilder();
      for (final v in [0, 1, 127, 128, 103, 152, 201, 4447, 16384, 100103]) {
        RpcCodec.writeVarint(builder, v);
      }
      final bytes = builder.toBytes();
      var offset = 0;
      for (final v in [0, 1, 127, 128, 103, 152, 201, 4447, 16384, 100103]) {
        final (value, next) = RpcCodec.readVarint(bytes, offset);
        expect(value, v);
        expect(next, greaterThan(offset));
        offset = next;
      }
      expect(offset, bytes.length);
    });

    test('截断 varint 抛 FormatException', () {
      expect(
        () => RpcCodec.readVarint(Uint8List.fromList([0x80]), 0),
        throwsFormatException,
      );
    });
  });

  group('黄金请求帧（实抓字节级）', () {
    test('listAllAutomations(seq 102) 逐字节相等 + 信封字段', () {
      final envelope = RpcCodec.buildRpcEnvelope(
        bridgeSessionId: 'bridge-402f6e75-7a65-40c3-9202-bc39f8f4d57a',
        bridgeGeneration: 1,
        seq: 102,
        channel: 'zcode-agent',
        method: 'listAllAutomations',
        params: null,
      );
      final env = jsonDecode(envelope) as Map<String, dynamic>;
      expect(env['type'], 'data');
      final payload = env['payload'] as Map<String, dynamic>;
      expect(payload['zcode_type'], 'rpc-frame');
      expect(payload['bridgeSessionId'], 'bridge-402f6e75-7a65-40c3-9202-bc39f8f4d57a');
      expect(payload['bridgeGeneration'], 1);
      expect(payload['seq'], 102);
      expect(payload['messageSeq'], 102);
      expect(payload['fragmentIndex'], 0);
      expect(payload['fragmentCount'], 1);
      expect(payload['messageBytes'], 41);
      final checksum = payload['checksum'] as Map<String, dynamic>;
      expect(checksum['algorithm'], 'crc32');
      expect(checksum['value'], '23b2bc5f');

      final bytes = base64Decode(payload['dataBase64'] as String);
      final golden = Uint8List.fromList([
        0x04, 0x04,
        0x06, 0x64,
        0x06, 0x67,
        0x01, 0x0b, ...utf8.encode('zcode-agent'),
        0x01, 0x12, ...utf8.encode('listAllAutomations'),
        0x04, 0x00,
      ]);
      expect(bytes, golden);
      expect(RpcCodec.crc32Hex(bytes), '23b2bc5f');
    });

    test('pauseTask(seq 153) 字符串参数帧（帧 id 154 = varint 9a 01）', () {
      const taskId = 'offpeak-bc72781e-3886-4e11-99c6-f9dc04ad343b';
      final envelope = RpcCodec.buildRpcEnvelope(
        bridgeSessionId: 'bridge-402f6e75-7a65-40c3-9202-bc39f8f4d57a',
        bridgeGeneration: 1,
        seq: 153,
        channel: 'off-peak-task',
        method: 'pauseTask',
        params: taskId,
      );
      final payload =
          (jsonDecode(envelope) as Map<String, dynamic>)['payload']
              as Map<String, dynamic>;
      final bytes = base64Decode(payload['dataBase64'] as String);
      final golden = Uint8List.fromList([
        0x04, 0x04,
        0x06, 0x64,
        0x06, 0x9a, 0x01,
        0x01, 0x0d, ...utf8.encode('off-peak-task'),
        0x01, 0x09, ...utf8.encode('pauseTask'),
        0x04, 0x01, 0x01, 0x2c, ...utf8.encode(taskId),
      ]);
      expect(bytes, golden);
      expect(payload['messageBytes'], 4 + 3 + 2 + 13 + 2 + 9 + 4 + 44);
    });

    test('对象参数帧：04 01 05 + varint 长度 + 紧凑 JSON', () {
      final envelope = RpcCodec.buildRpcEnvelope(
        bridgeSessionId: 'bridge-x',
        bridgeGeneration: 2,
        seq: 10,
        channel: 'zcode-agent',
        method: 'createAutomation',
        params: {
          'workspacePath': r'J:\tmp\demo',
          'title': 'T',
          'cronExpr': '0 9 * * *',
          'prompt': 'P',
          'recurring': true,
        },
      );
      final payload =
          (jsonDecode(envelope) as Map<String, dynamic>)['payload']
              as Map<String, dynamic>;
      final bytes = base64Decode(payload['dataBase64'] as String);
      final json = jsonEncode({
        'workspacePath': r'J:\tmp\demo',
        'title': 'T',
        'cronExpr': '0 9 * * *',
        'prompt': 'P',
        'recurring': true,
      });
      final golden = Uint8List.fromList([
        0x04, 0x04, 0x06, 0x64, 0x06, 0x0b,
        0x01, 0x0b, ...utf8.encode('zcode-agent'),
        0x01, 0x10, ...utf8.encode('createAutomation'),
        0x04, 0x01, 0x05, ..._varint(utf8.encode(json).length),
        ...utf8.encode(json),
      ]);
      expect(bytes, golden);
    });

    test('不支持的参数类型抛 ArgumentError', () {
      expect(
        () => RpcCodec.buildRpcEnvelope(
          bridgeSessionId: 'b',
          bridgeGeneration: 1,
          seq: 1,
          channel: 'c',
          method: 'm',
          params: 42,
        ),
        throwsArgumentError,
      );
    });
  });

  group('响应解析', () {
    test('实抓黄金：off-peak list 空列表 = void（9 字节）', () {
      const voidHex = '040206c90106690400';
      final r = RpcCodec.parseRpcResponseBytes(
        Uint8List.fromList(_hex(voidHex)),
      );
      expect(r.id, 105);
      expect(r.values, isEmpty);
    });

    test('实抓黄金：getTakeNumberAvailability 单 JSON（帧 id 107）', () {
      const hex = '040206c901066b05167b2263616e54616b654e756d626572223a747275657d';
      final r = RpcCodec.parseRpcResponseBytes(Uint8List.fromList(_hex(hex)));
      expect(r.id, 107);
      expect(r.values, [
        {'canTakeNumber': true},
      ]);
    });

    test('单 JSON 值（帧 id 121）', () {
      final json = jsonEncode({'automationId': 'automation-1'});
      final frame = Uint8List.fromList([
        0x04, 0x02, 0x06, 0xc9, 0x01,
        0x06, 0x79,
        0x05, ..._varint(utf8.encode(json).length), ...utf8.encode(json),
      ]);
      final r = RpcCodec.parseRpcResponseBytes(frame);
      expect(r.id, 121);
      expect(r.values, [
        {'automationId': 'automation-1'},
      ]);
    });

    test('void（00）', () {
      const hex = '040206c901067700';
      final r = RpcCodec.parseRpcResponseBytes(Uint8List.fromList(_hex(hex)));
      expect(r.id, 119);
      expect(r.values, isEmpty);
    });

    test('聚合多对象串排（04 02 + 两个 05 JSON）→ values.length == 2', () {
      final json1 = jsonEncode({
        'automationId': 'automation-a93b0a7e-8133-4253-bc0a-3abac72fd50c',
        'title': '取证-定时任务-可删除',
        'cronExpr': '0 9 * * *',
        'enabled': true,
      });
      final json2 = jsonEncode({
        'automationId': 'automation-58d29f5c-5b20-46a7-926a-540d26179f40',
        'title': '取证-定时2点关机',
        'cronExpr': '0 2 * * *',
        'enabled': false,
      });
      final frame = Uint8List.fromList([
        0x04, 0x02, 0x06, 0xc9, 0x01,
        0x06, 0x79,
        0x04, 0x02,
        0x05, ..._varint(utf8.encode(json1).length), ...utf8.encode(json1),
        0x05, ..._varint(utf8.encode(json2).length), ...utf8.encode(json2),
      ]);
      final r = RpcCodec.parseRpcResponseBytes(frame);
      expect(r.id, 121);
      expect(r.values.length, 2);
      expect((r.values[0] as Map)['automationId'], contains('a93b0a7e'));
      expect((r.values[1] as Map)['automationId'], contains('58d29f5c'));
    });

    test('单元素聚合（04 01 + JSON）——实抓 listAllAutomations 形态', () {
      final json = jsonEncode({'automationId': 'automation-x'});
      final frame = Uint8List.fromList([
        0x04, 0x02, 0x06, 0xc9, 0x01,
        0x06, 0x67,
        0x04, 0x01,
        0x05, ..._varint(utf8.encode(json).length), ...utf8.encode(json),
      ]);
      final r = RpcCodec.parseRpcResponseBytes(frame);
      expect(r.id, 103);
      expect(r.values, [
        {'automationId': 'automation-x'},
      ]);
    });

    test('实抓黄金(09-12)：禁用中的定时任务全字段（含转义/反斜杠/中文）', () {
      final json = jsonEncode({
        'automationId': 'automation-58d29f5c-5b20-46a7-926a-540d26179f40',
        'title': '每日定时关机',
        'cronExpr': '0 2 * * *',
        'prompt': '这是用于主动关机的定时任务 2 点准时关机,会先取消未完成任务,'
            '再等三十秒后执行 `shutdown -s -t 0` 关机 Windows 计算机。'
            '随后自动检查状态,失败则重试 `shutdown //s //t 0`(git bash 兼容)。'
            '最后确认任务已"完成"。',
        'model': 'builtin:bigmodel-coding-plan/GLM-5.3-Flash',
        'provider': 'glm',
        'mode': 'yolo',
        'thoughtLevel': 'max',
        'workspaceKey': r'J:\tmp\zcode-switch',
        'workspacePath': r'J:\tmp\zcode-switch',
        'targetTaskId': 'sess_13867078-190a-470a-b927-ea714571d67f',
        'locationKind': 'local',
        'recurring': true,
        'runCount': 6,
        'enabled': false,
        'lifecycleStatus': 'paused',
        'nextRunAt': 1788976800000,
        'lastRunAt': 1788890419105,
        'dispatchStatus': 'dispatched',
        'dispatchAttempts': 0,
        'createdAt': 1788278799948,
        'updatedAt': 1788914850126,
      });
      final frame = Uint8List.fromList([
        0x04, 0x02, 0x06, 0xc9, 0x01,
        0x06, 0x67,
        0x04, 0x01,
        0x05, ..._varint(utf8.encode(json).length), ...utf8.encode(json),
      ]);
      final r = RpcCodec.parseRpcResponseBytes(frame);
      expect(r.id, 103);
      expect(r.values.length, 1);
      final obj = r.values[0] as Map<String, dynamic>;
      expect(obj['automationId'], contains('automation-58d29f5c'));
      expect(obj['title'], '每日定时关机');
      expect(obj['enabled'], isFalse);
      expect(obj['lifecycleStatus'], 'paused');
      expect(obj['model'], 'builtin:bigmodel-coding-plan/GLM-5.3-Flash');
      expect(obj['workspacePath'], r'J:\tmp\zcode-switch');
    });

    test('非 04 02 头抛 FormatException', () {
      expect(
        () => RpcCodec.parseRpcResponseBytes(
          Uint8List.fromList([0x04, 0x04, 0x06, 0x64, 0x06, 0x01, 0x00]),
        ),
        throwsFormatException,
      );
    });
  });

  group('0x7B 长度 varint 回归（评审 r1：JS 切片起点走 TLV 结构）', () {
    test('123 字节载荷（单字节 varint 0x7B）经新切片路径解析出正确对象', () {
      const json =
          '{"offPeakTaskId":"offpeak-bc72781e-3886-4e11-99c6-f9dc04ad343b",'
          '"status":"queued","title":"task-title-exactly-30-chars-xx"}';
      expect(utf8.encode(json), hasLength(123));

      final frame = Uint8List.fromList([
        0x04, 0x02, 0x06, 0xc9, 0x01,
        0x06, ..._varint(100103),
        0x04, 0x01,
        0x05, 0x7b, ...utf8.encode(json),
      ]);
      final parsed = RpcCodec.parseRpcResponseBytes(frame);
      expect(parsed.id, 100103);
      expect(parsed.values, [jsonDecode(json)]);

      final text = utf8.decode(frame, allowMalformed: true);
      final (_, afterFrameId) = RpcCodec.readVarint(frame, 6);
      var i = afterFrameId;
      expect(frame[i], 0x04);
      expect(frame[i + 1], 0x01);
      i += 2;
      expect(frame[i], 0x05);
      i += 1;
      expect(frame[i], 0x7b);
      i += 1;
      final values = RpcCodec.parseConcatenatedJsonText(text.substring(i));
      expect(values, [jsonDecode(json)]);

      final oldStart = text.indexOf('{');
      expect(oldStart, i - 1);
      expect(
        RpcCodec.parseConcatenatedJsonText(text.substring(oldStart)),
        isEmpty,
      );
    });
  });

  group('串排 JSON 文本解析', () {
    test('两个相邻对象全部提取', () {
      const text = '{"a":1}{"b":{"c":2}}';
      final values = RpcCodec.parseConcatenatedJsonText(text);
      expect(values.length, 2);
      expect(values[0], {'a': 1});
      expect(values[1], {
        'b': {'c': 2},
      });
    });

    test('字符串字面量内的花括号不干扰配平', () {
      const text = '{"prompt":"a } b { c"}{"d":2}';
      final values = RpcCodec.parseConcatenatedJsonText(text);
      expect(values.length, 2);
      expect(values[0], {'prompt': 'a } b { c'});
      expect(values[1], {'d': 2});
    });

    test('转义引号后仍正确配平', () {
      const text = r'{"s":"x\"y{}"}{}';
      final values = RpcCodec.parseConcatenatedJsonText(text);
      expect(values.length, 2);
      expect(values[0], {'s': 'x"y{}'});
      expect(values[1], <String, dynamic>{});
    });

    test('垃圾尾巴：完整对象保留，截断对象放弃', () {
      const text = '{"ok":1}{"trunc';
      final values = RpcCodec.parseConcatenatedJsonText(text);
      expect(values, [
        {'ok': 1},
      ]);
    });

    test('二进制头（首 { 之前）被忽略', () {
      const text = '\u0004\u0002x\u0006{"ok":1}';
      final values = RpcCodec.parseConcatenatedJsonText(text);
      expect(values, [
        {'ok': 1},
      ]);
    });

    test('空文本/无对象 → 空列表', () {
      expect(RpcCodec.parseConcatenatedJsonText(''), isEmpty);
      expect(RpcCodec.parseConcatenatedJsonText('no json here'), isEmpty);
    });
  });
}

List<int> _varint(int v) {
  final out = <int>[];
  var value = v;
  while (value >= 0x80) {
    out.add((value & 0x7F) | 0x80);
    value >>= 7;
  }
  out.add(value);
  return out;
}

List<int> _hex(String hex) => [
  for (var i = 0; i < hex.length; i += 2)
    int.parse(hex.substring(i, i + 2), radix: 16),
];
