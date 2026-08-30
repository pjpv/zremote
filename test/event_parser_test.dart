import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/services/event_observer.dart';
import 'package:zremote/models/notification_prefs.dart';
import 'package:zremote/services/notifier.dart';

RemoteDevice _device(String label) => RemoteDevice(
  id: 'dev-1',
  baseUrl: 'https://zcode.z.ai/remote/v4',
  params: const {'sid': 's', 'hash': 'h'},
  label: label,
  createdAt: DateTime(2026, 8, 30),
);

void main() {
  group('EventParser.parseMessage', () {

    test('单事件：permission_request + taskId + title', () {
      const body =
          '{"event":"permission_request","taskId":"t1","title":"Bash","description":"rm -rf build"}';
      final events = EventParser.parseMessage(body);
      expect(events, hasLength(1));
      expect(events.first.type, 'permission_request');
      expect(events.first.taskId, 't1');
      expect(events.first.summary, 'Bash');
    });

    test('嵌套：事件藏在 payload 里，task_id 蛇形命名', () {
      const body = '{"data":{"event":"error","task_id":"x"},"ok":true}';
      final events = EventParser.parseMessage(body);
      expect(events, hasLength(1));
      expect(events.first.type, 'error');
      expect(events.first.taskId, 'x');
    });

    test('数组：多个事件一次识别', () {
      const body = '[{"event":"completed"},{"event":"streaming"}]';
      final events = EventParser.parseMessage(body);
      expect(events.map((e) => e.type), ['completed', 'streaming']);
    });

    test('无关 JSON：不产出事件（含旧枚举名）', () {
      expect(EventParser.parseMessage('{"foo":"bar"}'), isEmpty);
      expect(
        EventParser.parseMessage('{"type":"task_status_changed"}'),
        isEmpty,
      );
    });

    test('非 JSON（SSE 原始帧与 HTML）被拒收', () {
      expect(EventParser.parseMessage('data: {"event":"completed"}'), isEmpty);
      expect(
        EventParser.parseMessage('<html><body>event=error</body></html>'),
        isEmpty,
      );
    });

    test('未知事件名不产出（协议新增需先入枚举表）', () {
      const body = '{"event":"something_new"}';
      expect(EventParser.parseMessage(body), isEmpty);
    });

    test('深嵌套（超过 3 层）不爆栈且不产出', () {
      const body = '{"a":{"b":{"c":{"d":{"event":"error"}}}}}';
      expect(EventParser.parseMessage(body), isEmpty);
    });

    test('elicitation_request 缺 title 时回退 description', () {
      const body =
          '{"event":"elicitation_request","taskId":"t2","description":"选择部署目标"}';
      final events = EventParser.parseMessage(body);
      expect(events, hasLength(1));
      expect(events.first.summary, '选择部署目标');
    });
  });

  group('白名单', () {
    test('kNotifiableTypes 只含四类高价值事件（agent 等待用户动作的都在内）', () {
      expect(kNotifiableTypes, {
        'permission_request',
        'elicitation_request',
        'completed',
        'error',
      });
    });

    test('kKnownEventTypes 覆盖白名单', () {
      for (final t in kNotifiableTypes) {
        expect(kKnownEventTypes.contains(t), isTrue, reason: t);
      }
    });
  });

  group('EventObserver.hookScript', () {
    test('幂等哨兵存在', () {
      expect(EventObserver.hookScript.contains('__zrHooked'), isTrue);
    });

    test('上报走 zrEvents handler', () {
      expect(
        EventObserver.hookScript.contains("callHandler('zrEvents'"),
        isTrue,
      );
    });

    test('EventSource 包装转发类静态量（CONNECTING/OPEN/CLOSED）', () {
      expect(
        EventObserver.hookScript.contains(
          'Wrapped[statics[i]] = OrigES[statics[i]]',
        ),
        isTrue,
      );
      for (final s in const ['CONNECTING', 'OPEN', 'CLOSED']) {
        expect(
          EventObserver.hookScript.contains("'$s'"),
          isTrue,
          reason: '静态量数组应包含 $s',
        );
      }
    });

    test('content-length 体积预检存在（大响应不进内存）', () {
      expect(
        EventObserver.hookScript.contains("res.headers.get('content-length')"),
        isTrue,
      );
    });

    test('WebSocket 包装只监听 message 帧', () {
      final s = EventObserver.hookScript;
      expect(s.contains('window.WebSocket = WSWrapped'), isTrue);
      expect(s.contains('WSWrapped.prototype = OrigWS.prototype'), isTrue);
      expect(
        s.contains('WSWrapped[wsStatics[j]] = OrigWS[wsStatics[j]]'),
        isTrue,
      );
      expect(s.contains("ws.addEventListener('message'"), isTrue);
    });
  });

  group('NotificationSpec.from', () {
    test('permission_request → 标题含设备+会话名，正文讲做什么（非工具名）', () {
      final spec = NotificationSpec.from(
        _device('家里台式机'),
        const ObservedEvent(
          type: 'permission_request',
          sessionTitle: '修复登录页',
          summary: '创建文件 zz-test.txt',
        ),
      )!;
      expect(spec.channelId, 'zr_perm');
      expect(spec.importance, Importance.high);
      expect(spec.priority, Priority.high);
      expect(spec.title, '[家里台式机] 修复登录页 请求批准');
      expect(spec.body, '创建文件 zz-test.txt');
      expect(spec.payload, 'dev-1');
    });

    test('error → 失败渠道/高优先级，带会话名，无摘要用兜底', () {
      final spec = NotificationSpec.from(
        _device('公司MBP'),
        const ObservedEvent(type: 'error', sessionTitle: 'hi'),
      )!;
      expect(spec.channelId, 'zr_fail');
      expect(spec.importance, Importance.high);
      expect(spec.title, '[公司MBP] hi 出错');
      expect(spec.body, '任务失败，回来看看');
    });

    test('completed → 完成渠道/默认优先级；非白名单返回 null', () {
      final done = NotificationSpec.from(
        _device('x'),
        const ObservedEvent(type: 'completed', sessionTitle: 'hi'),
      )!;
      expect(done.channelId, 'zr_done');
      expect(done.importance, Importance.defaultImportance);
      expect(done.title, '[x] hi 已完成');

      expect(
        NotificationSpec.from(
          _device('x'),
          const ObservedEvent(type: 'streaming'),
        ),
        isNull,
      );
    });

    test('会话标题缺省时兜底「会话」', () {
      final spec = NotificationSpec.from(
        _device('x'),
        const ObservedEvent(type: 'permission_request'),
      )!;
      expect(spec.title, '[x] 会话 请求批准');
    });
  });

  group('NotificationSpec.stableId（通知位：设备×类型×会话）', () {
    test('同设备同会话同类型 → 稳定（原位更新不堆叠）', () {
      final a = NotificationSpec.stableId(
        _device('x'),
        const ObservedEvent(type: 'permission_request', taskId: 'sess_1'),
      );
      final b = NotificationSpec.stableId(
        _device('x'),
        const ObservedEvent(
          type: 'permission_request',
          taskId: 'sess_1',
          sessionTitle: '后来才有的标题',
          summary: '描述变化也算同一条',
        ),
      );
      expect(a, b);
    });

    test('同设备不同会话 → 不同位（不得互相顶掉）', () {
      final a = NotificationSpec.stableId(
        _device('x'),
        const ObservedEvent(type: 'permission_request', taskId: 'sess_1'),
      );
      final b = NotificationSpec.stableId(
        _device('x'),
        const ObservedEvent(type: 'permission_request', taskId: 'sess_2'),
      );
      expect(a, isNot(b));
    });

    test('同会话不同类型 → 不同位（审批与追问是两件事）', () {
      final a = NotificationSpec.stableId(
        _device('x'),
        const ObservedEvent(type: 'permission_request', taskId: 'sess_1'),
      );
      final b = NotificationSpec.stableId(
        _device('x'),
        const ObservedEvent(type: 'elicitation_request', taskId: 'sess_1'),
      );
      expect(a, isNot(b));
    });

    test('不同设备 → 不同位；taskId 空参与 hash', () {
      RemoteDevice dev(String id) => RemoteDevice(
        id: id,
        baseUrl: 'https://zcode.z.ai/remote/v4',
        params: const {'sid': 's', 'hash': 'h'},
        label: 'x',
        createdAt: DateTime(2026, 8, 30),
      );
      final a = NotificationSpec.stableId(
        dev('dev-a'),
        const ObservedEvent(type: 'completed', taskId: 'sess_1'),
      );
      final b = NotificationSpec.stableId(
        dev('dev-b'),
        const ObservedEvent(type: 'completed', taskId: 'sess_1'),
      );
      final noTask = NotificationSpec.stableId(
        dev('dev-a'),
        const ObservedEvent(type: 'completed'),
      );
      expect(a, isNot(b));
      expect(a, isNot(noTask));
    });
  });

  group('NotificationPrefs（默认仅审批）', () {
    test('默认值：审批开，完成/失败关', () {
      const prefs = NotificationPrefs();
      expect(prefs.approval, isTrue);
      expect(prefs.complete, isFalse);
      expect(prefs.fail, isFalse);
    });

    test('enabled 映射：审批族共用一个开关位', () {
      const prefs = NotificationPrefs();
      expect(prefs.enabled('permission_request'), isTrue);
      expect(prefs.enabled('elicitation_request'), isTrue);
      expect(prefs.enabled('completed'), isFalse);
      expect(prefs.enabled('error'), isFalse);
      expect(prefs.enabled('unknown'), isFalse);

      const all = NotificationPrefs(
        approval: false,
        complete: true,
        fail: true,
      );
      expect(all.enabled('permission_request'), isFalse);
      expect(all.enabled('completed'), isTrue);
      expect(all.enabled('error'), isTrue);
    });
  });

  group('NotificationTap', () {
    test('无绑定时暂存，consumePending 只消费一次', () {
      NotificationTap.bind(null);
      NotificationTap.route('dev-9');
      expect(NotificationTap.consumePending(), 'dev-9');
      expect(NotificationTap.consumePending(), isNull);
    });

    test('有绑定时直接分发不暂存', () {
      String? received;
      NotificationTap.bind((id) => received = id);
      NotificationTap.route('dev-2');
      expect(received, 'dev-2');
      expect(NotificationTap.consumePending(), isNull);
      NotificationTap.bind(null);
    });

    test('空 payload 忽略', () {
      NotificationTap.route(null);
      NotificationTap.route('');
      expect(NotificationTap.consumePending(), isNull);
    });
  });

  const frameBaseline =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","logicalFrameId":"six-x","topic":"sessions-index/W:\\\\ws\\\\demo","frame":{"topic":"sessions-index/W:\\\\ws\\\\demo","fromSeq":1,"toSeq":2,"payload":{"kind":"deltas","deltas":[{"op":"session.upserted","session":{"sessionId":"sess_b","title":"hi","phase":"running","sessionEnded":false,"hasBackgroundWork":false,"pendingInteraction":null,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0},"lastActivityAt":1}}]}}}';

  const framePermAppears =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","logicalFrameId":"six-y","topic":"sessions-index/W:\\\\ws\\\\demo","frame":{"topic":"sessions-index/W:\\\\ws\\\\demo","fromSeq":2,"toSeq":3,"payload":{"kind":"deltas","deltas":[{"op":"session.upserted","session":{"sessionId":"sess_b","title":"hi","phase":"running","sessionEnded":false,"hasBackgroundWork":false,"pendingInteraction":{"interactionId":"perm_00000000","kind":"permission","toolName":"Write"},"pendingInteractionSummary":{"permissionCount":1,"userInputCount":0},"lastActivityAt":2,"lastAssistantPreview":"[P] ok"}}]}}}';

  const framePermRepeat =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","frame":{"topic":"sessions-index/x","payload":{"kind":"deltas","deltas":[{"op":"session.upserted","session":{"sessionId":"sess_b","title":"hi","phase":"running","sessionEnded":false,"pendingInteraction":{"interactionId":"perm_00000000","kind":"permission","toolName":"Write"},"pendingInteractionSummary":{"permissionCount":1,"userInputCount":0},"lastActivityAt":3}}]}}}';

  const framePermResolved =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","frame":{"topic":"sessions-index/x","payload":{"kind":"deltas","deltas":[{"op":"session.upserted","session":{"sessionId":"sess_b","title":"hi","phase":"running","sessionEnded":false,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0},"lastActivityAt":4}}]}}}';

  const frameUserInput =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","frame":{"topic":"sessions-index/x","payload":{"kind":"deltas","deltas":[{"op":"session.upserted","session":{"sessionId":"sess_c","title":"部署","phase":"running","sessionEnded":false,"pendingInteraction":{"kind":"elicitation"},"pendingInteractionSummary":{"permissionCount":0,"userInputCount":2},"lastActivityAt":5}}]}}}';

  group('SessionStateExtractor + StateDiffer（快照差分）', () {
    test('提取：从逻辑帧嵌套里挖出 session 状态', () {
      final states = SessionStateExtractor.parse(framePermAppears);
      expect(states, hasLength(1));
      expect(states.first.sessionId, 'sess_b');
      expect(states.first.permissionCount, 1);
      expect(states.first.toolName, 'Write');
      expect(states.first.interactionKind, 'permission');
    });

    test('差分：permissionCount 0→1 发 permission_request，带会话标题', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(frameBaseline));
      final events = differ.apply(
        SessionStateExtractor.parse(framePermAppears),
      );
      expect(events, hasLength(1));
      expect(events.first.type, 'permission_request');
      expect(events.first.taskId, 'sess_b');
      expect(events.first.sessionTitle, 'hi');
    });

    test('差分：重复推送同一状态（中继重发）不再发事件', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(frameBaseline));
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      expect(
        differ.apply(SessionStateExtractor.parse(framePermRepeat)),
        isEmpty,
      );
    });

    test('差分：权限解除（1→0）不发事件', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(frameBaseline));
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      expect(
        differ.apply(SessionStateExtractor.parse(framePermResolved)),
        isEmpty,
      );
    });

    test('差分：解除后再次出现（0→1）重新发事件（新一轮权限）', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(frameBaseline));
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      differ.apply(SessionStateExtractor.parse(framePermResolved));
      final again = differ.apply(SessionStateExtractor.parse(framePermAppears));
      expect(again, hasLength(1));
      expect(again.first.type, 'permission_request');
    });

    test('差分：首见即带 userInput 发 elicitation_request', () {
      final differ = StateDiffer();
      final events = differ.apply(SessionStateExtractor.parse(frameUserInput));
      expect(events, hasLength(1));
      expect(events.first.type, 'elicitation_request');
      expect(events.first.taskId, 'sess_c');
    });

    test('差分：首见即带待批准（存量未决）照发', () {
      final differ = StateDiffer();
      final events = differ.apply(
        SessionStateExtractor.parse(framePermAppears),
      );
      expect(events, hasLength(1));
      expect(events.first.type, 'permission_request');
      expect(events.first.sessionTitle, 'hi');
    });

    test('差分：phase 变迁到终态发 completed/error（首见终态不发）', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      const frameDone =
          '{"wireVersion":3,"frame":{"payload":{"deltas":[{"op":"session.upserted",'
          '"session":{"sessionId":"sess_b","title":"hi","phase":"completedSuccess",'
          '"sessionEnded":true,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0}}}]}}}';
      final events = differ.apply(SessionStateExtractor.parse(frameDone));
      expect(events, hasLength(1));
      expect(events.first.type, 'completed');
      expect(events.first.sessionTitle, 'hi');

      final fresh = StateDiffer();
      expect(fresh.apply(SessionStateExtractor.parse(frameDone)), isEmpty);
    });

    test('非 JSON 与无关 JSON 不产出状态', () {
      expect(SessionStateExtractor.parse('data: {...}'), isEmpty);
      expect(SessionStateExtractor.parse('{"foo":1}'), isEmpty);
    });
  });

  group('NotificationGate（会话级抑制）', () {
    test('后台/锁屏：一律提醒（含正在看的会话）', () {
      expect(
        NotificationGate.shouldNotify(
          appForeground: false,
          visibleDeviceId: 'd1',
          eventDeviceId: 'd1',
          activeSessionId: 's1',
          eventSessionId: 's1',
        ),
        isTrue,
      );
    });

    test('前台 + 其他设备：提醒', () {
      expect(
        NotificationGate.shouldNotify(
          appForeground: true,
          visibleDeviceId: 'd1',
          eventDeviceId: 'd2',
          activeSessionId: 's1',
          eventSessionId: 's1',
        ),
        isTrue,
      );
    });

    test('前台 + 同设备 + 另一个会话（A 停 B 待）：提醒', () {
      expect(
        NotificationGate.shouldNotify(
          appForeground: true,
          visibleDeviceId: 'd1',
          eventDeviceId: 'd1',
          activeSessionId: 'sB',
          eventSessionId: 'sA',
        ),
        isTrue,
      );
    });

    test('前台 + 正在看的事件会话本身：不提醒', () {
      expect(
        NotificationGate.shouldNotify(
          appForeground: true,
          visibleDeviceId: 'd1',
          eventDeviceId: 'd1',
          activeSessionId: 'sA',
          eventSessionId: 'sA',
        ),
        isFalse,
      );
    });

    test('事件带不上会话 ID：保守提醒', () {
      expect(
        NotificationGate.shouldNotify(
          appForeground: true,
          visibleDeviceId: 'd1',
          eventDeviceId: 'd1',
          activeSessionId: 'sA',
          eventSessionId: null,
        ),
        isTrue,
      );
    });
  });

  group('ActiveSessionExtractor（bootstrap 与 bridge 帧）', () {
    test('引导帧 mobileViewState.activeTaskId', () {
      const body =
          '{"type":"data","payload":{"requestId":"bootstrap-x","result":'
          '{"mobileViewState":{"activeTaskId":"sess_9238","activeWorkspaceKey":"W"}}}}';
      expect(ActiveSessionExtractor.parse(body), 'sess_9238');
    });

    test('打开会话的 bridge 帧 initialTaskId', () {
      const body =
          '{"type":"data","payload":{"bridge":{"bridgeGeneration":1,'
          '"initialTaskId":"sess_2036","kind":"local","workspaceKey":"W"}}}';
      expect(ActiveSessionExtractor.parse(body), 'sess_2036');
    });

    test('无关消息返回 null', () {
      expect(ActiveSessionExtractor.parse('{"foo":1}'), isNull);
      expect(ActiveSessionExtractor.parse('not json'), isNull);
    });
  });
}
