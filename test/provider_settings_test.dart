import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/models/provider_settings.dart';

void main() {
  Map<String, dynamic> providerJson({
    String id = 'builtin:zai-coding-plan',
    String? group = 'zai-family',
    String accessType = 'zhipu-account',
    String? accountType = 'zai',
    String? mode = 'individual-coding-plan',
    bool? entitled = true,
    String availability = 'available',
    String? apiKey,
    String? baseUrl,
    int modelCount = 2,
    bool enabled = true,
  }) => {
    'providerId': id,
    'providerName': 'Z.ai Coding Plan',
    'executable': true,
    'enabled': enabled,
    if (availability.isNotEmpty)
      'accountState': {'availability': availability},
    'effectiveConfig': {
      'group': ?group,
      'access': {
        'type': accessType,
        'accountType': ?accountType,
        'mode': ?mode,
        'entitled': ?entitled,
        'apiKey': ?apiKey,
      },
      if (baseUrl != null) 'api': {'baseUrl': baseUrl},
    },
    'models': [
      for (var i = 0; i < modelCount; i++)
        {'kind': 'chat', 'modelId': 'GLM-4.$i', 'builtin': true,
         'selectable': true, 'executable': true},
    ],
  };

  test('1. 全量视图：providers/模型/计数', () {
    final view = ProviderSettingsView.fromJson({
      'revision': 7,
      'providers': [
        providerJson(),
        providerJson(
          id: 'custom-1',
          group: 'standard-personal',
          accessType: 'api-key',
          accountType: null,
          mode: null,
          entitled: null,
          availability: '',
          apiKey: 'sk-abcdef123456',
          baseUrl: 'https://api.example.com/v1',
        ),
      ],
    });
    expect(view, isNotNull);
    expect(view!.providers.length, 2);
    expect(view.revision, 7);
    final zai = view.byId('builtin:zai-coding-plan');
    expect(zai, isNotNull);
    expect(zai!.models.length, 2);
    expect(zai.models.first.modelId, 'GLM-4.0');
    expect(zai.displayName, 'Z.ai Coding Plan');
  });

  test('2. 套餐连接推导：entitled 的 zhipu-account 才进清单（FPe 同构）', () {
    final view = ProviderSettingsView.fromJson({
      'revision': 0,
      'providers': [
        providerJson(),
        providerJson(
          id: 'builtin:zai-team', mode: 'team-coding-plan', entitled: false,
        ),
        providerJson(
          id: 'custom-2', group: 'standard-personal',
          accessType: 'api-key', accountType: null, mode: null, entitled: null,
          availability: '',
        ),
      ],
    });
    final entitled = view!.entitledAccountProviders;
    expect(entitled.length, 1);
    expect(entitled.single.providerId, 'builtin:zai-coding-plan');
  });

  test('3. unavailable 断连标记（hw 同构）', () {
    final view = ProviderSettingsView.fromJson({
      'providers': [providerJson(availability: 'unavailable')],
    });
    final p = view!.providers.single;
    expect(p.accountState?.unavailable, isTrue);
  });

  test('4. 密钥卫生：apiKey 只留尾缀，明文不落地', () {
    final view = ProviderSettingsView.fromJson({
      'providers': [
        providerJson(
          id: 'custom-3', group: 'standard-personal',
          accessType: 'api-key', accountType: null, mode: null, entitled: null,
          availability: '', apiKey: 'sk-secret-value-9f3ab2',
        ),
      ],
    });
    final access = view!.providers.single.effectiveConfig!.access!;
    expect(access.apiKeySuffix, '9f3ab2');
    final short = ZrProviderAccess.fromJson({
      'type': 'api-key', 'apiKey': 'abc',
    });
    expect(short!.apiKeySuffix, isNull);
  });

  test('5. 宽容解析：缺关键键条目丢弃、enabled/executable 缺省 true', () {
    final view = ProviderSettingsView.fromJson({
      'revision': 'not-num',
      'providers': [
        {'executable': true},
        providerJson(),
      ],
    });
    expect(view!.providers.length, 1);
    expect(view.revision, 0);
    final p = view.providers.single;
    expect(p.enabled, isTrue);
    expect(p.executable, isTrue);
    final bare = ZrProvider.fromJson({'providerId': 'x'});
    expect(bare!.displayName, 'x');
  });

  test('5b. 模型启停：effectiveConfig.enabled 缺省 true（官方开关同语义）', () {
    final view = ProviderSettingsView.fromJson({
      'providers': [
        providerJson(),
        providerJson(
          id: 'custom-x',
          group: 'standard-personal',
          accessType: 'api-key',
          accountType: null,
          mode: null,
          entitled: null,
          availability: '',
        ),
      ],
    });
    expect(view!.providers.first.models.first.enabled, isTrue);
    final off = ZrProviderModel.fromJson({
      'modelId': 'GLM-5.3',
      'effectiveConfig': {'enabled': false},
    });
    expect(off!.enabled, isFalse);
    final on = ZrProviderModel.fromJson({
      'modelId': 'GLM-5.3',
      'effectiveConfig': {'enabled': true},
    });
    expect(on!.enabled, isTrue);
  });

  test('6. 空回执判死：providers 键缺失/非列表 → null', () {
    expect(ProviderSettingsView.fromJson({}), isNull);
    expect(
      ProviderSettingsView.fromJson({'providers': 'oops'}),
      isNull,
    );
  });

  test('7. ModelSelectionView：供应商/模型计数 + 空回执判死', () {
    final sel = ModelSelectionView.fromJson({
      'revision': 3,
      'providers': [
        {'providerId': 'builtin:zai', 'models': [
          {'modelId': 'GLM-4.6'},
          {'modelId': 'GLM-4.5'},
        ]},
        {'providerId': 'custom-1', 'models': []},
      ],
    });
    expect(sel!.providerIds, ['builtin:zai', 'custom-1']);
    expect(sel.modelCount, 2);
    expect(ModelSelectionView.fromJson({}), isNull);
  });

  test('8. 连接设置投影：selections 解析 + rawSelections 保真', () {
    final s = ZrConnectionSettings.fromJson({
      'providerFamilyDomain': 'zai',
      'providerFamilyConnectionSelections': {
        'zai': {'kind': 'individual-coding-plan'},
        'bigmodel': {
          'kind': 'team-coding-plan',
          'productId': 'p1',
          'organizationId': 'o1',
          'projectId': 'j1',
        },
        'broken': {'noKind': 1},
      },
    });
    expect(s.familyDomain, 'zai');
    expect(s.selections['zai']!.kind, 'individual-coding-plan');
    final team = s.selections['bigmodel']!;
    expect(team.kind, 'team-coding-plan');
    expect(team.toRequestJson(), containsPair('productId', 'p1'));
    expect(s.rawSelections.length, 3);
    expect(s.rawSelections['broken'], isA<Map>());
  });

  test('9. 套餐权益投影：plan 名/配额行/MCP/宽容缺键', () {
    final ent = UsageEntitlement.fromJson({
      'authenticated': true,
      'generatedAt': 1780000000000,
      'subscription': {
        'details': [
          {'productId': 'glm-coding-max', 'productName': 'GLM Coding Max'},
        ],
      },
      'quota': {
        'level': 'max',
        'limits': [
          {
            'type': 'TOKENS_LIMIT', 'unit': 3, 'number': 5,
            'remaining': 465000, 'percentage': 7,
            'nextResetTime': '2026-09-25T00:00:00Z',
          },
          {
            'type': 'TOKENS_LIMIT', 'unit': 6,
            'percentage': 43,
            'nextResetTime': '2026-09-25T00:00:00Z',
          },
          {'type': 'TIME_LIMIT', 'unit': 5, 'number': 1, 'percentage': 5},
        ],
      },
      'mcpQuota': {'aggregate': {'percentage': 0}},
    });
    expect(ent!.planName, 'GLM Coding Max');
    expect(ent.planProductId, 'glm-coding-max');
    expect(ent.quotaLevel, 'max');
    expect(ent.limits.length, 3);
    expect(ent.limits.first.percentage, 7);
    expect(ent.noPlan, isFalse);
    expect(ent.mcpUsedPercentage, 0);
    final none = UsageEntitlement.fromJson({
      'authenticated': true, 'unavailableReason': 'no_plan', 'generatedAt': 1,
    });
    expect(none!.noPlan, isTrue);
    expect(UsageEntitlement.fromJson({}), isNull);
  });

  test('10. 建号模板目录：nameMap locale 直取 → en-US 回落 → templateId 兜底', () {
    final view = ProviderSettingsView.fromJson({
      'revision': 1,
      'providers': [providerJson()],
      'providerTemplates': [
        {
          'templateId': 'zai-api',
          'templateNameMap': {'zh-CN': 'Z.ai API', 'en-US': 'Z.ai API'},
        },
        {
          'templateId': 'openai',
          'templateNameMap': {'en-US': 'OpenAI Compatible'},
        },
        {'templateId': 'bare'},
        {'templateId': ''},
        'junk',
      ],
    });
    expect(view!.providerTemplates.length, 3);
    final zai = view.providerTemplates[0];
    expect(zai.isZhipuFamily, isTrue);
    expect(zai.displayName('zh-CN'), 'Z.ai API');
    final openai = view.providerTemplates[1];
    expect(openai.isZhipuFamily, isFalse);
    expect(openai.displayName('zh-CN'), 'OpenAI Compatible');
    expect(view.providerTemplates[2].displayName('zh-CN'), 'bare');
    final bare = ProviderSettingsView.fromJson({
      'revision': 1,
      'providers': [providerJson()],
    });
    expect(bare!.providerTemplates, isEmpty);
  });

  test('11. 生效面 api.type：接口协议初值（编辑弹层用）', () {
    final view = ProviderSettingsView.fromJson({
      'revision': 1,
      'providers': [
        providerJson(id: 'custom-1', group: 'standard-personal',
            accessType: 'api-key', accountType: null, mode: null,
            entitled: null, availability: '', apiKey: 'sk-abcdef123456',
            baseUrl: 'https://api.example.com/v1'),
      ],
    });
    expect(view!.byId('custom-1')!.effectiveConfig!.apiType, isNull);
    final typed = ZrEffectiveConfig.fromJson({
      'group': 'standard-personal',
      'api': {'type': 'openai-responses', 'baseUrl': 'https://x/v1'},
    });
    expect(typed!.apiType, 'openai-responses');
    expect(typed.baseUrl, 'https://x/v1');
  });

  test('12. 个人叠层原文：保真（含未变兄弟字段）+ 两个 model-id 目录剔除 + 缺席宽容', () {
    final view = ProviderSettingsView.fromJson({
      'revision': 1,
      'providers': [
        {
          'providerId': 'custom-1',
          'providerName': 'My OpenAI',
          'executable': true,
          'enabled': true,
          'personalConfig': {
            'group': 'standard-personal',
            'logo': 'openai',
            'modelOrder': ['gpt-x'],
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
              'baseUrl': 'https://api.example.com/v1',
              'headers': {'x-trace': '1'},
            },
          },
          'effectiveConfig': {
            'group': 'standard-personal',
            'access': {'type': 'api-key', 'apiKey': 'sk-abcdef123456'},
          },
          'models': const [],
        },
      ],
    });
    expect(view!.byId('custom-1')!.personalConfig, {
      'group': 'standard-personal',
      'logo': 'openai',
      'modelOrder': ['gpt-x'],
      'visibility': 'visible',
      'access': {
        'type': 'api-key',
        'apiKey': 'sk-abcdef123456',
        'apiKeyManagementUrl': 'https://keys.example.com',
      },
      'api': {
        'type': 'openai-chat-completions',
        'baseUrl': 'https://api.example.com/v1',
        'headers': {'x-trace': '1'},
      },
    });
    final bare = ProviderSettingsView.fromJson({
      'revision': 1,
      'providers': [providerJson()],
    });
    expect(bare!.byId('builtin:zai-coding-plan')!.personalConfig, isEmpty);
    expect(
      ZrProvider.fromJson({
        'providerId': 'x',
        'personalConfig': 'junk',
      })!.personalConfig,
      isEmpty,
    );
  });
}
