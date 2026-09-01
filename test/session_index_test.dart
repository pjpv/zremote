import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/event_observer.dart';
import 'package:zremote/state/session_index.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  SessionState sess(
    String id, {
    String? title,
    String? phase,
    bool? sessionEnded,
    int permissionCount = 0,
    int userInputCount = 0,
    int? lastActivityAt,
    int? createdAt,
    String? workspace,
    bool pinned = false,
  }) => SessionState(
    sessionId: id,
    title: title,
    phase: phase,
    sessionEnded: sessionEnded,
    permissionCount: permissionCount,
    userInputCount: userInputCount,
    lastActivityAt: lastActivityAt,
    createdAt: createdAt,
    workspace: workspace,
    pinned: pinned,
  );

  group('SessionRanking.compareSessions（比較器鏈：running 置頂）', () {
    test('running 恆置頂：壓過更新的非 running', () {
      final runningOld = sess('r1', phase: 'running', lastActivityAt: 10, createdAt: 10);
      final doneNew = sess(
        'd1',
        phase: 'completedSuccess',
        lastActivityAt: 999,
        createdAt: 999,
      );
      expect(SessionRanking.compareSessions(runningOld, doneNew), isNegative);
      expect(SessionRanking.compareSessions(doneNew, runningOld), isPositive);
    });

    test('prewarming 不置頂（只認 running；prewarming 組是另一列表）', () {
      final prewarm = sess('p1', phase: 'prewarming', lastActivityAt: 1);
      final done = sess('d1', phase: 'completedSuccess', lastActivityAt: 999);
      expect(SessionRanking.compareSessions(prewarm, done), isPositive);
      expect(SessionRanking.compareSessions(done, prewarm), isNegative);
    });

    test('running 組內：createdAt 降序（不比 lastActivityAt）', () {
      final createdFirst = sess(
        'r_old',
        phase: 'running',
        createdAt: 100,
        lastActivityAt: 999,
      );
      final createdLater = sess(
        'r_new',
        phase: 'running',
        createdAt: 200,
        lastActivityAt: 1,
      );
      expect(
        SessionRanking.compareSessions(createdLater, createdFirst),
        isNegative,
      );
    });

    test('running 組內 createdAt 同值 → sessionId 字典序', () {
      final a = sess('sess_a', phase: 'running', createdAt: 7);
      final b = sess('sess_b', phase: 'running', createdAt: 7);
      expect(SessionRanking.compareSessions(a, b), isNegative);
      expect(SessionRanking.compareSessions(b, a), isPositive);
      expect(SessionRanking.compareSessions(a, a), isZero);
    });

    test('非 running 組：lastActivityAt 降序（Sue updated 主鍵）', () {
      final old = sess('a', phase: 'completedSuccess', lastActivityAt: 100);
      final recent = sess('b', phase: 'completedSuccess', lastActivityAt: 200);
      expect(SessionRanking.compareSessions(recent, old), isNegative);
      expect(SessionRanking.compareSessions(old, recent), isPositive);
    });

    test('非 running 組 lastActivityAt null 視為最舊', () {
      final noStamp = sess('a');
      final stamped = sess('b', phase: 'error', lastActivityAt: 1);
      expect(SessionRanking.compareSessions(stamped, noStamp), isNegative);
      expect(SessionRanking.compareSessions(noStamp, stamped), isPositive);
    });

    test('非 running 組 lastActivityAt 同值 → createdAt 降序二級（Sue tie 鏈）', () {
      final createdOld = sess('a', lastActivityAt: 7, createdAt: 100);
      final createdNew = sess('b', lastActivityAt: 7, createdAt: 200);
      expect(SessionRanking.compareSessions(createdNew, createdOld), isNegative);
    });

    test('非 running 組主鍵+createdAt 全同 → sessionId 字典序兜底（保證全序）', () {
      final a = sess('sess_a', phase: 'error', lastActivityAt: 7, createdAt: 7);
      final b = sess('sess_b', phase: 'error', lastActivityAt: 7, createdAt: 7);
      expect(SessionRanking.compareSessions(a, b), isNegative);
      expect(SessionRanking.compareSessions(b, a), isPositive);
      expect(SessionRanking.compareSessions(a, a), isZero);
    });

    test('待辦不置頂：冷卻組內純時間序', () {
      final pendingOld = sess('old_pending', permissionCount: 3, lastActivityAt: 10);
      final plainRecent = sess('new_plain', lastActivityAt: 20);
      expect(SessionRanking.compareSessions(plainRecent, pendingOld), isNegative);
      expect(SessionRanking.compareSessions(pendingOld, plainRecent), isPositive);
    });

    test('排序可用於 List.sort 且結果穩定（混合序全鏈）', () {
      final list = [
        sess('c', lastActivityAt: null),
        sess('b', lastActivityAt: 300),
        sess('a', lastActivityAt: 100),
        sess('d', lastActivityAt: 200),
        sess('e', lastActivityAt: 300),
        sess('r1', phase: 'running', lastActivityAt: 1, createdAt: 50),
      ]..sort(SessionRanking.compareSessions);
      expect(list.map((s) => s.sessionId).toList(), [
        'r1',
        'b', 'e',
        'd',
        'a',
        'c',
      ]);
    });
  });

  group('RelativeTime.format（词形：刚刚/N分钟/N小时/N天，无「前」）', () {
    test('null lastActivityAt → 刚刚', () {
      expect(RelativeTime.format(null, 1000), (kind: 'now', n: 0));
    });

    test('59 秒 → 刚刚；61 秒 → 1分钟', () {
      const nowMs = 10 * 60 * 1000;
      expect(RelativeTime.format(nowMs - 59 * 1000, nowMs), (kind: 'now', n: 0));
      expect(
        RelativeTime.format(nowMs - 61 * 1000, nowMs),
        (kind: 'minute', n: 1),
      );
    });

    test('59 分钟 → 59分钟', () {
      const nowMs = 10 * 3600 * 1000;
      expect(
        RelativeTime.format(nowMs - 59 * 60 * 1000, nowMs),
        (kind: 'minute', n: 59),
      );
    });

    test('61 分钟 → 1小时；23 小时 → 23小时', () {
      const nowMs = 10 * 3600 * 1000;
      expect(
        RelativeTime.format(nowMs - 61 * 60 * 1000, nowMs),
        (kind: 'hour', n: 1),
      );
      expect(
        RelativeTime.format(nowMs - 23 * 3600 * 1000, nowMs),
        (kind: 'hour', n: 23),
      );
    });

    test('25 小时 → 1天', () {
      const nowMs = 48 * 3600 * 1000;
      expect(
        RelativeTime.format(nowMs - 25 * 3600 * 1000, nowMs),
        (kind: 'day', n: 1),
      );
    });

    test('未来值（时钟偏移）→ 刚刚', () {
      expect(RelativeTime.format(2000, 1000), (kind: 'now', n: 0));
    });
  });

  group('SessionGrouping.groupByDay（本地日历日差，null 归最后 unknown 组）', () {
    test('现在/昨天/3天前/null 混合 → 组序 [today, yesterday, day:3, unknown]', () {
      final now = DateTime(2026, 8, 31, 15, 0);
      final nowMs = now.millisecondsSinceEpoch;
      final hour = 3600 * 1000;
      final list = [
        sess('recent', lastActivityAt: nowMs - hour),
        sess('stale', lastActivityAt: nowMs - 72 * hour),
        sess('none', lastActivityAt: null),
        sess('yday', lastActivityAt: nowMs - 24 * hour),
      ];
      final groups = SessionGrouping.groupByDay(list, now);
      expect(groups.map((g) => g.key).toList(), [
        'today',
        'day:3',
        'unknown',
        'yesterday',
      ]);
    });

    test('排好序的输入：组序 [today, yesterday, day:3, thisWeek, unknown] 且同组保序', () {
      final now = DateTime(2026, 9, 4, 12, 0);
      final nowMs = now.millisecondsSinceEpoch;
      final hour = 3600 * 1000;
      final list = [
        sess('a1', lastActivityAt: nowMs - 5 * 60 * 1000),
        sess('a2', lastActivityAt: nowMs - hour),
        sess('b1', lastActivityAt: nowMs - 24 * hour),
        sess('c1', lastActivityAt: nowMs - 72 * hour),
        sess('w1', lastActivityAt: nowMs - 96 * hour),
        sess('z1', lastActivityAt: null),
      ]..sort(SessionRanking.compareSessions);
      final groups = SessionGrouping.groupByDay(list, now);
      expect(groups.map((g) => g.key).toList(), [
        'today',
        'yesterday',
        'day:3',
        'thisWeek',
        'unknown',
      ]);
      expect(groups[0].value.map((s) => s.sessionId), ['a1', 'a2']);
      expect(groups[1].value.map((s) => s.sessionId), ['b1']);
      expect(groups[2].value.map((s) => s.sessionId), ['c1']);
      expect(groups[3].value.map((s) => s.sessionId), ['w1']);
      expect(groups[4].value.map((s) => s.sessionId), ['z1']);
    });

    test('週一起算：上週六歸 lastWeek（日差 5，越過本週一邊界）', () {
      final now = DateTime(2026, 9, 4, 12, 0);
      final saturday = DateTime(2026, 8, 30, 12, 0).millisecondsSinceEpoch;
      final groups = SessionGrouping.groupByDay(
        [sess('s', lastActivityAt: saturday)],
        now,
      );
      expect(groups.single.key, 'lastWeek');
    });

    test('週日起算（en-US）：同一週六歸 thisWeek（本週起始 = 08-30 週日）', () {
      final now = DateTime(2026, 9, 4, 12, 0);
      final saturday = DateTime(2026, 8, 30, 12, 0).millisecondsSinceEpoch;
      final groups = SessionGrouping.groupByDay(
        [sess('s', lastActivityAt: saturday)],
        now,
        weekStartsMonday: false,
      );
      expect(groups.single.key, 'thisWeek');
    });

    test('跨過上週邊界 → thisMonth / lastMonth / older', () {
      final now = DateTime(2026, 9, 15, 12, 0);
      int at(int y, int m, int d) =>
          DateTime(y, m, d, 12, 0).millisecondsSinceEpoch;
      final groups = SessionGrouping.groupByDay(
        [
          sess('in_month', lastActivityAt: at(2026, 9, 5)),
          sess('last_month', lastActivityAt: at(2026, 8, 20)),
          sess('ancient', lastActivityAt: at(2026, 5, 1)),
        ],
        now,
      );
      expect(groups.map((g) => g.key).toList(), [
        'thisMonth',
        'lastMonth',
        'older',
      ]);
    });

    test('未来时间戳（时钟偏移）归 today', () {
      final now = DateTime(2026, 8, 31, 15, 0);
      final list = [
        sess('future', lastActivityAt: now.millisecondsSinceEpoch + 60000),
      ];
      final groups = SessionGrouping.groupByDay(list, now);
      expect(groups.single.key, 'today');
    });

    test('跨日历日但不足 24h（昨日 23:59 → 今日 00:01）归 yesterday', () {
      final now = DateTime(2026, 8, 31, 0, 1);
      final lastNight = DateTime(2026, 8, 30, 23, 59).millisecondsSinceEpoch;
      final groups = SessionGrouping.groupByDay(
        [sess('late', lastActivityAt: lastNight)],
        now,
      );
      expect(groups.single.key, 'yesterday');
    });

    test('pinned 组排最前，其余按日分组不变；组内保序', () {
      final now = DateTime(2026, 8, 31, 15, 0);
      final nowMs = now.millisecondsSinceEpoch;
      const hour = 3600 * 1000;
      final list = [
        sess('today1', lastActivityAt: nowMs - hour),
        sess('pinned1', lastActivityAt: nowMs - 72 * hour, pinned: true),
        sess('yday1', lastActivityAt: nowMs - 24 * hour),
        sess('pinned2', lastActivityAt: nowMs - 96 * hour, pinned: true),
      ]..sort(SessionRanking.compareSessions);
      final groups = SessionGrouping.groupByDay(list, now);
      expect(groups.map((g) => g.key).toList(), [
        'pinned',
        'today',
        'yesterday',
      ]);
      expect(groups[0].value.map((s) => s.sessionId).toList(), [
        'pinned1',
        'pinned2',
      ]);
    });

    test('无 pinned → 无 pinned 组（旧行为不变）', () {
      final now = DateTime(2026, 8, 31, 15, 0);
      final groups = SessionGrouping.groupByDay(
        [sess('a', lastActivityAt: now.millisecondsSinceEpoch)],
        now,
      );
      expect(groups.map((g) => g.key).toList(), ['today']);
    });
  });

  group('SessionIndexNotifier', () {
    test('upsertAll 空列表 no-op（state 不变）', () {
      final notifier = container.read(sessionIndexProvider.notifier);
      notifier.upsertAll('d1', const []);
      expect(container.read(sessionIndexProvider), isEmpty);
    });

    test('首见 upsert 建设备条目', () {
      final notifier = container.read(sessionIndexProvider.notifier);
      notifier.upsertAll('d1', [sess('s1', phase: 'running')]);
      expect(container.read(sessionIndexProvider)['d1']?['s1']?.phase,
          'running');
    });

    test('同 sessionId 二次 upsert 覆盖旧状态', () {
      final notifier = container.read(sessionIndexProvider.notifier);
      notifier.upsertAll('d1', [sess('s1', phase: 'running')]);
      notifier.upsertAll('d1', [
        sess('s1', phase: 'running', permissionCount: 2, lastActivityAt: 9),
      ]);
      final s = container.read(sessionIndexProvider)['d1']?['s1'];
      expect(s?.permissionCount, 2);
      expect(s?.lastActivityAt, 9);
    });

    test('多设备互不串扰', () {
      final notifier = container.read(sessionIndexProvider.notifier);
      notifier.upsertAll('d1', [sess('s1', phase: 'running')]);
      notifier.upsertAll('d2', [sess('s2', phase: 'error')]);
      expect(
        container.read(sessionIndexProvider)['d1']?.keys,
        ['s1'],
      );
      expect(
        container.read(sessionIndexProvider)['d2']?.keys,
        ['s2'],
      );
    });

    test('removeSessions 移除指定 sessionId', () {
      final notifier = container.read(sessionIndexProvider.notifier);
      notifier.upsertAll('d1', [sess('s1'), sess('s2')]);
      notifier.removeSessions('d1', ['s1']);
      expect(
        container.read(sessionIndexProvider)['d1']?.keys,
        ['s2'],
      );
    });

    test('移除后该设备 map 为空则设备条目也清掉', () {
      final notifier = container.read(sessionIndexProvider.notifier);
      notifier.upsertAll('d1', [sess('s1')]);
      notifier.removeSessions('d1', ['s1']);
      expect(container.read(sessionIndexProvider).containsKey('d1'), isFalse);
    });

    test('removeSessions 未知 sessionId 是 no-op', () {
      final notifier = container.read(sessionIndexProvider.notifier);
      notifier.upsertAll('d1', [sess('s1')]);
      notifier.removeSessions('d1', ['sess_unknown']);
      expect(container.read(sessionIndexProvider)['d1']?.keys, ['s1']);
    });

    test('forget 清整设备条目；未知 deviceId no-op', () {
      final notifier = container.read(sessionIndexProvider.notifier);
      notifier.upsertAll('d1', [sess('s1')]);
      notifier.upsertAll('d2', [sess('s2')]);
      notifier.forget('d1');
      expect(container.read(sessionIndexProvider).containsKey('d1'), isFalse);
      expect(container.read(sessionIndexProvider)['d2']?.keys, ['s2']);
      notifier.forget('d_unknown');
      expect(container.read(sessionIndexProvider).containsKey('d2'), isTrue);
    });

    group('upsertTasks（tasks-index 全量底座，覆盖缺口修复）', () {
      test('无既有条目 → 原样插入（含 pinned/workspace/createdAt）', () {
        final notifier = container.read(sessionIndexProvider.notifier);
        notifier.upsertTasks('d1', [
          sess(
            't1',
            title: '跨项目会话',
            phase: 'running',
            lastActivityAt: 100,
            createdAt: 90,
            workspace: 'ai-meeting',
            pinned: true,
          ),
        ]);
        final s = container.read(sessionIndexProvider)['d1']?['t1'];
        expect(s?.title, '跨项目会话');
        expect(s?.workspace, 'ai-meeting');
        expect(s?.phase, 'running');
        expect(s?.lastActivityAt, 100);
        expect(s?.createdAt, 90);
        expect(s?.pinned, isTrue);
        expect(s?.permissionCount, 0);
      });

      test('合并：待办计数与交互细节保留既有（tasks-index 不得清掉）', () {
        final notifier = container.read(sessionIndexProvider.notifier);
        notifier.upsertAll('d1', [
          SessionState(
            sessionId: 's1',
            title: '旧标题',
            phase: 'running',
            permissionCount: 2,
            userInputCount: 1,
            interactionKind: 'permission',
            toolName: 'Write',
            description: '创建文件',
            lastActivityAt: 50,
            createdAt: 40,
            workspace: 'demo',
          ),
        ]);
        notifier.upsertTasks('d1', [
          sess('s1', lastActivityAt: 99),
        ]);
        final s = container.read(sessionIndexProvider)['d1']?['s1'];
        expect(s?.permissionCount, 2);
        expect(s?.userInputCount, 1);
        expect(s?.interactionKind, 'permission');
        expect(s?.toolName, 'Write');
        expect(s?.description, '创建文件');
        expect(s?.lastActivityAt, 50);
        expect(s?.createdAt, 40);
        expect(s?.workspace, 'demo');
        expect(s?.phase, 'running');
        expect(s?.title, '旧标题');
        expect(s?.pinned, isFalse);
      });

      test('合并：task 非空展示字段胜出（title/workspace/pinned）；时间戳/phase session 权威', () {
        final notifier = container.read(sessionIndexProvider.notifier);
        notifier.upsertAll('d1', [
          sess('s1', title: '旧标题', phase: 'running', lastActivityAt: 50),
        ]);
        notifier.upsertTasks('d1', [
          sess(
            's1',
            title: '新标题',
            phase: 'completedSuccess',
            lastActivityAt: 99,
            createdAt: 10,
            workspace: 'edai-web',
          ),
        ]);
        final s = container.read(sessionIndexProvider)['d1']?['s1'];
        expect(s?.title, '新标题');
        expect(s?.workspace, 'edai-web');
        expect(s?.lastActivityAt, 50);
        expect(s?.createdAt, 10);
        expect(s?.phase, 'running');
      });

      test('session 快照时间戳推进后胜出；无 session 覆盖时 task 时间戳生效', () {
        final notifier = container.read(sessionIndexProvider.notifier);
        notifier.upsertTasks('d1', [sess('t1', lastActivityAt: 100, createdAt: 80)]);
        expect(container.read(sessionIndexProvider)['d1']?['t1']?.lastActivityAt, 100);
        notifier.upsertAll('d1', [sess('t1', phase: 'running', lastActivityAt: 200)]);
        expect(
          container.read(sessionIndexProvider)['d1']?['t1']?.lastActivityAt,
          200,
        );
        notifier.upsertTasks('d1', [sess('t1', lastActivityAt: 150)]);
        expect(
          container.read(sessionIndexProvider)['d1']?['t1']?.lastActivityAt,
          200,
        );
      });

      test('replaceTasks：snapshot 全量替换——清空语义，残留摘除', () {
        final notifier = container.read(sessionIndexProvider.notifier);
        notifier.upsertTasks('d1', [sess('t_old', title: '旧', lastActivityAt: 1)]);
        notifier.upsertAll('d1', [sess('s_keep', phase: 'running', lastActivityAt: 5)]);
        notifier.replaceTasks('d1', [
          sess('t_new1', title: '新1', lastActivityAt: 9, workspace: 'alpha'),
          sess('t_new2', title: '新2', lastActivityAt: 8, workspace: 'beta'),
        ]);
        final d1 = container.read(sessionIndexProvider)['d1']!;
        expect(d1.keys.toSet(), {'t_new1', 't_new2', 's_keep'});
        expect(d1['t_old'], isNull);
        expect(d1['t_new1']?.workspace, 'alpha');
        notifier.replaceTasks('d1', const []);
        expect(
          container.read(sessionIndexProvider)['d1']?.keys,
          ['s_keep'],
        );
      });

      test('replaceTasks(preservePinned)：bootstrap 扁平视图无 pinned——既有置顶保留（评审 r10）', () {
        final notifier = container.read(sessionIndexProvider.notifier);
        notifier.upsertTasks('d1', [
          sess('t_pin', pinned: true, lastActivityAt: 10),
          sess('t_plain', lastActivityAt: 9),
        ]);
        notifier.replaceTasks(
          'd1',
          [
            sess('t_pin', lastActivityAt: 11),
            sess('t_plain', lastActivityAt: 10),
            sess('t_new', lastActivityAt: 8),
          ],
          preservePinned: true,
        );
        final d1 = container.read(sessionIndexProvider)['d1']!;
        expect(d1['t_pin']?.pinned, isTrue);
        expect(d1['t_plain']?.pinned, isFalse);
        expect(d1['t_new']?.pinned, isFalse);
      });

      test('replaceTasks 不带 preservePinned：snapshot 权威覆盖置顶（false 就该是 false）', () {
        final notifier = container.read(sessionIndexProvider.notifier);
        notifier.upsertTasks('d1', [sess('t_unpin', pinned: true, lastActivityAt: 10)]);
        notifier.replaceTasks('d1', [sess('t_unpin', lastActivityAt: 11)]);
        expect(
          container.read(sessionIndexProvider)['d1']?['t_unpin']?.pinned,
          isFalse,
        );
      });

      test('upsertAll 保留既有 pinned（sessions-index 无置顶字段不得冲掉）', () {
        final notifier = container.read(sessionIndexProvider.notifier);
        notifier.upsertTasks('d1', [sess('t1', pinned: true)]);
        notifier.upsertAll('d1', [
          sess('t1', phase: 'running', permissionCount: 1, lastActivityAt: 9),
        ]);
        final t1 = container.read(sessionIndexProvider)['d1']?['t1'];
        expect(t1?.pinned, isTrue);
        expect(t1?.permissionCount, 1);
        notifier.upsertAll('d1', [sess('t2', phase: 'running')]);
        expect(
          container.read(sessionIndexProvider)['d1']?['t2']?.pinned,
          isFalse,
        );
      });
    });
  });
}
