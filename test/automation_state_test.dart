import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/state/automation.dart';

void main() {
  late ProviderContainer container;
  late AutomationNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(automationProvider.notifier);
    addTearDown(container.dispose);
  });

  Map<String, dynamic> taskJson(String id, {String status = 'queued'}) => {
    'offPeakTaskId': id,
    'title': 'T-$id',
    'prompt': 'P',
    'status': status,
    'queuePosition': 3,
    'workspacePath': r'J:\tmp\demo',
    'queuedAt': 1788523547814,
    'updatedAt': 1788523547814,
  };

  Map<String, dynamic> autoJson(String id, {bool enabled = true}) => {
    'automationId': id,
    'title': 'A-$id',
    'cronExpr': '0 9 * * *',
    'enabled': enabled,
    'recurring': true,
    'workspacePath': r'J:\tmp\demo',
    'nextRunAt': 1788570000000,
    'runCount': 2,
  };

  test('reportSubscribed(true) 开门，forget 摘除', () {
    notifier.reportSubscribed('d1', true);
    expect(container.read(automationProvider)['d1']!.subscribed, isTrue);
    notifier.forget('d1');
    expect(container.read(automationProvider).containsKey('d1'), isFalse);
  });

  test('reportSubscribed(false)（页面重载复位）清空两列表、保留 workspace 候选', () {
    notifier.reportSubscribed('d1', true);
    notifier.replaceOffPeak('d1', [taskJson('t1')]);
    notifier.replaceAutomations('d1', [autoJson('a1')]);
    notifier.reportProjects('d1', [r'J:\tmp\demo']);
    notifier.reportSubscribed('d1', false);
    final board = container.read(automationProvider)['d1']!;
    expect(board.subscribed, isFalse);
    expect(board.offPeak, isEmpty);
    expect(board.automations, isEmpty);
    expect(board.recentProjects, [r'J:\tmp\demo']);
  });

  test('replaceOffPeak 全量替换 + queuedCount 只数 queued', () {
    notifier.replaceOffPeak('d1', [
      taskJson('t1'),
      taskJson('t2', status: 'running'),
      taskJson('t3', status: 'queued'),
    ]);
    var board = container.read(automationProvider)['d1']!;
    expect(board.offPeak.length, 3);
    expect(board.queuedCount, 2);
    notifier.replaceOffPeak('d1', [taskJson('t3', status: 'paused')]);
    board = container.read(automationProvider)['d1']!;
    expect(board.offPeak.length, 1);
    expect(board.queuedCount, 0);
    expect(board.offPeak.first.status, 'paused');
  });

  test('upsertOffPeak：已存在原位替换，新对象插头部（host 序 created_at DESC）', () {
    notifier.replaceOffPeak('d1', [taskJson('t1')]);
    notifier.upsertOffPeak('d1', {
      ...taskJson('t1'),
      'status': 'paused',
      'title': '改名',
    });
    var board = container.read(automationProvider)['d1']!;
    expect(board.offPeak.length, 1);
    expect(board.offPeak.first.status, 'paused');
    expect(board.offPeak.first.title, '改名');
    notifier.upsertOffPeak('d1', taskJson('t2'));
    board = container.read(automationProvider)['d1']!;
    expect(board.offPeak.length, 2);
    expect(board.offPeak.first.offPeakTaskId, 't2');
  });

  test('upsertAutomation / removeAutomation（新对象插头部）', () {
    notifier.upsertAutomation('d1', autoJson('a1'));
    notifier.upsertAutomation('d1', autoJson('a2', enabled: false));
    var board = container.read(automationProvider)['d1']!;
    expect(board.automations.length, 2);
    expect(board.automations.first.enabled, isFalse);
    expect(board.automations.first.automationId, 'a2');
    notifier.upsertAutomation('d1', {...autoJson('a2'), 'enabled': true});
    board = container.read(automationProvider)['d1']!;
    expect(board.automations.length, 2);
    expect(board.automations.first.enabled, isTrue);
    notifier.removeAutomation('d1', 'a1');
    board = container.read(automationProvider)['d1']!;
    expect(board.automations.map((a) => a.automationId), ['a2']);
    notifier.removeAutomation('d1', 'ghost');
    expect(board.automations.length, 1);
  });

  test('removeOffPeak', () {
    notifier.replaceOffPeak('d1', [taskJson('t1'), taskJson('t2')]);
    notifier.removeOffPeak('d1', 't1');
    final board = container.read(automationProvider)['d1']!;
    expect(board.offPeak.map((t) => t.offPeakTaskId), ['t2']);
  });

  test('OffPeakTask.permissionMode：缺省 build、运行时值透传（评审 r1 编辑诚实性）', () {
    notifier.replaceOffPeak('d1', [taskJson('t1')]);
    expect(
      container.read(automationProvider)['d1']!.offPeak.single.permissionMode,
      'build',
    );
    notifier.replaceOffPeak('d1', [
      {...taskJson('t2'), 'permissionMode': 'yolo'},
    ]);
    expect(
      container.read(automationProvider)['d1']!.offPeak.single.permissionMode,
      'yolo',
    );
  });

  test('多设备隔离（多账号第一约束）', () {
    notifier.reportSubscribed('d1', true);
    notifier.reportSubscribed('d2', true);
    notifier.replaceOffPeak('d1', [taskJson('t1')]);
    notifier.replaceAutomations('d2', [autoJson('a1')]);
    final state = container.read(automationProvider);
    expect(state['d1']!.offPeak.length, 1);
    expect(state['d1']!.automations, isEmpty);
    expect(state['d2']!.offPeak, isEmpty);
    expect(state['d2']!.automations.length, 1);
    notifier.forget('d1');
    expect(container.read(automationProvider).containsKey('d2'), isTrue);
  });

  test('宽容解析：必填 id 缺失丢弃、字段类型不符给默认', () {
    notifier.replaceOffPeak('d1', [
      {'title': '没有 id 的垃圾对象'},
      {
        'offPeakTaskId': 't9',
        'title': 42,
        'queuePosition': 'many',
        'queuedAt': 'not-a-time',
      },
    ]);
    final board = container.read(automationProvider)['d1']!;
    expect(board.offPeak.length, 1);
    final t = board.offPeak.first;
    expect(t.offPeakTaskId, 't9');
    expect(t.title, '');
    expect(t.queuePosition, isNull);
    expect(t.queuedAt, isNull);
    expect(t.status, '');

    notifier.replaceAutomations('d1', [
      {'cronExpr': '无 id'},
      autoJson('a9'),
    ]);
    final board2 = container.read(automationProvider)['d1']!;
    expect(board2.automations.length, 1);
    final a = board2.automations.first;
    expect(a.nextRunAt, DateTime.fromMillisecondsSinceEpoch(1788570000000));
    expect(a.runCount, 2);
    expect(a.recurring, isTrue);
  });

  test('实抓黄金(09-12)：禁用中的定时任务真实字段全量落模', () {
    notifier.replaceAutomations('d1', [
      {
        'automationId': 'automation-58d29f5c-5b20-46a7-926a-540d26179f40',
        'title': '每日定时关机',
        'cronExpr': '0 2 * * *',
        'prompt': '这是用于主动关机的定时任务…最后确认任务已"完成"。',
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
      },
    ]);
    final board = container.read(automationProvider)['d1']!;
    expect(board.automations.length, 1);
    final a = board.automations.first;
    expect(a.automationId, 'automation-58d29f5c-5b20-46a7-926a-540d26179f40');
    expect(a.title, '每日定时关机');
    expect(a.cronExpr, '0 2 * * *');
    expect(a.enabled, isFalse);
    expect(a.recurring, isTrue);
    expect(a.runCount, 6);
    expect(a.mode, 'yolo');
    expect(a.thoughtLevel, 'max');
    expect(a.model, 'builtin:bigmodel-coding-plan/GLM-5.3-Flash');
    expect(a.workspacePath, r'J:\tmp\zcode-switch');
    expect(a.nextRunAt, DateTime.fromMillisecondsSinceEpoch(1788976800000));
    expect(a.lastRunAt, DateTime.fromMillisecondsSinceEpoch(1788890419105));
  });

  test('同值写入不换 state 引用（10s 轮询防重建抖动）', () {
    notifier.replaceOffPeak('d1', [taskJson('t1')]);
    final before = container.read(automationProvider);
    notifier.replaceOffPeak('d1', [taskJson('t1')]);
    expect(identical(container.read(automationProvider), before), isTrue);
  });

  test('被动流组合语义：快照(≥2)替换传播删除，单对象回执 upsert 不清洗', () {
    notifier.replaceAutomations('d1', [autoJson('a1'), autoJson('a2')]);
    notifier.replaceOffPeak('d1', [taskJson('t1'), taskJson('t2')]);

    notifier.upsertAutomation('d1', autoJson('a2', enabled: false));
    var board = container.read(automationProvider)['d1']!;
    expect(board.automations.length, 2);
    expect(
      board.automations.firstWhere((a) => a.automationId == 'a2').enabled,
      isFalse,
    );

    notifier.upsertAutomation('d1', autoJson('a3'));
    board = container.read(automationProvider)['d1']!;
    expect(board.automations.length, 3);

    notifier.replaceAutomations('d1', [autoJson('a2'), autoJson('a3')]);
    board = container.read(automationProvider)['d1']!;
    expect(board.automations.map((a) => a.automationId), ['a2', 'a3']);

    notifier.upsertOffPeak('d1', taskJson('t2', status: 'paused'));
    board = container.read(automationProvider)['d1']!;
    expect(board.offPeak.length, 2);
    expect(
      board.offPeak.firstWhere((t) => t.offPeakTaskId == 't2').status,
      'paused',
    );
  });

  test('historyDeletedAt：官方删除历史行 → 整只丢弃（快照/回执双路）', () {
    notifier.reportSubscribed('d1', true);
    notifier.replaceOffPeak('d1', [
      taskJson('t1'),
      {...taskJson('t9', status: 'completed'), 'historyDeletedAt': 123},
    ]);
    var board = container.read(automationProvider)['d1']!;
    expect(board.offPeak.map((t) => t.offPeakTaskId), ['t1']);

    notifier.upsertOffPeak(
      'd1',
      {...taskJson('t2', status: 'failed'), 'historyDeletedAt': 456},
    );
    board = container.read(automationProvider)['d1']!;
    expect(board.offPeak.map((t) => t.offPeakTaskId), ['t1']);

    notifier.upsertOffPeak(
      'd1',
      {...taskJson('t1', status: 'completed'), 'historyDeletedAt': 789},
    );
    board = container.read(automationProvider)['d1']!;
    expect(board.offPeak, isEmpty);
  });

  test('failureReason / filesChanged 落模（官方 v4 新字段宽容解析）', () {
    final failed = OffPeakTask.fromJson({
      ...taskJson('t1', status: 'failed'),
      'failureReason': 'ticket expired',
      'filesChanged': 3,
    })!;
    expect(failed.failureReason, 'ticket expired');
    expect(failed.filesChanged, 3);

    final bare = OffPeakTask.fromJson(taskJson('t2'))!;
    expect(bare.failureReason, isNull);
    expect(bare.filesChanged, isNull);
    expect(failed == bare, isFalse);
  });
}
