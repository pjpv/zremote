import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/services/rpc_codec.dart';
import 'package:zremote/state/automation.dart';
import 'package:zremote/ui/automation_form.dart';

import 'scripted_bridge.dart';

void main() {
  Map<String, dynamic> autoJson(String id) => {
    'automationId': id,
    'title': '旧标题',
    'cronExpr': '0 9 * * *',
    'prompt': '旧指令',
    'workspacePath': r'J:\tmp\demo',
    'mode': 'build',
    'model': 'GLM-5.3',
    'thoughtLevel': 'max',
    'enabled': true,
    'recurring': true,
  };

  Map<String, dynamic> taskJson(String id, {String status = 'queued'}) => {
    'offPeakTaskId': id,
    'title': '旧任务标题',
    'prompt': '旧任务指令',
    'status': status,
    'workspacePath': r'J:\tmp\demo',
  };

  Future<void> pumpForm(
    WidgetTester tester, {
    required ScriptedBridge bridge,
    AutomationFormKind kind = AutomationFormKind.scheduled,
    Automation? editing,
    OffPeakTask? editingOffPeak,
    bool seedProjects = true,
  }) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    if (seedProjects) {
      container
          .read(automationProvider.notifier)
          .reportProjects('d1', [r'J:\tmp\demo']);
    }
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AutomationFormPage(
                        bridge: bridge.bridge,
                        kind: kind,
                        editing: editing,
                        editingOffPeak: editingOffPeak,
                      ),
                    ),
                  ),
                  child: const Text('PUSH'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('PUSH'));
    await tester.pumpAndSettle();
  }

  Future<void> fillBasics(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).at(0), '新任务');
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(1), '回复 done');
    await tester.pump();
  }

  testWidgets('必填校验：三空字段红字，不发电（无 bridge 调用）', (tester) async {
    final bridge = ScriptedBridge();
    await pumpForm(tester, bridge: bridge, seedProjects: false);
    await tester.tap(find.text('保存'));
    await tester.pump();
    expect(find.text('请输入标题'), findsOneWidget);
    expect(find.text('请输入指令内容'), findsOneWidget);
    expect(find.text('请选择工作区'), findsOneWidget);
    expect(bridge.commands, isEmpty);
  });

  testWidgets('创建定时任务：默认每天 09:00 预设 → createAutomation 参数', (tester) async {
    final bridge = ScriptedBridge(script: [
      [autoJson('new-1')],
    ]);
    await pumpForm(tester, bridge: bridge);
    await fillBasics(tester);
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(bridge.commands, hasLength(1));
    final request = requestOf(bridge.commands.last);
    expect(request.channel, 'zcode-agent');
    expect(request.method, 'createAutomation');
    expect(
      (request.params as Map<String, dynamic>)['model'],
      'custom:builtin%3Abigmodel-coding-plan:GLM-5.3',
    );
    expect(request.params, {
      'workspacePath': r'J:\tmp\demo',
      'title': '新任务',
      'cronExpr': '0 9 * * *',
      'prompt': '回复 done',
      'recurring': true,
      'mode': 'build',
      'thoughtLevel': 'max',
      'model': RpcCodec.kScheduledModel,
      'modelSelection': {
        'providerId': 'builtin:bigmodel-coding-plan',
        'modelId': 'GLM-5.3',
        'options': {'reasoningLevel': 'max'},
      },
    });
    expect(find.text('已保存'), findsOneWidget);
    expect(find.text('PUSH'), findsOneWidget);
  });

  testWidgets('创建定时任务：错误形状响应（无 automationId）→ 失败 SnackBar 且不 pop', (tester) async {
    final bridge = ScriptedBridge(script: [
      [
        {'ok': false, 'error': 'invalid params'},
      ],
    ]);
    await pumpForm(tester, bridge: bridge);
    await fillBasics(tester);
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(bridge.commands, hasLength(1));
    expect(requestOf(bridge.commands.last).method, 'createAutomation');
    expect(find.text('操作失败，请重试'), findsOneWidget);
    expect(find.text('保存'), findsOneWidget);
    expect(find.text('PUSH'), findsNothing);
  });

  testWidgets('工作日预设 → cronExpr dow=1-5', (tester) async {
    final bridge = ScriptedBridge(script: [
      [autoJson('new-1')],
    ]);
    await pumpForm(tester, bridge: bridge);
    await fillBasics(tester);
    await tester.tap(find.text('工作日'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    final request = requestOf(bridge.commands.last);
    expect(request.method, 'createAutomation');
    expect(
      (request.params as Map<String, dynamic>)['cronExpr'],
      '0 9 * * 1-5',
    );
  });

  testWidgets('周末预设 → cronExpr dow=6,0', (tester) async {
    final bridge = ScriptedBridge(script: [
      [autoJson('new-1')],
    ]);
    await pumpForm(tester, bridge: bridge);
    await fillBasics(tester);
    await tester.tap(find.text('周末'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    final request = requestOf(bridge.commands.last);
    expect((request.params as Map<String, dynamic>)['cronExpr'], '0 9 * * 6,0');
  });

  testWidgets('自定义 cron：非法格式红字 + 合法实时预览', (tester) async {
    final bridge = ScriptedBridge();
    await pumpForm(tester, bridge: bridge);
    await fillBasics(tester);
    await tester.tap(find.text('自定义'));
    await tester.pumpAndSettle();
    final cronField = find.widgetWithText(TextFormField, 'm h dom mon dow');
    await tester.enterText(cronField, 'abc');
    await tester.pump();
    expect(find.text('自定义'), findsWidgets);
    await tester.tap(find.text('保存'));
    await tester.pump();
    expect(find.text('cron 表达式非法（需 5 个字段：分 时 日 月 周）'), findsOneWidget);
    expect(bridge.commands, isEmpty);
    await tester.enterText(cronField, '0 9 * * *');
    await tester.pump();
    expect(find.textContaining('每日 09:00'), findsOneWidget);
  });

  testWidgets('创建闲时任务：createTask 参数（无计划字段）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [
        {
          'ok': true,
          'task': {
            'offPeakTaskId': 'offpeak-new',
            'title': '新任务',
            'status': 'queued',
          },
        },
      ],
    ]);
    await pumpForm(tester, bridge: bridge, kind: AutomationFormKind.offPeak);
    await fillBasics(tester);
    expect(find.text('每天'), findsNothing);
    expect(find.text('任务将在该设备主机空闲时按队列执行'), findsOneWidget);
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    final request = requestOf(bridge.commands.last);
    expect(request.channel, 'off-peak-task');
    expect(request.method, 'createTask');
    expect(
      (request.params as Map<String, dynamic>)['model'],
      'GLM-5.3',
    );
    expect(request.params, {
      'title': '新任务',
      'prompt': '回复 done',
      'workspacePath': r'J:\tmp\demo',
      'permissionMode': 'build',
      'model': 'GLM-5.3',
      'thoughtLevel': 'max',
      'modelSelection': {
        'providerId': 'builtin:bigmodel-coding-plan',
        'modelId': 'GLM-5.3',
        'options': {'reasoningLevel': 'max'},
      },
    });
  });

  testWidgets('创建闲时任务：错误形状响应（无 task.offPeakTaskId）→ 失败 SnackBar 且不 pop', (tester) async {
    final bridge = ScriptedBridge(script: [
      [
        {'ok': false, 'error': 'quota exceeded'},
      ],
    ]);
    await pumpForm(tester, bridge: bridge, kind: AutomationFormKind.offPeak);
    await fillBasics(tester);
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(bridge.commands, hasLength(1));
    expect(requestOf(bridge.commands.last).method, 'createTask');
    expect(find.text('操作失败，请重试'), findsOneWidget);
    expect(find.text('保存'), findsOneWidget);
    expect(find.text('PUSH'), findsNothing);
  });

  testWidgets('编辑态锁类型 + 标题：定时编辑无类型段、预填原值', (tester) async {
    final bridge = ScriptedBridge();
    final editing = Automation.fromJson(autoJson('a-1'))!;
    await pumpForm(tester, bridge: bridge, editing: editing);
    expect(find.text('编辑任务'), findsOneWidget);
    expect(find.text('闲时任务'), findsNothing);
    expect(find.text('定时任务'), findsNothing);
    expect(find.text('旧标题'), findsOneWidget);
    expect(find.text('旧指令'), findsOneWidget);
  });

  testWidgets('编辑闲时任务（旧代）：探测 no-method → 单对象 updateTask', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [],
        [taskJson('t-1', status: 'paused')],
      ],
      errors: {0: 'no-method'},
    );
    final editing = OffPeakTask.fromJson(taskJson('t-1', status: 'paused'))!;
    await pumpForm(
      tester,
      bridge: bridge,
      kind: AutomationFormKind.offPeak,
      editingOffPeak: editing,
    );
    await tester.enterText(
      find.byType(TextFormField).at(0),
      '改名了',
    );
    await tester.pump();
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(bridge.commands, hasLength(2));
    expect(requestOf(bridge.commands.first).method, 'getCodingPlanSupport');
    final request = requestOf(bridge.commands.last);
    expect(request.method, 'updateTask');
    expect(request.params, {
      'taskId': 't-1',
      'title': '改名了',
    });
  });

  testWidgets('编辑闲时任务（新代）：探测成功 → 两参 updateTask [taskId, params]', (tester) async {
    final bridge = ScriptedBridge(script: [
      [
        {'supported': false},
      ],
      [taskJson('t-1', status: 'paused')],
    ]);
    final editing = OffPeakTask.fromJson(taskJson('t-1', status: 'paused'))!;
    await pumpForm(
      tester,
      bridge: bridge,
      kind: AutomationFormKind.offPeak,
      editingOffPeak: editing,
    );
    await tester.enterText(find.byType(TextFormField).at(0), '改名了');
    await tester.pump();
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(bridge.commands, hasLength(2));
    expect(requestOf(bridge.commands.first).method, 'getCodingPlanSupport');
    final request = requestOf(bridge.commands.last);
    expect(request.method, 'updateTask');
    expect(argsOf(bridge.commands.last), [
      't-1',
      {'title': '改名了'},
    ]);
  });

  testWidgets('编辑闲时任务：下拉显示实际权限值，改回 build 也作为变化发送（评审 r1）', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [],
        [taskJson('t-1', status: 'paused')],
      ],
      errors: {0: 'no-method'},
    );
    final editing = OffPeakTask.fromJson({
      ...taskJson('t-1', status: 'paused'),
      'permissionMode': 'yolo',
    })!;
    await pumpForm(
      tester,
      bridge: bridge,
      kind: AutomationFormKind.offPeak,
      editingOffPeak: editing,
    );
    await tester.tap(find.text('高级设置'));
    await tester.pumpAndSettle();
    expect(find.text('yolo'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('yolo').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('build').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    final request = requestOf(bridge.commands.last);
    expect(request.method, 'updateTask');
    expect(request.params, {
      'taskId': 't-1',
      'permissionMode': 'build',
    });
  });

  testWidgets('编辑定时任务：改权限模式 → mode 作为变化字段发送（评审 r1）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [autoJson('a-1')],
    ]);
    final editing = Automation.fromJson(autoJson('a-1'))!;
    await pumpForm(tester, bridge: bridge, editing: editing);
    await tester.tap(find.text('高级设置'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('build').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('autoEdit').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    final request = requestOf(bridge.commands.last);
    expect(request.method, 'updateAutomation');
    expect(request.params, {
      'workspacePath': r'J:\tmp\demo',
      'automationId': 'a-1',
      'mode': 'autoEdit',
    });
  });

  testWidgets('存量每小时 cron：回落自定义态，原值提交不损', (tester) async {
    final bridge = ScriptedBridge(script: [
      [autoJson('a-legacy')],
    ]);
    final legacy = Map<String, dynamic>.from(autoJson('a-legacy'))
      ..['cronExpr'] = '30 * * * *';
    final editing = Automation.fromJson(legacy)!;
    await pumpForm(tester, bridge: bridge, editing: editing);
    await tester.pumpAndSettle();
    expect(find.text('自定义'), findsOneWidget);
    expect(find.text('30 * * * *'), findsOneWidget);
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    final request = requestOf(bridge.commands.last);
    expect(request.method, 'updateAutomation');
    expect(
      (request.params as Map<String, dynamic>)['cronExpr'],
      isNull,
      reason: 'custom 态未改动 cron → 差分不含 cronExpr，原文零损',
    );
  });

  testWidgets('编辑门控防御：非 queued/paused 闲时任务提交被拒', (tester) async {
    final bridge = ScriptedBridge();
    final editing = OffPeakTask.fromJson(taskJson('t-1', status: 'completed'))!;
    await pumpForm(
      tester,
      bridge: bridge,
      kind: AutomationFormKind.offPeak,
      editingOffPeak: editing,
    );
    await tester.enterText(find.byType(TextFormField).at(0), '改名');
    await tester.pump();
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();
    expect(bridge.commands, isEmpty);
    expect(find.text('编辑任务'), findsOneWidget);
  });

  testWidgets('编辑闲时任务：旧数据幽灵权限值并入下拉不崩，未动不发', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [],
        [taskJson('t-1', status: 'paused')],
      ],
      errors: {0: 'no-method'},
    );
    final editing = OffPeakTask.fromJson({
      ...taskJson('t-1', status: 'paused'),
      'permissionMode': 'acceptEdits',
    })!;
    await pumpForm(
      tester,
      bridge: bridge,
      kind: AutomationFormKind.offPeak,
      editingOffPeak: editing,
    );
    await tester.tap(find.text('高级设置'));
    await tester.pumpAndSettle();
    expect(find.text('acceptEdits'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      '改名了',
    );
    await tester.pump();
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    final request = requestOf(bridge.commands.last);
    expect(request.method, 'updateTask');
    expect(request.params, {'taskId': 't-1', 'title': '改名了'});
  });

  group('载荷构造纯函数（3.14 对齐，非 widget）', () {
    test('kPermissionModes = host 权威 6 值（顺序保持、默认 build）', () {
      expect(kPermissionModes, [
        'yolo',
        'plan',
        'edit',
        'auto',
        'autoEdit',
        'build',
      ]);
    });

    test('kModelSelection：strict zod 三键，options 仅 reasoningLevel', () {
      expect(kModelSelection.keys.toList(), [
        'providerId',
        'modelId',
        'options',
      ]);
      expect(kModelSelection['providerId'], 'builtin:bigmodel-coding-plan');
      expect(kModelSelection['modelId'], 'GLM-5.3');
      expect((kModelSelection['options'] as Map).keys.toList(), [
        'reasoningLevel',
      ]);
      expect((kModelSelection['options'] as Map)['reasoningLevel'], 'max');
    });

    test('buildCreateTaskPayload：平铺 + modelSelection 双发键齐全', () {
      final payload = AutomationFormPage.buildCreateTaskPayload(
        title: 't',
        prompt: 'p',
        workspacePath: 'w',
        permissionMode: 'build',
      );
      expect(payload, {
        'title': 't',
        'prompt': 'p',
        'workspacePath': 'w',
        'permissionMode': 'build',
        'model': 'GLM-5.3',
        'thoughtLevel': 'max',
        'modelSelection': kModelSelection,
      });
    });

    test('buildCreateAutomationPayload：model 两种形态并存且互不混淆', () {
      final payload = AutomationFormPage.buildCreateAutomationPayload(
        workspacePath: 'w',
        title: 't',
        cronExpr: '0 9 * * *',
        prompt: 'p',
        mode: 'build',
      );
      expect(payload['model'], 'custom:builtin%3Abigmodel-coding-plan:GLM-5.3');
      expect(payload['model'], RpcCodec.kScheduledModel);
      expect(
        payload['modelSelection'],
        kModelSelection,
      );
      expect(payload, containsPair('mode', 'build'));
      expect(payload, containsPair('recurring', true));
      expect(payload, containsPair('thoughtLevel', 'max'));
    });

    test('buildUpdateTaskDiff：title/prompt/permissionMode 三路差分', () {
      final editing = OffPeakTask.fromJson({
        ...taskJson('t-1'),
        'permissionMode': 'yolo',
      })!;
      expect(
        AutomationFormPage.buildUpdateTaskDiff(
          title: editing.title,
          prompt: editing.prompt,
          permissionMode: 'yolo',
          originalPermissionMode: 'yolo',
          editing: editing,
        ),
        isEmpty,
      );
      expect(
        AutomationFormPage.buildUpdateTaskDiff(
          title: editing.title,
          prompt: '新指令',
          permissionMode: 'build',
          originalPermissionMode: 'yolo',
          editing: editing,
        ),
        {'prompt': '新指令', 'permissionMode': 'build'},
      );
    });
  });

  testWidgets('创建闲时任务：createTask 判别联合失败臂 → 分类 SnackBar', (tester) async {
    final bridge = ScriptedBridge(script: [
      [
        {
          'ok': false,
          'failureStage': 'ticket_request',
          'errorCategory': 'quota_3103',
          'errorCode': '3103',
        },
      ],
    ]);
    await pumpForm(tester, bridge: bridge, kind: AutomationFormKind.offPeak);
    await fillBasics(tester);
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('取号额度不足，请稍后再试'), findsOneWidget);
    expect(find.text('已保存'), findsNothing);
  });

  testWidgets('创建定时任务：AUTOMATION_CREATE_LIMIT_REACHED → 上限 SnackBar', (tester) async {
    final bridge = ScriptedBridge(
      script: [[]],
      errors: {0: 'AUTOMATION_CREATE_LIMIT_REACHED: limit 20'},
    );
    await pumpForm(tester, bridge: bridge);
    await fillBasics(tester);
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('定时任务已达上限（20 个），请先删除不需要的'), findsOneWidget);
    expect(find.text('已保存'), findsNothing);
  });

  test('createFailureMessage 纯函数：分类映射与兜底', () {
    final l10n = lookupAppLocalizations(const Locale('zh'));
    expect(
      AutomationFormPage.createFailureMessage(
        const AutomationCreateRejectedException('eligibility_3101'),
        l10n,
      ),
      l10n.automationCreateEligibility,
    );
    expect(
      AutomationFormPage.createFailureMessage(
        const AutomationCreateRejectedException('unknown'),
        l10n,
      ),
      l10n.automationOpFailed,
    );
    expect(
      AutomationFormPage.createFailureMessage(
        StateError('shape'),
        l10n,
      ),
      l10n.automationOpFailed,
    );
  });
}
