import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/models/model_draft.dart';
import 'package:zremote/models/provider_settings.dart';

void main() {
  const inheritedMap = '{"low":{"effort":"low"},"high":{"effort":"high"}}';

  Map<String, dynamic> inherited({
    int contextWindow = 200000,
    int? maxOut = 8192,
    List<String> levels = const ['low', 'high'],
    String map = inheritedMap,
    bool image = true,
    bool video = false,
    bool pdf = false,
  }) => {
    'properties': {
      'contextWindow': contextWindow,
      'supportsToolCall': true,
      'inputFormat': {
        'supportsText': true,
        'supportsImage': image,
        'supportsVideo': video,
        'supportsPdf': pdf,
      },
    },
    'optionSpecs': {
      'reasoningLevel': {'values': levels, 'map': map},
      if (maxOut != null) 'maxOutputTokens': {'max': maxOut},
    },
  };

  Map<String, dynamic> effective() => {
    'enabled': true,
    'properties': {
      'contextWindow': 8000,
      'supportsToolCall': true,
      'inputFormat': {'supportsText': true, 'supportsImage': false},
    },
    'optionSpecs': {
      'reasoningLevel': {'values': ['low'], 'map': '{"low":{"effort":"low"}}'},
    },
  };

  ZrProviderModel model({
    String id = 'gpt-x',
    Map<String, dynamic>? personal,
    Map<String, dynamic>? inherit,
    Map<String, dynamic>? eff,
    bool smart = true,
    bool enabled = true,
    bool builtin = false,
  }) => ZrProviderModel(
    modelId: id,
    personalConfig: personal ?? const {'properties': {'contextWindow': 8000}},
    inheritedConfig: inherit ?? inherited(),
    effectiveConfig: eff ?? effective(),
    useRecommendedConfig: smart,
    enabled: enabled,
    builtin: builtin,
  );

  group('建草稿（官方 F8）', () {
    test('文本槽取叠层值、开关位取生效面、覆盖登记取叠层显式键', () {
      final d = ZrModelDraft.forModel(
        model(
          personal: const {
            'properties': {
              'contextWindow': 8000,
              'supportsJsonSchemaOutput': true,
              'inputFormat': {'supportsImage': true},
            },
            'optionSpecs': {
              'reasoningLevel': {'values': ['low'], 'map': '{"low":1}'},
              'maxOutputTokens': {'max': 4096},
            },
          },
          eff: {
            'enabled': true,
            'properties': {
              'contextWindow': 8000,
              'supportsToolCall': true,
              'supportsJsonSchemaOutput': true,
              'inputFormat': {'supportsText': true, 'supportsImage': true},
            },
            'optionSpecs': {
              'reasoningLevel': {
                'values': ['low'],
                'map': '{"low":{"effort":"low"}}',
              },
            },
          },
        ),
      );
      expect(d.contextWindow, '8000');
      expect(d.maxOutputTokens, '4096');
      expect(d.reasoningLevelMap, '{"low":1}');
      expect(d.supportsJsonSchemaOutput, isTrue);
      expect(d.supportsImage, isTrue);
      expect(d.overridden, {
        'supportsJsonSchemaOutputValue',
        'reasoningLevelValuesValue',
        'inputFormatValue.supportsImage',
      });
    });

    test('候选占位：空 ID、智能配置开、空叠层', () {
      final d = ZrModelDraft.candidate();
      expect(d.modelId, '');
      expect(d.useRecommendedConfig, isTrue);
      expect(d.contextWindow, '');
      expect(d.reasoningLevels, isEmpty);
      expect(ZrModelDraft.candidate().copyWith(modelId: 'm1').validate(),
          'contextWindow');
    });
  });

  group('校验（官方 sUt 分支）', () {
    test('空 ID 先判', () {
      expect(ZrModelDraft.candidate().validate(), 'id');
    });

    test('智能配置开且无推荐面 → 上下文窗口缺失', () {
      final d = ZrModelDraft.candidate().copyWith(modelId: 'm1');
      expect(d.validate(), 'contextWindow');
    });

    test('智能配置开 → 推荐面兜底上下文窗口与最大输出', () {
      final d = ZrModelDraft.forModel(model()).copyWith(modelId: 'm1');
      expect(d.validate(), isNull);
    });

    test('智能配置关 → 上下文窗口与最大输出都必须手填', () {
      final d = ZrModelDraft.candidate().copyWith(
        modelId: 'm1',
        useRecommendedConfig: false,
      );
      expect(d.validate(), 'contextWindow');
      final d2 = d.copyWith(contextWindow: '1000');
      expect(d2.validate(), 'maxOutputTokens');
      final d3 = d2.copyWith(
        maxOutputTokens: '128',
        reasoningLevels: const ['low'],
        reasoningLevelMap: '{"low":1}',
      );
      expect(d3.validate(), isNull);
    });

    test('非正整数 / 重复等级 / 空等级', () {
      final base = ZrModelDraft.forModel(model()).copyWith(modelId: 'm1');
      expect(base.copyWith(contextWindow: '0').validate(), 'contextWindow');
      expect(base.copyWith(contextWindow: 'abc').validate(), 'contextWindow');
      expect(base.copyWith(maxOutputTokens: '0').validate(), 'maxOutputTokens');
      expect(
        base.copyWith(reasoningLevels: const []).validate(),
        'reasoningLevelValues',
      );
      expect(
        base.copyWith(reasoningLevels: const ['low', 'low']).validate(),
        'reasoningLevelValues',
      );
      expect(
        base.copyWith(reasoningLevels: const ['low', ' ']).validate(),
        'reasoningLevelValues',
      );
    });

    test('推理映射必须覆盖全部等级（可解析 JSON 对象 + 逐档有项）', () {
      final base = ZrModelDraft.forModel(
        model(),
      ).copyWith(modelId: 'm1', reasoningLevels: const ['low', 'high']);
      expect(
        base.copyWith(reasoningLevelMap: 'not-json').validate(),
        'reasoningLevelMap',
      );
      expect(
        base.copyWith(reasoningLevelMap: '{"low":1}').validate(),
        'reasoningLevelMap',
      );
      expect(
        base.copyWith(reasoningLevelMap: '{"low":1,"high":2}').validate(),
        isNull,
      );
      expect(base.copyWith(reasoningLevelMap: '').validate(), isNull);
    });

    test('错误字段 → 官方文案键名（inputFormat 在文案表里叫 inputModalities）', () {
      expect(ZrModelDraft.errorFieldKey('inputFormat'), 'inputModalities');
      expect(ZrModelDraft.errorFieldKey('id'), 'id');
    });
  });

  group('叠层构造（智能配置开 = 差分）', () {
    test('未变兄弟字段随整份发出（group / outputFormat 存活）', () {
      final d = ZrModelDraft.forModel(
        model(
          personal: const {
            'group': 'standard-personal',
            'properties': {
              'contextWindow': 8000,
              'outputFormat': {'supportsText': true},
            },
          },
        ),
      ).changed(contextWindow: '16000');
      final out = d.buildPersonalConfig();
      expect(out['group'], 'standard-personal');
      expect(out['properties']['outputFormat'], {'supportsText': true});
      expect(out['properties']['contextWindow'], 16000);
    });

    test('上下文窗口清空 = 去键回推荐面', () {
      final d = ZrModelDraft.forModel(model()).changed(contextWindow: '');
      expect(
        (d.buildPersonalConfig()['properties'] as Map).containsKey(
          'contextWindow',
        ),
        isFalse,
      );
    });

    test('模态与能力位按覆盖登记落叠层，未动的位不进叠层', () {
      final d = ZrModelDraft.forModel(
        model(eff: {
          'properties': {
            'contextWindow': 8000,
            'supportsToolCall': true,
            'supportsJsonSchemaOutput': true,
            'supportsNativeWebSearch': true,
            'supportsMidConversationSystem': true,
            'inputFormat': {
              'supportsText': true,
              'supportsImage': true,
              'supportsVideo': true,
              'supportsPdf': true,
            },
          },
          'optionSpecs': {
            'reasoningLevel': {
              'values': ['low'],
              'map': '{"low":{"effort":"low"}}',
            },
          },
        }),
      ).changed(supportsImage: false);
      final props = d.buildPersonalConfig()['properties'] as Map;
      expect(props['inputFormat'], {'supportsImage': false});
      expect(props.containsKey('supportsJsonSchemaOutput'), isFalse);
      expect(props.containsKey('supportsNativeWebSearch'), isFalse);
    });

    test('推理等级改动落 values、等于推荐面则去键；映射文本落 map', () {
      final base = ZrModelDraft.forModel(model());
      final changed = base
          .changed(reasoningLevels: const ['low', 'high', 'max'])
          .buildPersonalConfig();
      expect(
        ((changed['optionSpecs'] as Map)['reasoningLevel'] as Map)['values'],
        ['low', 'high', 'max'],
      );
      final back = base
          .changed(reasoningLevels: const ['low', 'high'])
          .buildPersonalConfig();
      expect(
        ((back['optionSpecs'] as Map)['reasoningLevel'] as Map)['values'],
        ['low', 'high'],
      );
      final mapped = base
          .changed(reasoningLevelMap: '{"low":1,"high":2}')
          .buildPersonalConfig();
      expect(
        ((mapped['optionSpecs'] as Map)['reasoningLevel'] as Map)['map'],
        '{"low":1,"high":2}',
      );
    });

    test('最大输出 Token 落 optionSpecs.maxOutputTokens.max', () {
      final d = ZrModelDraft.forModel(model()).changed(maxOutputTokens: '2048');
      final specs = d.buildPersonalConfig()['optionSpecs'] as Map;
      expect(specs['maxOutputTokens'], {'max': 2048});
    });
  });

  group('叠层构造（智能配置关 = 全量钉死，官方 lUt）', () {
    test('可编辑面全部显式写入 + 底座 enabled 保留', () {
      final d = ZrModelDraft.forModel(
        model(
          personal: const {'enabled': false, 'properties': {'contextWindow': 8000}},
          smart: false,
        ),
      ).withSmartConfig(false);
      final out = d.buildPersonalConfig();
      expect(out['enabled'], isFalse);
      final props = out['properties'] as Map;
      expect(props['contextWindow'], 8000);
      expect(props['supportsJsonSchemaOutput'], isFalse);
      expect(props['inputFormat'], {
        'supportsImage': false,
        'supportsVideo': false,
        'supportsPdf': false,
      });
      final specs = out['optionSpecs'] as Map;
      expect((specs['reasoningLevel'] as Map)['values'], ['low']);
      expect(specs['maxOutputTokens'], {'max': 8192});
    });
  });

  group('推荐面取数与恢复默认', () {
    test('resolved：未覆盖字段按推荐面回填，覆盖过的保留', () {
      final d = ZrModelDraft.forModel(
        model(
          personal: const {
            'properties': {
              'contextWindow': 8000,
              'inputFormat': {'supportsImage': true},
            },
          },
        ),
      );
      expect(d.overridden, {'inputFormatValue.supportsImage'});
      final r = d.resolved(inherited(contextWindow: 128000, levels: const ['x']));
      expect(r.supportsImage, isFalse);
      expect(r.reasoningLevels, const ['x']);
      expect(r.inheritedConfig['properties']['contextWindow'], 128000);
      final plain = ZrModelDraft.forModel(model()).resolved(
        inherited(levels: const ['x']),
      );
      expect(plain.supportsImage, isTrue);
    });

    test('restored：底座清空标记 + 推荐面回填 + 智能配置重开', () {
      final d = ZrModelDraft.forModel(model()).restored();
      expect(d.clearPersonalConfig, isTrue);
      expect(d.useRecommendedConfig, isTrue);
      expect(d.contextWindow, '');
      expect(d.reasoningLevels, const ['low', 'high']);
      final out = d.buildPersonalConfig();
      expect(out.containsKey('group'), isFalse);
      expect((out['properties'] as Map).containsKey('contextWindow'), isFalse);
    });

    test('withSmartConfig(true) 等价恢复默认；false 时空槽按推荐面补值', () {
      final on = ZrModelDraft.forModel(model()).withSmartConfig(true);
      expect(on.clearPersonalConfig, isTrue);
      final off = ZrModelDraft.forModel(model()).withSmartConfig(false);
      expect(off.useRecommendedConfig, isFalse);
      expect(off.contextWindow, '8000');
      expect(off.maxOutputTokens, '8192');
      expect(off.reasoningLevelMap, inheritedMap);
    });
  });

  group('无操作短路与覆盖标记', () {
    test('isNoopAgainst：ID / 开关 / 叠层三者都没变才免写', () {
      final m = model();
      final overlay = ZrModelDraft.forModel(m).buildPersonalConfig();
      final round = model(personal: overlay);
      expect(ZrModelDraft.forModel(round).isNoopAgainst(round), isTrue);
      final d = ZrModelDraft.forModel(round);
      expect(d.changed(contextWindow: '16000').isNoopAgainst(round), isFalse);
      expect(d.copyWith(modelId: 'renamed').isNoopAgainst(round), isFalse);
      expect(
        d.copyWith(useRecommendedConfig: false).isNoopAgainst(round),
        isFalse,
      );
      expect(d.isNoopAgainst(m), isFalse);
    });

    test('displayOverrides：智能配置关时为空集；开时文本槽非空即标记', () {
      final on = ZrModelDraft.forModel(model()).changed(contextWindow: '16000');
      expect(on.displayOverrides, contains('contextWindowValue'));
      expect(on.showsOverride('contextWindowValue'), isTrue);
      final off = ZrModelDraft.forModel(model(smart: false));
      expect(off.displayOverrides, isEmpty);
      expect(off.showsOverride('contextWindowValue'), isFalse);
    });
  });

  group('线格式', () {
    test('叠层是可 JSON 序列化的纯对象（写回载荷）', () {
      final out = ZrModelDraft.forModel(model())
          .changed(contextWindow: '16000', reasoningLevels: const ['low', 'high'])
          .buildPersonalConfig();
      expect(jsonDecode(jsonEncode(out)), out);
    });
  });
}
