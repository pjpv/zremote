import 'dart:convert';

import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
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
        EventObserver.hookScript.contains("post('zrEvents'"),
        isTrue,
      );
    });

    test('早桥队列（r8 根因修复）：桥未就绪缓存、就绪后按序冲刷', () {
      final s = EventObserver.hookScript;
      expect(s.contains("addEventListener('flutterInAppWebViewPlatformReady'"),
          isTrue);
      expect(s.contains("post('zrViewState', b)"), isTrue);
      expect(s.contains("post('zrWs', event)"), isTrue);
      expect(s.contains('qMaxEntries'), isTrue);
      expect(s.contains('q.shift()'), isTrue);
      expect(s.contains('clearInterval(flushTimer)'), isTrue);
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

    test('体积上限已常量化为 4MB：4194304 在案、旧值 262144 绝迹', () {
      expect(EventObserver.hookScript.contains('4194304'), isTrue);
      expect(EventObserver.hookScript.contains('262144'), isFalse);
      expect(kMaxListenBytes, 4194304);
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

    test('l10n 缺省回退 zh 模板（冷启动链路安全）', () {
      final spec = NotificationSpec.from(
        _device('x'),
        const ObservedEvent(type: 'completed', sessionTitle: 'hi'),
      )!;
      expect(spec.channelName, '任务完成');
      expect(spec.title, '[x] hi 已完成');
    });

    test('传 en 实例走英文文案；未命名设备本地化兜底', () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      final spec = NotificationSpec.from(
        _device(''),
        const ObservedEvent(type: 'permission_request', sessionTitle: 'hi'),
        l10n,
      )!;
      expect(spec.channelName, 'Approval requests');
      expect(spec.title, '[Unnamed device] hi needs your approval');
      expect(spec.body, 'An agent action is waiting for your approval');
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

  const framePlainC =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","frame":{"topic":"sessions-index/x","payload":{"kind":"deltas","deltas":[{"op":"session.upserted","session":{"sessionId":"sess_c","title":"部署","phase":"running","sessionEnded":false,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0},"lastActivityAt":8}}]}}}';

  const frameRemovedB =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","frame":{"topic":"sessions-index/x","payload":{"kind":"deltas","deltas":[{"op":"session.removed","sessionId":"sess_b"}]}}}';

  const frameUserInput =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","frame":{"topic":"sessions-index/x","payload":{"kind":"deltas","deltas":[{"op":"session.upserted","session":{"sessionId":"sess_c","title":"部署","phase":"running","sessionEnded":false,"pendingInteraction":{"kind":"elicitation"},"pendingInteractionSummary":{"permissionCount":0,"userInputCount":2},"lastActivityAt":5}}]}}}';

  const framePermTwo =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","frame":{"topic":"sessions-index/x","payload":{"kind":"deltas","deltas":[{"op":"session.upserted","session":{"sessionId":"sess_b","title":"hi","phase":"running","sessionEnded":false,"pendingInteractionSummary":{"permissionCount":2,"userInputCount":0},"lastActivityAt":6}}]}}}';

  const frameUserInputResolved =
      '{"wireVersion":3,"kind":"complete","deliveryKind":"online","frame":{"topic":"sessions-index/x","payload":{"kind":"deltas","deltas":[{"op":"session.upserted","session":{"sessionId":"sess_c","title":"部署","phase":"running","sessionEnded":false,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0},"lastActivityAt":7}}]}}}';

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

    test('差分：权限解除（1→0）发 resolved（通知撤回信号）', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(frameBaseline));
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      final events =
          differ.apply(SessionStateExtractor.parse(framePermResolved));
      expect(events, hasLength(1));
      expect(events.first.type, 'resolved');
      expect(events.first.taskId, 'sess_b');
      expect(events.first.sessionTitle, 'hi');
    });

    test('差分：计数下降未归零（2→1）不发 resolved——剩 2 个待审时通知仍有效', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      differ.apply(SessionStateExtractor.parse(framePermTwo));
      expect(
        differ.apply(SessionStateExtractor.parse(framePermAppears)),
        isEmpty,
      );
    });

    test('差分：userInput 归零（2→0）也发 resolved', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(frameUserInput));
      final events =
          differ.apply(SessionStateExtractor.parse(frameUserInputResolved));
      expect(events, hasLength(1));
      expect(events.first.type, 'resolved');
      expect(events.first.taskId, 'sess_c');
    });

    test('resolved 不在通知白名单（家务信号不发系统通知不计未读）', () {
      expect(kNotifiableTypes.contains('resolved'), isFalse);
      expect(kKnownEventTypes.contains('resolved'), isFalse);
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
      expect(events, hasLength(2));
      expect(events.first.type, 'resolved');
      expect(events.last.type, 'completed');
      expect(events.last.sessionTitle, 'hi');

      final fresh = StateDiffer();
      expect(fresh.apply(SessionStateExtractor.parse(frameDone)), isEmpty);
    });

    test('提取：session.removed delta 只带裸 sessionId', () {
      expect(SessionStateExtractor.parseRemoved(frameRemovedB), ['sess_b']);
      expect(SessionStateExtractor.parseRemoved(framePermAppears), isEmpty);
      expect(SessionStateExtractor.parseRemoved('{"foo":1}'), isEmpty);
    });

    test('差分：会话被显式移除且带走未清待办 → 补发 resolved（通知撤回）', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      final events = differ.apply(
        SessionStateExtractor.parse(framePlainC),
        removed: SessionStateExtractor.parseRemoved(frameRemovedB),
      );
      expect(events, hasLength(1));
      expect(events.first.type, 'resolved');
      expect(events.first.taskId, 'sess_b');
    });

    test('差分：无待办的会话移除不发 resolved', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(frameBaseline));
      expect(
        differ.apply(
          const [],
          removed: SessionStateExtractor.parseRemoved(frameRemovedB),
        ),
        isEmpty,
      );
    });

    test('差分：移除未知 sessionId 是 no-op', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      expect(
        differ.apply(const [], removed: ['sess_unknown']),
        isEmpty,
      );
    });

    test('差分：非 sessions-index 帧（空提取）不清空 _prev', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      expect(differ.apply(SessionStateExtractor.parse('{"foo":1}')), isEmpty);
      expect(
        differ.apply(SessionStateExtractor.parse(framePermRepeat)),
        isEmpty,
      );
    });

    test('差分：移除后会话重现 → 按首见处理（重新发待审事件）', () {
      final differ = StateDiffer();
      differ.apply(SessionStateExtractor.parse(framePermAppears));
      differ.apply(
        const [],
        removed: SessionStateExtractor.parseRemoved(frameRemovedB),
      );
      final again = differ.apply(
        SessionStateExtractor.parse(framePermAppears),
      );
      expect(again, hasLength(1));
      expect(again.first.type, 'permission_request');
    });

    test('非 JSON 与无关 JSON 不产出状态', () {
      expect(SessionStateExtractor.parse('data: {...}'), isEmpty);
      expect(SessionStateExtractor.parse('{"foo":1}'), isEmpty);
    });

    test('提取：session.workspaceId 的 basename 进 workspace（Windows 路径）', () {
      const frameWs =
          '{"wireVersion":3,"frame":{"payload":{"deltas":[{"op":"session.upserted",'
          '"session":{"sessionId":"sess_b","workspaceId":"W:\\\\ws\\\\demo",'
          '"title":"hi","phase":"running","sessionEnded":false,'
          '"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0},'
          '"lastActivityAt":1}}]}}}';
      final states = SessionStateExtractor.parse(frameWs);
      expect(states, hasLength(1));
      expect(states.first.workspace, 'demo');
    });

    test('提取：缺 workspaceId 的会话 → workspace null（防御；schema 里必填）', () {
      const frameNoWs =
          '{"wireVersion":3,"frame":{"payload":{"deltas":[{"op":"session.upserted",'
          '"session":{"sessionId":"sess_b","title":"hi","phase":"running",'
          '"sessionEnded":false,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0}}}]}}}';
      final states = SessionStateExtractor.parse(frameNoWs);
      expect(states, hasLength(1));
      expect(states.first.workspace, isNull);
    });

    test('提取：一帧内两个会话不同 workspaceId → 各归各的 basename（逐对象归属）', () {
      const frameTwoWs =
          '{"wireVersion":3,"frame":{"payload":{"kind":"deltas","deltas":['
          '{"op":"session.upserted","session":{"sessionId":"sess_a1",'
          '"workspaceId":"D:\\\\a\\\\alpha","title":"a","phase":"running",'
          '"sessionEnded":false,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0}}},'
          '{"op":"session.upserted","session":{"sessionId":"sess_b1",'
          '"workspaceId":"D:\\\\b\\\\beta","title":"b","phase":"running",'
          '"sessionEnded":false,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0}}}'
          ']}}}';
      final states = SessionStateExtractor.parse(frameTwoWs);
      expect(states, hasLength(2));
      final byId = {for (final s in states) s.sessionId: s};
      expect(byId['sess_a1']?.workspace, 'alpha');
      expect(byId['sess_b1']?.workspace, 'beta');
    });

    test('workspaceBasenameOf：取最后一个 / 或 \\\\ 之后的末段并 trim，取不到则 null', () {
      expect(
        SessionStateExtractor.workspaceBasenameOf('W:\\ws\\demo'),
        'demo',
      );
      expect(
        SessionStateExtractor.workspaceBasenameOf('/home/ubuntu/proj'),
        'proj',
      );
      expect(SessionStateExtractor.workspaceBasenameOf('edai-web'), 'edai-web');
      expect(
        SessionStateExtractor.workspaceBasenameOf('  D:\\x\\app  '),
        'app',
      );
      expect(SessionStateExtractor.workspaceBasenameOf('D:\\tmp\\app\\'), isNull);
      expect(SessionStateExtractor.workspaceBasenameOf('   '), isNull);
      expect(SessionStateExtractor.workspaceBasenameOf(''), isNull);
      expect(SessionStateExtractor.workspaceBasenameOf(null), isNull);
    });

    test('提取：lastActivityAt 时间戳进 SessionState（面板相对排序用）', () {
      const frameLaa =
          '{"wireVersion":3,"frame":{"payload":{"deltas":[{"op":"session.upserted",'
          '"session":{"sessionId":"sess_b","title":"hi","phase":"running",'
          '"sessionEnded":false,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0},'
          '"lastActivityAt":1712345678}}]}}}';
      final states = SessionStateExtractor.parse(frameLaa);
      expect(states, hasLength(1));
      expect(states.first.lastActivityAt, 1712345678);
    });

    test('提取：无 lastActivityAt 键的会话 → null（视为最旧）', () {
      const frameNoLaa =
          '{"wireVersion":3,"frame":{"payload":{"deltas":[{"op":"session.upserted",'
          '"session":{"sessionId":"sess_b","title":"hi","phase":"running",'
          '"sessionEnded":false,"pendingInteractionSummary":{"permissionCount":0,"userInputCount":0}}}]}}}';
      final states = SessionStateExtractor.parse(frameNoLaa);
      expect(states, hasLength(1));
      expect(states.first.lastActivityAt, isNull);
    });
  });

  const frameTaskIndex =
      '{"topic":"controller/tasks-index","subscriptionId":"sub-1","logEpoch":"e1",'
      '"fromSeq":13475,"toSeq":13476,"sentAt":1788195468226,'
      '"payload":{"kind":"deltas","deltas":[{"op":"task.upserted","task":{'
      '"address":{"workspacePath":"W:\\\\ws\\\\demo","taskId":"sess_c13ed748-1"},'
      '"meta":{"taskId":"sess_c13ed748-1","traceId":"tr-1",'
      '"title":"思考常用且實用的擴充功能","titleOverridden":false,'
      '"workspacePath":"W:\\\\ws\\\\demo","createdAt":1788166101996,'
      '"updatedAt":1788196159419,"mode":"build","model":"…","thoughtLevel":"max",'
      '"provider":"glm","status":"running","target":null},'
      '"membership":{"pinned":false,"archived":false,"active":true},'
      '"sourceAvailability":"online","liveStatus":"running",'
      '"activity":{"phase":"running","lastActivityAt":1788196159419,"hasBackgroundWork":false}}}]}}';

  group('TaskIndexExtractor（controller/tasks-index，跨项目全量）', () {
    test('解析完整帧：id/title/workspace/lastActivityAt/phase/pinned 全映射', () {
      final states = TaskIndexExtractor.parse(frameTaskIndex);
      expect(states, hasLength(1));
      final s = states.single;
      expect(s.sessionId, 'sess_c13ed748-1');
      expect(s.title, '思考常用且實用的擴充功能');
      expect(s.workspace, 'demo');
      expect(s.lastActivityAt, 1788196159419);
      expect(s.phase, 'running');
      expect(s.pinned, isFalse);
      expect(s.permissionCount, 0);
      expect(s.userInputCount, 0);
      expect(s.interactionKind, isNull);
    });

    test('membership.pinned=true → pinned（「已置顶」数据源）', () {
      const framePinned =
          '{"payload":{"deltas":[{"op":"task.upserted","task":{'
          '"address":{"workspacePath":"D:\\\\a\\\\alpha","taskId":"sess_p1"},'
          '"meta":{"taskId":"sess_p1","title":"置顶的","status":"running"},'
          '"membership":{"pinned":true,"archived":false,"active":true},'
          '"activity":{"phase":"running","lastActivityAt":5}}}]}}';
      final states = TaskIndexExtractor.parse(framePinned);
      expect(states, hasLength(1));
      expect(states.single.pinned, isTrue);
    });

    test('membership.archived=true → 不 upsert（评审 r6：面板幽灵行）', () {
      const frameArchived =
          '{"payload":{"deltas":[{"op":"task.upserted","task":{'
          '"address":{"taskId":"sess_arc1"},'
          '"meta":{"taskId":"sess_arc1","title":"归档的","status":"running",'
          '"updatedAt":7},'
          '"membership":{"pinned":false,"archived":true,"active":false}}}]}}';
      expect(TaskIndexExtractor.parse(frameArchived), isEmpty);
    });

    test('parseArchived：archived 任务的 id 以移除信号吐出（摘既有条目）', () {
      const frameArchived =
          '{"payload":{"deltas":['
          '{"op":"task.upserted","task":{'
          '"address":{"taskId":"sess_arc1"},'
          '"membership":{"pinned":false,"archived":true}}},'
          '{"op":"task.upserted","task":{'
          '"address":{"taskId":"sess_ok1"},'
          '"membership":{"pinned":false,"archived":false}}}]}}';
      expect(TaskIndexExtractor.parseArchived(frameArchived), ['sess_arc1']);
      expect(TaskIndexExtractor.parseArchived(frameTaskIndex), isEmpty);
      expect(TaskIndexExtractor.parseArchived('{"foo":1}'), isEmpty);
      expect(TaskIndexExtractor.parseArchived('not json'), isEmpty);
    });

    test('parseRemoved：task.removed op（schema 判别联合）→ address.taskId', () {
      const frameRemoved =
          '{"payload":{"deltas":['
          '{"op":"task.removed","address":{"taskId":"sess_gone1",'
          '"workspacePath":"D:\\\\a\\\\alpha","remoteSessionId":"local"}},'
          '{"op":"task.upserted","task":{'
          '"address":{"taskId":"sess_ok1"},'
          '"membership":{"pinned":false,"archived":false}}}]}}';
      expect(TaskIndexExtractor.parseRemoved(frameRemoved), ['sess_gone1']);
      expect(TaskIndexExtractor.parseRemoved(frameTaskIndex), isEmpty);
      expect(TaskIndexExtractor.parseRemoved('{"foo":1}'), isEmpty);
      expect(TaskIndexExtractor.parseRemoved('not json'), isEmpty);
    });

    test('meta.createdAt 映射（比较器主键 + 合并源）', () {
      final states = TaskIndexExtractor.parse(frameTaskIndex);
      expect(states.single.createdAt, 1788166101996);
    });

    test('parseSnapshot：kind:snapshot 的裸 task 数组全解析（跨 workspace 全量回放）', () {
      const frameSnapshot =
          '{"topic":"controller/tasks-index","subscriptionId":"sub-9",'
          '"payload":{"kind":"snapshot","snapshot":{'
          '"protocolVersion":1,"logEpoch":"e1","tasks":['
          '{"address":{"workspacePath":"D:\\\\proj\\\\alpha","taskId":"sess_ws_a"},'
          '"meta":{"taskId":"sess_ws_a","title":"跨项目A","status":"running",'
          '"createdAt":10,"updatedAt":11},'
          '"membership":{"pinned":false,"archived":false,"active":true}},'
          '{"address":{"workspacePath":"E:\\\\beta","taskId":"sess_ws_b"},'
          '"meta":{"taskId":"sess_ws_b","title":"跨项目B","status":"completed",'
          '"createdAt":20,"updatedAt":22},'
          '"membership":{"pinned":true,"archived":false,"active":true}},'
          '{"address":{"workspacePath":"E:\\\\beta","taskId":"sess_ws_arc"},'
          '"meta":{"taskId":"sess_ws_arc","title":"归档的不进面板",'
          '"createdAt":30,"updatedAt":31},'
          '"membership":{"pinned":false,"archived":true,"active":false}}]}}}';
      final snap = TaskIndexExtractor.parseSnapshot(frameSnapshot);
      expect(snap, isNotNull);
      expect(snap, hasLength(2));
      final a = snap![0];
      expect(a.sessionId, 'sess_ws_a');
      expect(a.title, '跨项目A');
      expect(a.workspace, 'alpha');
      expect(a.phase, 'running');
      expect(a.createdAt, 10);
      final b = snap[1];
      expect(b.sessionId, 'sess_ws_b');
      expect(b.workspace, 'beta');
      expect(b.pinned, isTrue);
    });

    test('parseSnapshot：delta 帧与垃圾输入 → null（非 snapshot 不得误判）', () {
      expect(TaskIndexExtractor.parseSnapshot(frameTaskIndex), isNull);
      expect(TaskIndexExtractor.parseSnapshot('{"foo":1}'), isNull);
      expect(TaskIndexExtractor.parseSnapshot('not json'), isNull);
    });

    test('parseResultTasks：bootstrap/workspace-list RPC 回应的扁平 task 视图（每次连接必到）', () {
      const frameBootstrap =
          '{"type":"data","payload":{"requestId":"bootstrap-6fe039fb",'
          '"result":{"mobileViewState":{"activeTaskId":"sess_cur",'
          '"activeWorkspaceKey":"W:\\\\ws\\\\demo"},'
          '"tasks":['
          '{"createdAt":1788231444628,"displayStatus":"running","provider":"glm",'
          '"taskId":"sess_cur","title":"代码审查","updatedAt":1788246960324,'
          '"workspaceKind":"local","workspaceLabel":"demo",'
          '"workspacePath":"W:\\\\ws\\\\demo"},'
          '{"createdAt":1788166101996,"displayStatus":"completed","provider":"glm",'
          '"taskId":"sess_other","title":"跨项目任务","updatedAt":1788226114094,'
          '"workspaceKind":"local","workspaceLabel":"ai-meeting",'
          '"workspacePath":"D:\\\\work\\\\ai-meeting"}]}}}';
      final tasks = TaskIndexExtractor.parseResultTasks(frameBootstrap);
      expect(tasks, isNotNull);
      expect(tasks, hasLength(2));
      final cur = tasks![0];
      expect(cur.sessionId, 'sess_cur');
      expect(cur.phase, 'running');
      expect(cur.lastActivityAt, 1788246960324);
      expect(cur.createdAt, 1788231444628);
      expect(cur.workspace, 'demo');
      final other = tasks[1];
      expect(other.sessionId, 'sess_other');
      expect(other.phase, 'completedSuccess');
      expect(other.workspace, 'ai-meeting');
    });

    test('parseResultTasks：无 result.tasks 的消息 → null', () {
      expect(TaskIndexExtractor.parseResultTasks(frameTaskIndex), isNull);
      expect(TaskIndexExtractor.parseResultTasks('{"foo":1}'), isNull);
      expect(TaskIndexExtractor.parseResultTasks('not json'), isNull);
      expect(
        TaskIndexExtractor.parseResultTasks('{"payload":{"result":{"x":1}}}'),
        isNull,
      );
    });

    test('isBootstrapResult：requestId 前缀判定（评审 r10 抽纯函数）', () {
      const frameBootstrap =
          '{"payload":{"requestId":"bootstrap-e6b0b12f-9989","result":{"tasks":[]}}}';
      const frameWorkspaceList =
          '{"payload":{"requestId":"workspace-list-9cf57a9a","result":{"tasks":[]}}}';
      expect(
        TaskIndexExtractor.isBootstrapResult(jsonDecode(frameBootstrap)),
        isTrue,
      );
      expect(
        TaskIndexExtractor.isBootstrapResult(jsonDecode(frameWorkspaceList)),
        isFalse,
      );
      expect(TaskIndexExtractor.isBootstrapResult(null), isFalse);
      expect(TaskIndexExtractor.isBootstrapResult(jsonDecode('{"x":1}')),
          isFalse);
      expect(
        TaskIndexExtractor.isBootstrapResult(
          jsonDecode('{"payload":{"result":{"tasks":[]}}}'),
        ),
        isFalse,
      );
    });

    test('activity 缺失 → phase 走 meta.status 映射，时间走 meta.updatedAt', () {
      const frameNoActivity =
          '{"payload":{"deltas":[{"op":"task.upserted","task":{'
          '"address":{"taskId":"sess_d1"},'
          '"meta":{"taskId":"sess_d1","title":"完成的","status":"completed",'
          '"updatedAt":1234567890123}}}]}}';
      final states = TaskIndexExtractor.parse(frameNoActivity);
      expect(states, hasLength(1));
      expect(states.single.phase, 'completedSuccess');
      expect(states.single.lastActivityAt, 1234567890123);
      expect(states.single.workspace, isNull);
    });

    test('两流正交：tasks-index 帧不喂 SessionStateExtractor，反之亦然', () {
      expect(SessionStateExtractor.parse(frameTaskIndex), isEmpty);
      expect(SessionStateExtractor.parseRemoved(frameTaskIndex), isEmpty);
      expect(TaskIndexExtractor.parse(frameBaseline), isEmpty);
    });

    test('无 task.upserted 的消息与非 JSON → 空', () {
      expect(TaskIndexExtractor.parse('{"foo":1}'), isEmpty);
      expect(TaskIndexExtractor.parse('not json'), isEmpty);
    });
  });

  group('MobileViewStateSync（mobile-view-state POST 请求体）', () {

    test('带 taskId（打开任务）→ valid + taskId', () {
      const body =
          '{"activeWorkspaceKey":"W:\\\\ws\\\\demo","activeTaskId":"sess_abc",'
          '"updatedAt":1756632000000}';
      final r = MobileViewStateSync.parse(body);
      expect(r.valid, isTrue);
      expect(r.taskId, 'sess_abc');
    });

    test('不带 taskId（回到任务列表）→ valid + null（清锚点信号）', () {
      const body =
          '{"activeWorkspaceKey":"W:\\\\ws\\\\demo","updatedAt":1756632000001}';
      final r = MobileViewStateSync.parse(body);
      expect(r.valid, isTrue);
      expect(r.taskId, isNull);
    });

    test('非 JSON / 非对象 / 缺 activeWorkspaceKey → 无信号（不清锚）', () {
      expect(MobileViewStateSync.parse('not json').valid, isFalse);
      expect(MobileViewStateSync.parse('[]').valid, isFalse);
      expect(MobileViewStateSync.parse('{"foo":1}').valid, isFalse);
      expect(MobileViewStateSync.parse('{"activeTaskId":"x"}').valid, isFalse);
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

    test('conversation/<sessionId> topic 即正在查看的会话', () {
      const body =
          '{"topic":"conversation/sess_c13ed748-1","subscriptionId":"sub-1",'
          '"fromSeq":9,"payload":{}}';
      expect(ActiveSessionExtractor.parse(body), 'sess_c13ed748-1');
    });

    test('同一帧内 conversation 胜过列表选择镜像（mobileViewState 老值）', () {
      const body =
          '{"topic":"conversation/sess_new","payload":{"result":'
          '{"mobileViewState":{"activeTaskId":"sess_old"}}}}';
      expect(ActiveSessionExtractor.parse(body), 'sess_new');
    });

    test('conversation/ 空 id 不作信号，回落其他信号', () {
      const body =
          '{"topic":"conversation/","payload":{"bridge":'
          '{"initialTaskId":"sess_fb"}}}';
      expect(ActiveSessionExtractor.parse(body), 'sess_fb');
    });
  });
}
