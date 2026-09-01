import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/state/session_status.dart';

void main() {
  group('RelayLedPolicy.onFrame', () {
    test('外层 data 帧 → live', () {
      const frame =
          '{"type":"data","payload":{"zcode_type":"rpc-frame","seq":1}}';
      expect(RelayLedPolicy.onFrame(frame), SessionStatus.live);
    });

    test('外层 data 帧（内层会话快照装载）→ live', () {
      const frame =
          '{"type":"data","payload":{"kind":"binary","dataBase64":"eyJ3aXJlVmVyc2lvbiI6M30="}}';
      expect(RelayLedPolicy.onFrame(frame), SessionStatus.live);
    });

    test('in-band error 帧：终态 code → error', () {
      for (final code in const ['KICKED', 'AUTH_FAILED', 'WRONG_PARAM']) {
        expect(
          RelayLedPolicy.onFrame('{"type":"error","code":"$code"}'),
          SessionStatus.error,
          reason: 'code=$code',
        );
      }
      expect(
        RelayLedPolicy.onFrame('{"type":"error","code":"MYSTERY"}'),
        SessionStatus.error,
        reason: '未知 code 走官方默认终局分支',
      );
    });

    test('in-band error 帧：可恢复 code 不改状态', () {
      expect(
        RelayLedPolicy.onFrame('{"type":"error","code":"DEVICE_OFFLINE"}'),
        isNull,
      );
      expect(
        RelayLedPolicy.onFrame('{"type":"error","code":"INTERNAL"}'),
        isNull,
      );
    });

    test('内层解包 JSON（fetch 之外的附加上报）不改状态', () {
      const inner =
          '{"wireVersion":3,"kind":"complete","deliveryKind":"online"}';
      expect(RelayLedPolicy.onFrame(inner), isNull);
    });

    test('非 JSON 与空串不改状态', () {
      expect(RelayLedPolicy.onFrame('not json {'), isNull);
      expect(RelayLedPolicy.onFrame(''), isNull);
    });

    test('JSON 数组/标量不改状态', () {
      expect(RelayLedPolicy.onFrame('[1,2,3]'), isNull);
      expect(RelayLedPolicy.onFrame('"data"'), isNull);
    });
  });

  group('RelayLedPolicy.onWsEvent', () {
    const relay = 'wss://relay.example/ws/remote/abc';
    const relayRoot = 'wss://relay.example/ws';
    const windowSocket = 'wss://relay.example/ws/remote-control/window/tok';

    test('open → loading（连接中）', () {
      expect(
        RelayLedPolicy.onWsEvent({'s': 'open', 'u': relay}),
        SessionStatus.loading,
      );
    });

    test('根 /ws 路径也算中继传输', () {
      expect(
        RelayLedPolicy.onWsEvent({'s': 'open', 'u': relayRoot}),
        SessionStatus.loading,
      );
    });

    test('窗口控制旁路 socket 的事件忽略', () {
      expect(
        RelayLedPolicy.onWsEvent({'s': 'open', 'u': windowSocket}),
        isNull,
      );
      expect(
        RelayLedPolicy.onWsEvent({'s': 'closed', 'u': windowSocket, 'r': ''}),
        isNull,
      );
    });

    test('缺 URL 的事件忽略（防御：旧载荷形状）', () {
      expect(RelayLedPolicy.onWsEvent({'s': 'open'}), isNull);
    });

    test('关闭原因命中终态集 → error', () {
      for (final reason in const [
        'desktop-disconnected',
        'relay closed: desktop-bootstrap-timeout exceeded',
        'session-expired',
        'kicked by another connection',
      ]) {
        expect(
          RelayLedPolicy.onWsEvent({'s': 'closed', 'u': relay, 'r': reason}),
          SessionStatus.error,
          reason: 'reason=$reason',
        );
      }
    });

    test('普通关闭（无原因/中性原因）→ loading（等待重连）', () {
      expect(
        RelayLedPolicy.onWsEvent(
          {'s': 'closed', 'u': relay, 'c': 1006, 'r': ''},
        ),
        SessionStatus.loading,
      );
      expect(
        RelayLedPolicy.onWsEvent({'s': 'closed', 'u': relay}),
        SessionStatus.loading,
      );
    });

    test('未知事件类型不改状态', () {
      expect(RelayLedPolicy.onWsEvent({'s': 'error', 'u': relay}), isNull);
      expect(RelayLedPolicy.onWsEvent(<String, dynamic>{}), isNull);
    });
  });

  group('PageLoadPolicy', () {
    test('网络层错误：仅主文档计为页面错误', () {
      expect(PageLoadPolicy.isMainDocFailure(true), isTrue);
      expect(PageLoadPolicy.isMainDocFailure(false), isFalse,
          reason: '子资源抖动（统计脚本断连等）不得染指 LED/横幅');
      expect(PageLoadPolicy.isMainDocFailure(null), isFalse,
          reason: '平台实现缺值时按非主文档处理——宁漏报不误报');
    });

    test('HTTP 错误：主文档且 >= 400', () {
      expect(PageLoadPolicy.isHttpFailure(true, 404), isTrue);
      expect(PageLoadPolicy.isHttpFailure(true, 500), isTrue);
      expect(PageLoadPolicy.isHttpFailure(true, 302), isFalse);
      expect(PageLoadPolicy.isHttpFailure(false, 500), isFalse);
      expect(PageLoadPolicy.isHttpFailure(true, null), isFalse);
    });
  });
}
