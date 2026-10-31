import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/models/model_draft.dart';
import 'package:zremote/models/provider_settings.dart';
import 'package:zremote/services/event_observer.dart';
import 'package:zremote/state/resume_reload.dart';
import 'package:zremote/state/service_readiness.dart';
import 'package:zremote/state/session_index.dart';
import 'package:zremote/state/session_status.dart';
import 'package:zremote/ui/model_settings_page.dart';
import 'package:zremote/ui/tactile_button.dart';
import 'package:zremote/ui/toolbox_sheet.dart';

import 'scripted_bridge.dart';

void main() {
  final device = RemoteDevice(
    id: 'd1',
    baseUrl: 'https://relay.example.com',
    params: const {'sid': 'sid-abcdef123456', 'hash': 'h'},
    label: '工作机',
    createdAt: DateTime(2026, 9, 1),
  );

  const baseUrl = 'https://api.example.com/v1';

  Map<String, dynamic> viewJson({
    bool entitled = true,
    bool? enabledModel46,
    List<String> startPlanModels = const [],
    List<String> customModels = const ['gpt-x', 'gpt-y'],
    String customName = 'My OpenAI',
    String customApiKey = 'sk-abcdef123456',
    bool withCustom = true,
    List<Map<String, dynamic>> extraProviders = const [],
    List<Map<String, dynamic>> providerTemplates = const [],

    Map<String, dynamic>? customPersonalConfig,

    List<Map<String, dynamic>>? customModelEntries,
  }) => {
    'revision': 5,
    if (providerTemplates.isNotEmpty) 'providerTemplates': providerTemplates,
    'providers': [
      {
        'providerId': 'builtin:zai-coding-plan',
        'providerName': 'Z.ai Coding Plan',
        'executable': true,
        'enabled': true,
        'effectiveConfig': {
          'group': 'zai-family',
          'access': {
            'type': 'zhipu-account',
            'accountType': 'zai',
            'mode': 'individual-coding-plan',
            'entitled': entitled,
          },
        },
        'models': [
          {'kind': 'chat', 'modelId': 'GLM-4.6', 'selectable': true,
           'effectiveConfig': {'enabled': enabledModel46},
          },
        ],
      },
      {
        'providerId': 'builtin:zai-start-plan',
        'providerName': 'Z.ai Start',
        'executable': true,
        'enabled': true,
        'effectiveConfig': {
          'group': 'zai-family',
          'access': {
            'type': 'zhipu-account',
            'accountType': 'zai',
            'mode': 'start-plan',
            'entitled': entitled,
          },
        },
        'models': [
          for (final m in startPlanModels)
            {'kind': 'chat', 'modelId': m},
        ],
      },
      if (withCustom)
        {
          'providerId': 'custom-1',
          'providerName': customName,
          'executable': true,
          'enabled': true,
          'personalConfig':
              customPersonalConfig ??
              {
                'access': {'type': 'api-key', 'apiKey': customApiKey},
                'api': {
                  'type': 'openai-chat-completions',
                  'baseUrl': baseUrl,
                },
              },
          'effectiveConfig': {
            'group': 'standard-personal',
            'access': {'type': 'api-key', 'apiKey': customApiKey},
            'api': {
              'type': 'openai-chat-completions',
              'baseUrl': baseUrl,
            },
          },
          'models':
              customModelEntries ??
              [for (final m in customModels) {'kind': 'chat', 'modelId': m}],
        },
      ...extraProviders,
    ],
  };

  Map<String, dynamic> inheritedConfigJson({
    int contextWindow = 200000,
    int maxOut = 8192,
    bool image = true,
  }) => {
    'properties': {
      'contextWindow': contextWindow,
      'supportsToolCall': true,
      'inputFormat': {
        'supportsText': true,
        'supportsImage': image,
        'supportsVideo': false,
        'supportsPdf': false,
      },
    },
    'optionSpecs': {
      'reasoningLevel': {
        'values': ['low', 'high'],
        'map': '{"low":{"effort":"low"},"high":{"effort":"high"}}',
      },
      'maxOutputTokens': {'max': maxOut},
    },
  };

  Map<String, dynamic> effectiveConfigJson({int contextWindow = 8000}) => {
    'enabled': true,
    'properties': {
      'contextWindow': contextWindow,
      'supportsToolCall': true,
      'inputFormat': {'supportsText': true, 'supportsImage': false},
    },
    'optionSpecs': {
      'reasoningLevel': {'values': ['low'], 'map': '{"low":{"effort":"low"}}'},
    },
  };

  Map<String, dynamic> richModel({
    String id = 'gpt-x',
    bool builtin = false,
    bool smart = true,
    Map<String, dynamic>? personal,
    Map<String, dynamic>? inherit,
    Map<String, dynamic>? effective,
  }) => {
    'kind': 'chat',
    'modelId': id,
    if (builtin) 'builtin': true,
    'selectable': true,
    'useRecommendedConfig': smart,
    'personalExactConfig':
        personal ?? const {'properties': {'contextWindow': 8000}},
    'effectiveBuiltinConfig': inherit ?? inheritedConfigJson(),
    'effectiveConfig': effective ?? effectiveConfigJson(),
  };

  Map<String, dynamic> entitlementJson() => {
    'authenticated': true, 'generatedAt': 1780000000000,
    'subscription': {'details': [
      {'productId': 'glm-coding-max', 'productName': 'GLM Coding Max'}]},
    'quota': {'level': 'max', 'limits': [
      {'type': 'TOKENS_LIMIT', 'unit': 3, 'number': 5, 'percentage': 7,
       'nextResetTime': '2026-09-25T00:00:00Z'},
      {'type': 'TOKENS_LIMIT', 'unit': 6, 'percentage': 43,
       'nextResetTime': '2026-09-25T00:00:00Z'}]},
    'mcpQuota': {'aggregate': {'percentage': 0}},
  };

  Map<String, dynamic> settingsJson({String? kind}) => {
    'providerFamilyDomain': 'zai',
    'providerFamilyConnectionSelections': {
      if (kind != null) 'zai': {'kind': kind},
    },
  };

  Future<ProviderContainer> pumpPage(
    WidgetTester tester, {
    required ScriptedBridge bridge,
    SessionStatus status = SessionStatus.live,
    void Function(ProviderContainer)? setupProviders,
  }) async {
    tester.view.physicalSize = const Size(600, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(sessionStatusProvider.notifier).report('d1', status);
    setupProviders?.call(container);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ModelSettingsPage(device: device, bridge: bridge.bridge),
        ),
      ),
    );
    await tester.pump();
    return container;
  }

  testWidgets('1. 就绪渲染：汇总条 + 套餐卡 + 连接区（当前/可切换）+ 供应商区', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [viewJson()],
        [settingsJson(kind: 'individual-coding-plan')],
        [entitlementJson()],
        [
          {
            'revision': 1,
            'providers': [
              {
                'providerId': 'builtin:zai',
                'models': [
                  {'modelId': 'GLM-4.6'},
                  {'modelId': 'GLM-4.5'},
                ],
              },
            ],
          },
        ],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    expect(find.text('套餐连接'), findsOneWidget);
    expect(find.text('Z.ai'), findsOneWidget);
    expect(find.text('个人套餐'), findsOneWidget);
    expect(find.text('当前'), findsOneWidget);
    expect(find.text('体验套餐'), findsOneWidget);
    expect(find.text('供应商'), findsOneWidget);
    expect(find.text('My OpenAI'), findsOneWidget);
    expect(find.text('2 个模型'), findsOneWidget);
    expect(find.text('可用供应商'), findsNothing);
    expect(find.text('GLM Coding Max'), findsOneWidget);
    expect(find.text('MAX'), findsOneWidget);
    expect(find.text('5 小时额度'), findsOneWidget);
    expect(find.text('93%'), findsOneWidget);
    expect(find.text('每周额度'), findsOneWidget);
    expect(find.text('57%'), findsOneWidget);
    expect(find.text('ZCode MCP'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('09-25'), findsNWidgets(2));
    expect(bridge.commands.length, 4);
    expect(requestOf(bridge.commands[0]).method, 'getView');
    final entReq = requestOf(bridge.commands[2]);
    expect(entReq.channel, 'usage-stats');
    expect(entReq.method, 'getEntitlementSnapshot');
    final entParams = entReq.params as Map<String, dynamic>;
    expect(entParams['includeSubscription'], isTrue);
    expect(entParams['preferredProviderId'], 'builtin:zai-coding-plan');
    expect(entParams['requirePreferredProvider'], isTrue);
    expect(
      entParams['accountAccess'],
      containsPair('type', 'zhipu-account'),
    );
  });

  testWidgets('2. 套餐行直开模型管理：无切换语义、全程零写调用', (
    tester,
  ) async {
    final bridge = ScriptedBridge(
      script: [
        [viewJson(startPlanModels: const ['GLM-4.5-Air'])],
        [settingsJson(kind: 'individual-coding-plan')],
        [{}],
        [entitlementJson()],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('体验套餐'));
    await tester.pumpAndSettle();
    expect(find.text('GLM-4.5-Air'), findsOneWidget);
    expect(bridge.commands.length, 4);
    final methods = [for (final c in bridge.commands) requestOf(c).method];
    expect(methods.contains('update'), isFalse);
    expect(methods.contains('refresh'), isFalse);
    expect(methods.contains('setPersonalModelEnabled'), isFalse);
  });

  testWidgets('3. 未开通套餐整行隐藏：空 family 不渲染，其余面不塌', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [viewJson(entitled: false)],
        [settingsJson(kind: 'individual-coding-plan')],
        [{}],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    expect(find.text('Z.ai'), findsNothing);
    expect(find.text('个人套餐'), findsNothing);
    expect(find.text('体验套餐'), findsNothing);
    expect(find.byKey(const Key('model-plan-card')), findsNothing);
    expect(find.text('My OpenAI'), findsOneWidget);
    expect(find.textContaining('新连接请在电脑端'), findsNothing);
  });

  testWidgets('4. setting.get 降级：脚注提示 + 供应商区仍渲染', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [viewJson()],
      ],
      errors: {1: 'no-services', 2: 'timeout', 3: 'timeout'},
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump(const Duration(seconds: 400));
    await tester.pumpAndSettle();
    expect(find.textContaining('连接方式获取失败'), findsOneWidget);
    expect(find.text('My OpenAI'), findsOneWidget);
    expect(find.byKey(const Key('model-plan-card')), findsNothing);
  });

  testWidgets('5. no-services 退避后成功（getView 重试）', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [],
        [viewJson()],
        [settingsJson()],
        [{}],
        [entitlementJson()],
      ],
      errors: {0: 'no-services'},
    );
    await pumpPage(tester, bridge: bridge);
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.text('My OpenAI'), findsOneWidget);
    expect(bridge.commands[0].runtimeType, isNotNull);
  });

  testWidgets('5b. no-services 退避耗尽（V2 未选电脑）：notReady 显示前置提示', (
    tester,
  ) async {
    final bridge = ScriptedBridge(
      script: [],
      errors: {0: 'no-services', 1: 'no-services', 2: 'no-services'},
    );
    await pumpPage(
      tester,
      bridge: bridge,
      setupProviders: (container) => container
          .read(serviceReadinessProvider.notifier)
          .report('d1', ServiceReadiness.unavailable),
    );
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('请先在网页中选择电脑并进入会话'), findsOneWidget);
    expect(find.text('加载失败'), findsNothing);
    expect(find.text('页面服务暂不可用'), findsNothing);
  });

  testWidgets('6. 空回执判死：整页 error + 重试按钮', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [{}],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    expect(find.text('加载失败'), findsOneWidget);
    expect(find.text('刷新'), findsOneWidget);
  });

  testWidgets('7. 详情弹层：密钥尾缀 + 接入点 + 测试按钮（无工作区禁用态文案）', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [viewJson()],
        [settingsJson()],
        [{}],
        [entitlementJson()],
      ],
    );
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    expect(find.text('接入点'), findsOneWidget);
    expect(find.text('api.example.com'), findsOneWidget);
    expect(find.text('密钥'), findsOneWidget);
    expect(find.text('·123456'), findsOneWidget);
    expect(find.text('需要有已打开的工作区才能测试连接'), findsOneWidget);
    expect(find.textContaining('sk-abcdef123456'), findsNothing);
  });

  testWidgets('8. 工具箱入箱：模型设置卡常驻可点 + 回调触发', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (sheetHost) => TextButton(
                onPressed: () => showToolboxSheet(
                  context: sheetHost,
                  device: device,
                  onAutomationPressed: () {},
                  onClaimPressed: () {},
                  onUsagePressed: () {},
                  onModelSettingsPressed: () => taps++,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.model_training_rounded), findsOneWidget);
    expect(find.text('模型设置'), findsOneWidget);
    await tester.tap(find.text('模型设置'));
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(find.text('功能工具箱'), findsNothing);
  });

  testWidgets('10. workspacePath 流通：tasks 底座携带路径 → 测试按钮可用（合并层回归）', (
    tester,
  ) async {
    final bridge = ScriptedBridge(
      script: [
        [viewJson()],
        [settingsJson()],
        [{}],
        [entitlementJson()],
        [
          {'ok': true},
        ],
      ],
    );
    await pumpPage(
      tester,
      bridge: bridge,
      setupProviders: (container) {
        final notifier = container.read(sessionIndexProvider.notifier);
        notifier.upsertTasks('d1', [
          SessionState(
            sessionId: 's1',
            lastActivityAt: 99,
            workspacePath: '/home/user/project-a',
          ),
        ]);
        notifier.upsertAll('d1', [
          const SessionState(sessionId: 's1', phase: 'running'),
        ]);
      },
    );
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    expect(find.text('需要有已打开的工作区才能测试连接'), findsNothing);
    expect(find.text('测试'), findsNWidgets(2));
    await tester.tap(find.text('测试').first);
    await tester.pumpAndSettle();
    final req = requestOf(bridge.commands[4]);
    expect(req.method, 'testModelConnectivity');
    expect(req.params, containsPair('workspacePath', '/home/user/project-a'));
  });

  testWidgets('11. 供应商区添加入口：常驻可点，弹层 = 自定义建号 + 模板分组', (tester) async {
    final bridge = ScriptedBridge(script: [
      [
        viewJson(providerTemplates: const [
          {
            'templateId': 'zai-api',
            'templateNameMap': {'zh-CN': 'Z.ai API', 'en-US': 'Z.ai API'},
          },
          {
            'templateId': 'openai',
            'templateNameMap': {'en-US': 'OpenAI Compatible'},
          },
        ]),
      ],
      [settingsJson()],
      [{}],
      [entitlementJson()],
    ]);
    await pumpPage(tester, bridge: bridge);
    expect(find.text('添加供应商'), findsOneWidget);
    await tester.tap(find.text('添加供应商'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('model-provider-name')), findsOneWidget);
    expect(find.byKey(const Key('model-provider-create')), findsOneWidget);
    expect(find.text('智谱系'), findsOneWidget);
    expect(find.text('Z.ai API'), findsOneWidget);
    expect(find.text('其他'), findsOneWidget);
    expect(find.text('OpenAI Compatible'), findsOneWidget);
    expect(bridge.commands.length, 4);
  });

  testWidgets('14. 添加供应商（自定义）：createPersonalProvider 建号 + 回执入列', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [
        {
          'providerId': 'custom-2',
          'view': viewJson(extraProviders: [
            {
              'providerId': 'custom-2',
              'providerName': 'New One',
              'executable': true,
              'enabled': true,
              'personalConfig': {
                'access': {'type': 'api-key', 'apiKey': 'sk-zzz888'},
              },
              'effectiveConfig': {
                'group': 'standard-personal',
                'access': {'type': 'api-key', 'apiKey': 'sk-zzz888'},
              },
              'models': const [],
            },
          ]),
        },
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.byKey(const Key('model-add-provider')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('model-provider-name')), 'New One');
    await tester.tap(find.byKey(const Key('model-provider-create')));
    await tester.pumpAndSettle();
    final req = requestOf(bridge.commands[4]);
    expect(req.channel, 'provider-settings');
    expect(req.method, 'createPersonalProvider');
    expect(req.params, {'providerName': 'New One', 'locale': 'zh-CN'});
    expect(find.byKey(const Key('model-provider-create')), findsNothing);
    expect(find.text('New One'), findsOneWidget);
  });

  testWidgets('15. 添加供应商（模板）：templateId 建号，组名直译', (tester) async {
    final bridge = ScriptedBridge(script: [
      [
        viewJson(providerTemplates: const [
          {
            'templateId': 'zai-api',
            'templateNameMap': {'zh-CN': 'Z.ai API', 'en-US': 'Z.ai API'},
          },
        ]),
      ],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [
        {
          'providerId': 'new-1',
          'view': viewJson(providerTemplates: const [
            {
              'templateId': 'zai-api',
              'templateNameMap': {'zh-CN': 'Z.ai API', 'en-US': 'Z.ai API'},
            },
          ]),
        },
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.byKey(const Key('model-add-provider')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-template-zai-api')));
    await tester.pumpAndSettle();
    final req = requestOf(bridge.commands[4]);
    expect(req.method, 'createPersonalProvider');
    expect(req.params, {'templateId': 'zai-api', 'locale': 'zh-CN'});
  });

  testWidgets('16. 编辑供应商：四字段同改 → 全量叠层内覆写 access/api + meta 只带改名', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [
        viewJson(
          customName: 'Renamed',
          customApiKey: 'sk-new-999888',
        ),
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('model-edit-provider')), findsOneWidget);
    expect(find.byKey(const Key('model-add-model')), findsOneWidget);
    await tester.tap(find.byKey(const Key('model-edit-provider')));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(find.byKey(const Key('model-edit-name'))).controller!.text, 'My OpenAI');
    expect(tester.widget<TextField>(find.byKey(const Key('model-edit-baseurl'))).controller!.text, baseUrl);
    await tester.enterText(find.byKey(const Key('model-edit-name')), 'Renamed');
    await tester.enterText(find.byKey(const Key('model-edit-key')), 'sk-new-999888');
    await tester.enterText(find.byKey(const Key('model-edit-baseurl')), 'https://api2.example.com/v1');
    await tester.tap(find.byKey(const Key('model-format-openai-responses')));
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    final args = argsOf(bridge.commands[4]);
    expect(requestOf(bridge.commands[4]).method, 'savePersonalProviderOverlay');
    expect(args, [
      'custom-1',
      {
        'access': {'type': 'api-key', 'apiKey': 'sk-new-999888'},
        'api': {
          'type': 'openai-responses',
          'baseUrl': 'https://api2.example.com/v1',
        },
      },
      {'providerName': 'Renamed'},
    ]);
    expect(find.text('Renamed'), findsNWidgets(2));
    expect(find.text('·999888'), findsOneWidget);
  });

  testWidgets('17. 添加/删除模型：addPersonalModel 四参（草稿叠层）+ deletePersonalModel 两参', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [
        {'inheritedConfig': inheritedConfigJson(), 'issues': []},
      ],
      [viewJson(customModels: const ['gpt-x', 'gpt-y', 'gpt-z'])],
      [viewJson(customModels: const ['gpt-y', 'gpt-z'])],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-add-model')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('model-draft-id')), ' gpt-z ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(requestOf(bridge.commands[4]).method, 'resolveModelConfig');
    expect(requestOf(bridge.commands[4]).params, {
      'providerId': 'custom-1',
      'modelId': 'gpt-z',
    });
    await tester.tap(find.byKey(const Key('model-draft-save')));
    await tester.pumpAndSettle();
    expect(requestOf(bridge.commands[5]).method, 'addPersonalModel');
    final addArgs = argsOf(bridge.commands[5]);
    expect(addArgs[0], 'custom-1');
    expect(addArgs[1], 'gpt-z');
    expect(addArgs[3], true);
    final overlay = addArgs[2] as Map<String, dynamic>;
    expect(
      (overlay['properties'] as Map).containsKey('contextWindow'),
      isFalse,
    );
    expect(find.text('gpt-z'), findsOneWidget);
    await tester.tap(find.byKey(const Key('model-del-gpt-x')));
    await tester.pumpAndSettle();
    expect(find.text('删除模型？'), findsOneWidget);
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    expect(requestOf(bridge.commands[6]).method, 'deletePersonalModel');
    expect(argsOf(bridge.commands[6]), ['custom-1', 'gpt-x']);
    expect(find.text('gpt-x'), findsNothing);
  });

  testWidgets('17b. 编辑模型参数：savePersonalModelDraft 单参对象 + basedOnRevision', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson(customModelEntries: [richModel()])],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [
        viewJson(
          customModelEntries: [
            richModel(
              personal: const {'properties': {'contextWindow': 16000}},
              effective: effectiveConfigJson(contextWindow: 16000),
            ),
          ],
        ),
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    expect(find.text('上下文窗口：8K'), findsOneWidget);
    await tester.tap(find.byKey(const Key('model-edit-gpt-x')));
    await tester.pumpAndSettle();
    expect(find.text('编辑模型配置'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('model-draft-context-window')))
          .controller!
          .text,
      '8000',
    );
    await tester.enterText(
      find.byKey(const Key('model-draft-context-window')),
      '16000',
    );
    await tester.tap(find.byKey(const Key('model-draft-save')));
    await tester.pumpAndSettle();
    expect(requestOf(bridge.commands[4]).method, 'savePersonalModelDraft');
    final params = requestOf(bridge.commands[4]).params as Map<String, dynamic>;
    expect(params['providerId'], 'custom-1');
    expect(params['originalModelId'], 'gpt-x');
    expect(params['nextModelId'], 'gpt-x');
    expect(params['useRecommendedConfig'], true);
    expect(params['basedOnRevision'], 5);
    final overlay = params['personalConfig'] as Map<String, dynamic>;
    expect((overlay['properties'] as Map)['contextWindow'], 16000);
    expect((overlay['properties'] as Map)['outputFormat'], isNull);
  });

  testWidgets('17c. 模型参数校验：空 ID / 推荐面无等级就地报错且不派发写命令', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson(customModelEntries: [richModel()])],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [
        {
          'inheritedConfig': {
            'properties': {
              'contextWindow': 200000,
              'inputFormat': {'supportsText': true},
            },
            'optionSpecs': {},
          },
          'issues': [],
        },
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-add-model')));
    await tester.pumpAndSettle();
    final before = bridge.commands.length;
    await tester.tap(find.byKey(const Key('model-draft-save')));
    await tester.pumpAndSettle();
    expect(find.text('模型 ID 不能为空'), findsOneWidget);
    expect(bridge.commands.length, before);
    await tester.enterText(find.byKey(const Key('model-draft-id')), 'gpt-new');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final afterResolve = bridge.commands.length;
    expect(requestOf(bridge.commands[afterResolve - 1]).method, 'resolveModelConfig');
    await tester.tap(find.byKey(const Key('model-draft-save')));
    await tester.pumpAndSettle();
    expect(find.text('推理档位不能为空或重复'), findsOneWidget);
    expect(bridge.commands.length, afterResolve);
    expect(find.byKey(const Key('model-draft-save')), findsOneWidget);
  });

  testWidgets('17d. 恢复默认：叠层清空 + 智能配置重开 + 推荐面回填', (tester) async {
    final bridge = ScriptedBridge(script: [
      [
        viewJson(
          customModelEntries: [
            richModel(smart: false),
          ],
        ),
      ],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [
        {'inheritedConfig': inheritedConfigJson(), 'issues': []},
      ],
      [viewJson(customModelEntries: [richModel()])],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-edit-gpt-x')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-draft-restore')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('model-draft-context-window')))
          .controller!
          .text,
      '',
    );
    await tester.tap(find.byKey(const Key('model-draft-save')));
    await tester.pumpAndSettle();
    expect(requestOf(bridge.commands[4]).method, 'resolveModelConfig');
    expect(requestOf(bridge.commands[5]).method, 'savePersonalModelDraft');
    final params = requestOf(bridge.commands[5]).params as Map<String, dynamic>;
    expect(params['useRecommendedConfig'], true);
    final overlay = params['personalConfig'] as Map<String, dynamic>;
    expect((overlay['properties'] as Map).containsKey('contextWindow'), isFalse);
  });

  testWidgets('17e. 智能配置关：推荐面补值进输入框（控制器随草稿对齐）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson(customModelEntries: [richModel()])],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [viewJson(customModelEntries: [richModel(smart: false)])],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-edit-gpt-x')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-draft-smart-switch')));
    await tester.pumpAndSettle();
    String textOf(String key) => tester
        .widget<TextField>(find.byKey(Key(key)))
        .controller!
        .text;
    expect(textOf('model-draft-max-output'), '8192');
    expect(
      textOf('model-draft-reasoning-map'),
      contains('"low"'),
    );
    await tester.tap(find.byKey(const Key('model-draft-save')));
    await tester.pumpAndSettle();
    expect(requestOf(bridge.commands[4]).method, 'savePersonalModelDraft');
    final params = requestOf(bridge.commands[4]).params as Map<String, dynamic>;
    expect(params['useRecommendedConfig'], false);
    final overlay = params['personalConfig'] as Map<String, dynamic>;
    final props = overlay['properties'] as Map;
    expect(props['contextWindow'], 8000);
    expect(props['inputFormat'], {
      'supportsImage': false,
      'supportsVideo': false,
      'supportsPdf': false,
    });
    final specs = overlay['optionSpecs'] as Map;
    expect(specs['maxOutputTokens'], {'max': 8192});
    expect((specs['reasoningLevel'] as Map)['values'], ['low']);
  });

  testWidgets('17f. 智能配置开：恢复默认式重置（字段清空 + 叠层底座退化为空）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [
        viewJson(
          customModelEntries: [
            richModel(smart: false),
          ],
        ),
      ],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [
        {'inheritedConfig': inheritedConfigJson(), 'issues': []},
      ],
      [viewJson(customModelEntries: [richModel()])],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-edit-gpt-x')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-draft-smart-switch')));
    await tester.pumpAndSettle();
    String textOf(String key) => tester
        .widget<TextField>(find.byKey(Key(key)))
        .controller!
        .text;
    expect(textOf('model-draft-context-window'), '');
    expect(textOf('model-draft-max-output'), '');
    await tester.tap(find.byKey(const Key('model-draft-save')));
    await tester.pumpAndSettle();
    expect(requestOf(bridge.commands[4]).method, 'resolveModelConfig');
    expect(requestOf(bridge.commands[5]).method, 'savePersonalModelDraft');
    final params = requestOf(bridge.commands[5]).params as Map<String, dynamic>;
    expect(params['useRecommendedConfig'], true);
    final overlay = params['personalConfig'] as Map<String, dynamic>;
    expect((overlay['properties'] as Map).containsKey('contextWindow'), isFalse);
  });

  testWidgets('17g. 编辑无变化即免写：关层零命令（官方 De 的 JSON 短路）', (tester) async {
    final overlay = ZrModelDraft.forModel(
      ZrProviderModel.fromJson(richModel())!,
    ).buildPersonalConfig();
    final bridge = ScriptedBridge(script: [
      [
        viewJson(
          customModelEntries: [richModel(personal: overlay)],
        ),
      ],
      [settingsJson()],
      [{}],
      [entitlementJson()],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-edit-gpt-x')));
    await tester.pumpAndSettle();
    final before = bridge.commands.length;
    await tester.tap(find.byKey(const Key('model-draft-save')));
    await tester.pumpAndSettle();
    expect(bridge.commands.length, before);
    expect(find.byKey(const Key('model-draft-save')), findsNothing);
  });

  testWidgets('18. 删除供应商：deletePersonalProvider 单参，详情随页关闭', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [viewJson(withCustom: false)],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-edit-provider')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-provider-delete')));
    await tester.pumpAndSettle();
    expect(find.text('删除供应商？'), findsOneWidget);
    await tester.tap(find.text('删除供应商').last);
    await tester.pumpAndSettle();
    expect(requestOf(bridge.commands[4]).method, 'deletePersonalProvider');
    expect(argsOf(bridge.commands[4]), ['custom-1']);
    expect(find.text('My OpenAI'), findsNothing);
    expect(find.byKey(const Key('model-add-provider')), findsOneWidget);
  });

  testWidgets('12. 套餐供应商模型管理：连接行开详情 + 模型开关三参写 + 回执刷新', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson(kind: 'individual-coding-plan')],
      [{}],
      [entitlementJson()],
      [
        viewJson(enabledModel46: false),
      ],
    ]);
    await pumpPage(tester, bridge: bridge);
    expect(find.text('1 个模型'), findsOneWidget);
    await tester.tap(find.text('个人套餐').last);
    await tester.pumpAndSettle();
    expect(find.text('GLM-4.6'), findsOneWidget);
    expect(find.byKey(const Key('model-edit-provider')), findsNothing);
    expect(find.byKey(const Key('model-add-model')), findsNothing);
    expect(find.byKey(const Key('model-del-GLM-4.6')), findsNothing);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    final req = requestOf(bridge.commands[4]);
    expect(req.method, 'setPersonalModelEnabled');
    final args = argsOf(bridge.commands[4]);
    expect(args, [
      'builtin:zai-coding-plan',
      'GLM-4.6',
      false,
    ]);
    await tester.tap(find.byIcon(Icons.close_rounded).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('个人套餐').last);
    await tester.pumpAndSettle();
    expect(find.text('GLM-4.6'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch).first).value, isFalse);
  });

  testWidgets('13. 判死重载回 live：epoch 广播 + status live → 就地重启（旧轮作废）', (
    tester,
  ) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson(kind: 'individual-coding-plan')],
      [entitlementJson()],
      [{}],
      [viewJson()],
      [settingsJson(kind: 'individual-coding-plan')],
      [entitlementJson()],
      [{}],
    ]);
    final container = await pumpPage(tester, bridge: bridge);
    expect(find.text('My OpenAI'), findsOneWidget);
    expect(bridge.commands.length, 4);

    container.read(resumeReloadEpochProvider.notifier).bump();
    await tester.pump();
    container
        .read(sessionStatusProvider.notifier)
        .report('d1', SessionStatus.loading);
    await tester.pump();
    container
        .read(sessionStatusProvider.notifier)
        .report('d1', SessionStatus.live);
    await tester.pump();
    await tester.pump();
    expect(bridge.commands.length, 8);
    expect(requestOf(bridge.commands[4]).method, 'getView');
    expect(find.text('My OpenAI'), findsOneWidget);
    expect(find.text('GLM Coding Max'), findsOneWidget);
  });

  test('9. 红线：页面/模型/服务实现零 credentialService/oauthService 引用', () {
    const files = [
      'lib/ui/model_settings_page.dart',
      'lib/models/provider_settings.dart',
      'lib/models/model_draft.dart',
    ];
    for (final f in files) {
      final src = File(f).readAsStringSync();
      expect(src.contains('credentialService'), isFalse, reason: f);
      expect(src.contains('oauthService'), isFalse, reason: f);
    }
  });

  Future<void> openEditor(WidgetTester tester) async {
    if (find.byKey(const Key('model-edit-provider')).evaluate().isNotEmpty) {
      await tester.tap(find.byIcon(Icons.close_rounded).last);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-edit-provider')));
    await tester.pumpAndSettle();
  }

  Map<String, dynamic> richPersonalConfig() => <String, dynamic>{
    'group': 'standard-personal',
    'logo': 'openai',
    'modelOrder': ['gpt-x', 'gpt-y'],
    'visibility': 'visible',
    'builtinModelIds': ['builtin-1'],
    'personalModelIds': ['gpt-x'],
    'access': {
      'type': 'api-key',
      'apiKey': 'sk-abcdef123456',
      'apiKeyManagementUrl': 'https://keys.example.com',
    },
    'api': {
      'type': 'openai-chat-completions',
      'baseUrl': baseUrl,
      'headers': {'x-trace': '1'},
    },
  };

  testWidgets('19. 编辑叠层=官方全量合并：兄弟字段保真、model-id 目录剔除、未改名走两参', (
    tester,
  ) async {
    final personal = richPersonalConfig();
    final bridge = ScriptedBridge(script: [
      [viewJson(customPersonalConfig: personal)],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [viewJson(customPersonalConfig: personal, customApiKey: 'sk-new-999888')],
    ]);
    await pumpPage(tester, bridge: bridge);
    await openEditor(tester);
    await tester.enterText(
      find.byKey(const Key('model-edit-key')),
      'sk-new-999888',
    );
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    expect(
      requestOf(bridge.commands[4]).method,
      'savePersonalProviderOverlay',
    );
    final args = argsOf(bridge.commands[4]);
    expect(args.length, 2);
    expect(args[0], 'custom-1');
    expect(args[1], {
      'group': 'standard-personal',
      'logo': 'openai',
      'modelOrder': ['gpt-x', 'gpt-y'],
      'visibility': 'visible',
      'access': {
        'type': 'api-key',
        'apiKey': 'sk-new-999888',
        'apiKeyManagementUrl': 'https://keys.example.com',
      },
      'api': {
        'type': 'openai-chat-completions',
        'baseUrl': baseUrl,
        'headers': {'x-trace': '1'},
      },
    });
    expect(find.textContaining('sk-new-999888'), findsNothing);
  });

  testWidgets('20. 编辑无变化即关层零命令；只改名 → 全量叠层 + meta 带名', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [viewJson(customName: 'Renamed')],
    ]);
    await pumpPage(tester, bridge: bridge);
    await openEditor(tester);
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('model-edit-save')), findsNothing);
    expect(bridge.commands.length, 4);
    await openEditor(tester);
    await tester.enterText(find.byKey(const Key('model-edit-name')), 'Renamed');
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    final args = argsOf(bridge.commands[4]);
    expect(args.length, 3);
    expect(args[1], {
      'access': {'type': 'api-key', 'apiKey': 'sk-abcdef123456'},
      'api': {'type': 'openai-chat-completions', 'baseUrl': baseUrl},
    });
    expect(args[2], {'providerName': 'Renamed'});
  });

  testWidgets('21. 编辑 baseUrl 清空 = 去键（api 保 type/headers，不整块替换）', (tester) async {
    final personal = <String, dynamic>{
      'access': {'type': 'api-key', 'apiKey': 'sk-abcdef123456'},
      'api': {
        'type': 'openai-chat-completions',
        'baseUrl': baseUrl,
        'headers': {'x-trace': '1'},
      },
    };
    final bridge = ScriptedBridge(script: [
      [viewJson(customPersonalConfig: personal)],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [viewJson(customPersonalConfig: personal)],
    ]);
    await pumpPage(tester, bridge: bridge);
    await openEditor(tester);
    await tester.enterText(find.byKey(const Key('model-edit-baseurl')), '');
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    expect(argsOf(bridge.commands[4])[1], {
      'access': {'type': 'api-key', 'apiKey': 'sk-abcdef123456'},
      'api': {'type': 'openai-chat-completions', 'headers': {'x-trace': '1'}},
    });
  });

  testWidgets('22. 编辑只改协议 = api 保 baseUrl/headers，type 换新', (tester) async {
    final personal = <String, dynamic>{
      'access': {'type': 'api-key', 'apiKey': 'sk-abcdef123456'},
      'api': {
        'type': 'openai-chat-completions',
        'baseUrl': baseUrl,
        'headers': {'x-trace': '1'},
      },
    };
    final bridge = ScriptedBridge(script: [
      [viewJson(customPersonalConfig: personal)],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [viewJson(customPersonalConfig: personal)],
    ]);
    await pumpPage(tester, bridge: bridge);
    await openEditor(tester);
    await tester.tap(find.byKey(const Key('model-format-openai-responses')));
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    expect(argsOf(bridge.commands[4])[1], {
      'access': {'type': 'api-key', 'apiKey': 'sk-abcdef123456'},
      'api': {
        'type': 'openai-responses',
        'baseUrl': baseUrl,
        'headers': {'x-trace': '1'},
      },
    });
  });

  testWidgets('23. baseUrl 归一：尾斜杠剥离（不产生伪改动）+ 中继双 origin 解包', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [viewJson()],
    ]);
    await pumpPage(tester, bridge: bridge);
    await openEditor(tester);
    await tester.enterText(
      find.byKey(const Key('model-edit-baseurl')),
      '$baseUrl/',
    );
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    expect(bridge.commands.length, 4);
    await openEditor(tester);
    await tester.enterText(
      find.byKey(const Key('model-edit-baseurl')),
      'https://api2.example.com/https://api2.example.com',
    );
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    expect(argsOf(bridge.commands[4])[1], {
      'access': {'type': 'api-key', 'apiKey': 'sk-abcdef123456'},
      'api': {
        'type': 'openai-chat-completions',
        'baseUrl': 'https://api2.example.com',
      },
    });
  });

  testWidgets('24. 建号失败：留驻内联错误、零回执行入列', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [viewJson()],
        [settingsJson()],
        [{}],
        [entitlementJson()],
      ],
      errors: {4: 'template-unknown'},
    );
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.byKey(const Key('model-add-provider')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('model-provider-name')),
      'New One',
    );
    await tester.tap(find.byKey(const Key('model-provider-create')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('model-provider-create')), findsOneWidget);
    expect(find.text('template-unknown'), findsOneWidget);
  });

  testWidgets('24b. 保存失败：固定文案、不回显宿主原文（请求带明文密钥）', (tester) async {
    final bridge = ScriptedBridge(
      script: [
        [viewJson()],
        [settingsJson()],
        [{}],
        [entitlementJson()],
      ],
      errors: {4: 'rejected: apiKey sk-new-999888 invalid'},
    );
    await pumpPage(tester, bridge: bridge);
    await openEditor(tester);
    await tester.enterText(
      find.byKey(const Key('model-edit-key')),
      'sk-new-999888',
    );
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('model-edit-save')), findsOneWidget);
    expect(find.text('保存失败，请重试'), findsOneWidget);
    expect(find.textContaining('rejected'), findsNothing);
    expect(find.textContaining('sk-new-999888'), findsOneWidget);
  });

  testWidgets('25. 建号回执不可解析 → 页面兜底整页刷新对账', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
      [{}],
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.byKey(const Key('model-add-provider')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('model-provider-name')),
      'New One',
    );
    await tester.tap(find.byKey(const Key('model-provider-create')));
    await tester.pumpAndSettle();
    expect(bridge.commands.length, 9);
    expect(requestOf(bridge.commands[5]).method, 'getView');
    expect(find.byKey(const Key('model-provider-create')), findsNothing);
  });

  testWidgets('26. 校验拦截与重复提交：空名零命令，在途按钮同步禁用', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.byKey(const Key('model-add-provider')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-provider-create')));
    await tester.pumpAndSettle();
    expect(find.text('请输入供应商名称'), findsOneWidget);
    expect(bridge.commands.length, 4);
    await tester.enterText(
      find.byKey(const Key('model-provider-name')),
      'New One',
    );
    await tester.tap(find.byKey(const Key('model-provider-create')));
    expect(bridge.commands.length, 5);
    await tester.pump();
    expect(
      tester
          .widget<TactileButton>(
            find.byKey(const Key('model-provider-create')),
          )
          .onPressed,
      isNull,
    );
    await tester.pump(const Duration(seconds: 26));
    await tester.pumpAndSettle();
  });

  testWidgets('27. 写入期间关层：回执仍送达页面（重复建号防线）', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.byKey(const Key('model-add-provider')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('model-provider-name')),
      'New One',
    );
    await tester.tap(find.byKey(const Key('model-provider-create')));
    await tester.pump();
    expect(bridge.commands.length, 5);
    Navigator.of(
      tester.element(find.byKey(const Key('model-provider-name'))),
    ).pop();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('model-provider-create')), findsNothing);
    final id = bridge.commands[4]['i']! as int;
    bridge.deliver(
      jsonEncode({
        'i': id,
        'ok': true,
        'r': jsonEncode({
          'providerId': 'custom-2',
          'view': viewJson(
            extraProviders: [
              {
                'providerId': 'custom-2',
                'providerName': 'New One',
                'executable': true,
                'enabled': true,
                'effectiveConfig': {
                  'group': 'standard-personal',
                  'access': {'type': 'api-key', 'apiKey': 'sk-zzz888'},
                },
                'models': const [],
              },
            ],
          ),
        }),
      }),
    );
    await tester.pumpAndSettle();
    expect(find.text('New One'), findsOneWidget);
  });

  testWidgets('28. 保存期间关层：编辑层与详情层都关掉，回执仍送达页面', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
    ]);
    await pumpPage(tester, bridge: bridge);
    await openEditor(tester);
    await tester.enterText(find.byKey(const Key('model-edit-name')), 'Renamed');
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pump();
    expect(bridge.commands.length, 5);
    await tester.tap(find.byIcon(Icons.close_rounded).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close_rounded).last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('model-edit-save')), findsNothing);
    final id = bridge.commands[4]['i']! as int;
    bridge.deliver(
      jsonEncode({
        'i': id,
        'ok': true,
        'r': jsonEncode(viewJson(customName: 'Renamed')),
      }),
    );
    await tester.pumpAndSettle();
    expect(find.text('Renamed'), findsOneWidget);
  });

  testWidgets('29. 启停失败回滚后编辑保存仍发全量叠层（personalConfig 不被重建丢掉）', (
    tester,
  ) async {
    final personal = richPersonalConfig();
    final bridge = ScriptedBridge(
      script: [
        [viewJson(customPersonalConfig: personal)],
        [settingsJson()],
        [{}],
        [entitlementJson()],
        [{}],
        [viewJson(customPersonalConfig: personal)],
      ],
      errors: {4: 'toggle-failed'},
    );
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(requestOf(bridge.commands[4]).method, 'setPersonalModelEnabled');
    await tester.tap(find.byKey(const Key('model-edit-provider')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('model-edit-key')),
      'sk-new-999888',
    );
    await tester.tap(find.byKey(const Key('model-edit-save')));
    await tester.pumpAndSettle();
    final overlay = argsOf(bridge.commands[5])[1] as Map<String, dynamic>;
    expect(overlay, containsPair('group', 'standard-personal'));
    expect(overlay, containsPair('visibility', 'visible'));
    expect(overlay, containsPair('modelOrder', ['gpt-x', 'gpt-y']));
    expect(overlay['api'], containsPair('headers', {'x-trace': '1'}));
    expect(
      (overlay['access'] as Map)['apiKeyManagementUrl'],
      'https://keys.example.com',
    );
  });

  testWidgets('30. 模型删除期间关层：回执仍送达页面', (tester) async {
    final bridge = ScriptedBridge(script: [
      [viewJson()],
      [settingsJson()],
      [{}],
      [entitlementJson()],
    ]);
    await pumpPage(tester, bridge: bridge);
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('model-del-gpt-x')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pump();
    expect(bridge.commands.length, 5);
    await tester.tap(find.byIcon(Icons.close_rounded).last);
    await tester.pumpAndSettle();
    final id = bridge.commands[4]['i']! as int;
    bridge.deliver(
      jsonEncode({
        'i': id,
        'ok': true,
        'r': jsonEncode(viewJson(customModels: const ['gpt-y'])),
      }),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('My OpenAI'));
    await tester.pumpAndSettle();
    expect(find.text('gpt-x'), findsNothing);
    expect(find.text('gpt-y'), findsOneWidget);
  });
}
