import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/event_observer.dart';
import 'package:zremote/services/rpc_codec.dart';

void main() {
  const offPeakTaskJson = '''
{"offPeakTaskId":"offpeak-bc72781e-3886-4e11-99c6-f9dc04ad343b",
 "serverTicketId":"2095845781078032384",
 "title":"未命名",
 "prompt":"取证专用：请直接回复 done，不要执行任何其他操作。",
 "permissionMode":"build",
 "model":"GLM-5.3",
 "thoughtLevel":"max",
 "workspaceKey":"W:\\\\ws\\\\demo",
 "workspacePath":"W:\\\\ws\\\\demo",
 "status":"queued",
 "queuedAt":1788523547814,
 "registeredAt":1788523547814,
 "schedulable":false,
 "queuePosition":282,
 "nextPollAt":1788523637814,
 "createdAt":1788523547814,
 "updatedAt":1788523547814}''';

  const automationJson = '''
{"automationId":"automation-a93b0a7e-8133-4253-bc0a-3abac72fd50c",
 "title":"取证-定时任务-可删除",
 "cronExpr":"0 9 * * *",
 "prompt":"取证专用：请直接回复 done，不要执行任何其他操作。",
 "model":"custom:builtin%3Abigmodel-coding-plan:GLM-5.3",
 "mode":"build",
 "thoughtLevel":"max",
 "workspaceKey":"W:\\\\ws\\\\demo",
 "workspacePath":"W:\\\\ws\\\\demo",
 "locationKind":"local",
 "recurring":true,
 "runCount":0,
 "enabled":true,
 "lifecycleStatus":"active",
 "nextRunAt":1788570000000,
 "dispatchStatus":"idle",
 "dispatchAttempts":0,
 "createdAt":1788523362003,
 "updatedAt":1788523362003}''';

  group('OffPeakTaskExtractor', () {
    test('真实任务对象 → 收集 + queued 计数', () {
      final root = jsonDecode(offPeakTaskJson);
      final r = OffPeakTaskExtractor.parseRoot(root);
      expect(r, isNotNull);
      expect(r!.tasks.length, 1);
      expect(r.tasks.first['offPeakTaskId'], contains('bc72781e'));
      expect(r.queued, 1);
    });

    test('多任务串排（list 响应聚合）→ 全收集，queued 只数 queued', () {
      final root = jsonDecode('[$offPeakTaskJson,$offPeakTaskJson]');
      (root as List)[1] = {...(root[1] as Map), 'status': 'paused'};
      final r = OffPeakTaskExtractor.parseRoot(root);
      expect(r!.tasks.length, 2);
      expect(r.queued, 1);
    });

    test('无关帧 → null（三值语义：不更新）', () {
      expect(OffPeakTaskExtractor.parseRoot({'foo': 'bar'}), isNull);
      expect(OffPeakTaskExtractor.parseRoot([1, 2, 3]), isNull);
      expect(OffPeakTaskExtractor.parseRoot(null), isNull);
      expect(OffPeakTaskExtractor.parseRoot('text'), isNull);
    });

    test('automation 对象不误命中闲时提取器', () {
      final root = jsonDecode(automationJson);
      expect(OffPeakTaskExtractor.parseRoot(root), isNull);
    });
  });

  group('AutomationExtractor', () {
    test('真实 automation 对象 → 收集', () {
      final root = jsonDecode(automationJson);
      final autos = AutomationExtractor.parseRoot(root);
      expect(autos, isNotNull);
      expect(autos!.length, 1);
      expect(autos.first['automationId'], contains('a93b0a7e'));
      expect(autos.first['cronExpr'], '0 9 * * *');
    });

    test('run 对象（automationId + runId）被排除', () {
      final root = {
        'runs': [
          {'runId': 'run-1', 'automationId': 'automation-x', 'status': 'ok'},
          {'runId': 'run-2', 'automationId': 'automation-y', 'status': 'ok'},
        ],
      };
      expect(AutomationExtractor.parseRoot(root), isNull);
      final mixed = {
        'items': [...root['runs'] as List, jsonDecode(automationJson)],
      };
      final autos = AutomationExtractor.parseRoot(mixed);
      expect(autos!.length, 1);
      expect(autos.first['automationId'], contains('a93b0a7e'));
    });

    test('无关帧 → null', () {
      expect(AutomationExtractor.parseRoot({'ok': true}), isNull);
      expect(AutomationExtractor.parseRoot(42), isNull);
    });

    test('offPeak 任务对象不误命中定时提取器', () {
      final root = jsonDecode(offPeakTaskJson);
      expect(AutomationExtractor.parseRoot(root), isNull);
    });
  });

  group('CodingPlanSignalExtractor', () {
    test('providerId 精确串 + apiKey 非空 Map → 命中', () {
      final root = {
        'providers': [
          {'providerId': 'builtin:bigmodel', 'apiKey': {}},
          {
            'providerId': 'builtin:bigmodel-coding-plan',
            'apiKey': {'source': 'inline', 'value': 'sk-xxx'},
          },
        ],
      };
      expect(
        CodingPlanSignalExtractor.parseRoot(root),
        'builtin:bigmodel-coding-plan',
      );
    });

    test('apiKey 缺失/空 Map → 未连接（null）', () {
      final root = {
        'providers': [
          {'providerId': 'builtin:bigmodel-coding-plan'},
          {
            'providerId': 'builtin:bigmodel-coding-plan',
            'apiKey': <String, dynamic>{},
          },
        ],
      };
      expect(CodingPlanSignalExtractor.parseRoot(root), isNull);
    });

    test('providerId 前缀相似但不精确相等 → null', () {
      final root = {
        'providers': [
          {
            'providerId': 'builtin:bigmodel-coding-plan-start',
            'apiKey': {'v': 1},
          },
        ],
      };
      expect(CodingPlanSignalExtractor.parseRoot(root), isNull);
    });

    test('空 providers 数组 → null', () {
      expect(
        CodingPlanSignalExtractor.parseRoot({'providers': <dynamic>[]}),
        isNull,
      );
    });

    test('嵌套深处的快照也能命中（maxDepth 6 内）', () {
      final root = {
        'a': {
          'b': {
            'c': {
              'providers': [
                {
                  'providerId': 'builtin:bigmodel-coding-plan',
                  'apiKey': {'source': 'inline', 'value': 'k'},
                },
              ],
            },
          },
        },
      };
      expect(
        CodingPlanSignalExtractor.parseRoot(root),
        'builtin:bigmodel-coding-plan',
      );
    });
  });

  group('RecentProjectsExtractor', () {
    test('真实 workspace-list 响应内层 → 提取路径列表', () {
      const text =
          r'{"recentProjects":["J:\\tmp\\demo","J:\\tmp\\qa-fixture-ws","C:\\Program Files\\ZCode"]}';
      final projects = RecentProjectsExtractor.parseRoot(jsonDecode(text));
      expect(projects, [
        r'J:\tmp\demo',
        r'J:\tmp\qa-fixture-ws',
        r'C:\Program Files\ZCode',
      ]);
    });

    test('包在响应信封里也能深找（maxDepth 4）', () {
      final root = {
        'payload': {
          'result': {
            'recentProjects': [r'J:\tmp\demo'],
          },
        },
      };
      expect(RecentProjectsExtractor.parseRoot(root), [r'J:\tmp\demo']);
    });

    test('空列表 / 非字符串项全滤 / 无键 → null', () {
      expect(RecentProjectsExtractor.parseRoot({'recentProjects': []}), isNull);
      expect(
        RecentProjectsExtractor.parseRoot({
          'recentProjects': [1, true],
        }),
        isNull,
      );
      expect(RecentProjectsExtractor.parseRoot({'other': 1}), isNull);
    });
  });

  group('AutomationFeed（被动流帧级批量决策 r2）', () {
    Map<String, dynamic> auto(String id) => {
      'automationId': id,
      'title': id,
      'cronExpr': '0 9 * * *',
      'enabled': false,
    };

    Map<String, dynamic> task(String id) => {
      'offPeakTaskId': id,
      'title': id,
      'status': 'queued',
    };

    test('拼接多对象帧（列表快照形态）→ 全量 + snapshot=true', () {
      final inputs = RpcCodec.parseConcatenatedJsonText(
        '${jsonEncode(task('t1'))}${jsonEncode(task('t2'))}'
        '${jsonEncode(task('t3'))}',
      );
      expect(inputs.length, 3);
      final feed = AutomationFeed.offPeakOf(inputs);
      expect(feed.snapshot, isTrue);
      expect(feed.tasks.map((t) => t['offPeakTaskId']), ['t1', 't2', 't3']);
    });

    test('单对象帧（create/update 回执）→ upsert 决策，不清洗列表', () {
      final offPeak = AutomationFeed.offPeakOf([jsonDecode(offPeakTaskJson)]);
      expect(offPeak.snapshot, isFalse);
      expect(offPeak.tasks.length, 1);
      final autos = AutomationFeed.automationsOf([jsonDecode(automationJson)]);
      expect(autos.snapshot, isFalse);
      expect(autos.automations.length, 1);
    });

    test('单 root 含数组（≥2）→ snapshot=true', () {
      final feed = AutomationFeed.automationsOf([
        {
          'automations': [auto('a1'), auto('a2')],
        },
      ]);
      expect(feed.snapshot, isTrue);
      expect(feed.automations.length, 2);
    });

    test('混合帧：闲时 1 + 定时 2 → 两通道独立决策', () {
      final inputs = [task('t1'), auto('a1'), auto('a2')];
      expect(AutomationFeed.offPeakOf(inputs).snapshot, isFalse);
      expect(AutomationFeed.automationsOf(inputs).snapshot, isTrue);
    });

    test('run 对象混入帧不计入定时批量（滤后剩 1 → upsert）', () {
      final inputs = [
        {'runId': 'r1', 'automationId': 'ax', 'status': 'ok'},
        auto('a1'),
      ];
      final autos = AutomationFeed.automationsOf(inputs);
      expect(autos.snapshot, isFalse);
      expect(autos.automations.length, 1);
      expect(autos.automations.single['automationId'], 'a1');
    });

    test('跨 input 并集（数组 root + 拼接单对象）', () {
      final inputs = [
        {
          'items': [auto('a1'), auto('a2')],
        },
        auto('a3'),
      ];
      final autos = AutomationFeed.automationsOf(inputs);
      expect(autos.snapshot, isTrue);
      expect(autos.automations.map((a) => a['automationId']), [
        'a1',
        'a2',
        'a3',
      ]);
    });

    test('无关帧 → 两通道皆空', () {
      final inputs = <dynamic>[
        {'ok': true},
        42,
      ];
      expect(AutomationFeed.offPeakOf(inputs).tasks, isEmpty);
      expect(AutomationFeed.automationsOf(inputs).automations, isEmpty);
    });
  });
}
