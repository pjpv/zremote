import 'dart:convert';

import 'provider_settings.dart';

class ZrModelDraft {
  const ZrModelDraft({
    required this.modelId,
    required this.useRecommendedConfig,
    required this.contextWindow,
    required this.maxOutputTokens,
    required this.supportsText,
    required this.supportsImage,
    required this.supportsVideo,
    required this.supportsPdf,
    required this.supportsJsonSchemaOutput,
    required this.supportsNativeWebSearch,
    required this.supportsMidConversationSystem,
    required this.reasoningLevels,
    required this.reasoningLevelMap,
    required this.overridden,
    required this.clearPersonalConfig,
    required this.enabled,
    required this.builtin,
    required this.sourcePersonalConfig,
    required this.sourceEffectiveConfig,
    required this.inheritedConfig,
  });

  final String modelId;

  final bool useRecommendedConfig;

  final String contextWindow;

  final String maxOutputTokens;

  final bool supportsText;
  final bool supportsImage;
  final bool supportsVideo;
  final bool supportsPdf;

  final bool supportsJsonSchemaOutput;
  final bool supportsNativeWebSearch;
  final bool supportsMidConversationSystem;

  final List<String> reasoningLevels;

  final String reasoningLevelMap;

  final Set<String> overridden;

  final bool clearPersonalConfig;

  final bool enabled;

  final bool builtin;

  final Map<String, dynamic> sourcePersonalConfig;

  final Map<String, dynamic> sourceEffectiveConfig;

  final Map<String, dynamic> inheritedConfig;

  static const List<String> _capabilityKeys = [
    'supportsJsonSchemaOutput',
    'supportsNativeWebSearch',
    'supportsMidConversationSystem',
  ];
  static const List<String> _modalityKeys = [
    'supportsImage',
    'supportsVideo',
    'supportsPdf',
  ];

  factory ZrModelDraft.forModel(ZrProviderModel m) => ZrModelDraft(
    modelId: m.modelId,
    useRecommendedConfig: m.useRecommendedConfig,
    contextWindow: _personalInt(m.personalConfig, 'contextWindow')?.toString() ?? '',
    maxOutputTokens: _personalMax(m.personalConfig)?.toString() ?? '',
    supportsText: _boolOr(m.inputFormat['supportsText'], true),
    supportsImage: _boolOr(m.inputFormat['supportsImage'], false),
    supportsVideo: _boolOr(m.inputFormat['supportsVideo'], false),
    supportsPdf: _boolOr(m.inputFormat['supportsPdf'], false),
    supportsJsonSchemaOutput: _boolOr(
      m.properties['supportsJsonSchemaOutput'],
      false,
    ),
    supportsNativeWebSearch: _boolOr(
      m.properties['supportsNativeWebSearch'],
      false,
    ),
    supportsMidConversationSystem: _boolOr(
      m.properties['supportsMidConversationSystem'],
      false,
    ),
    reasoningLevels: m.reasoningLevels,
    reasoningLevelMap: m.reasoningLevelMap ?? '',
    overridden: _personalOverrides(m.personalConfig),
    clearPersonalConfig: false,
    enabled: m.enabled,
    builtin: m.isBuiltin,
    sourcePersonalConfig: m.personalConfig,
    sourceEffectiveConfig: m.effectiveConfig,
    inheritedConfig: m.inheritedConfig,
  );

  factory ZrModelDraft.candidate() => const ZrModelDraft(
    modelId: '',
    useRecommendedConfig: true,
    contextWindow: '',
    maxOutputTokens: '',
    supportsText: true,
    supportsImage: false,
    supportsVideo: false,
    supportsPdf: false,
    supportsJsonSchemaOutput: false,
    supportsNativeWebSearch: false,
    supportsMidConversationSystem: false,
    reasoningLevels: [],
    reasoningLevelMap: '',
    overridden: {},
    clearPersonalConfig: false,
    enabled: true,
    builtin: false,
    sourcePersonalConfig: {},
    sourceEffectiveConfig: {
      'properties': {'supportsToolCall': true},
    },
    inheritedConfig: {},
  );

  ZrModelDraft copyWith({
    String? modelId,
    bool? useRecommendedConfig,
    String? contextWindow,
    String? maxOutputTokens,
    bool? supportsText,
    bool? supportsImage,
    bool? supportsVideo,
    bool? supportsPdf,
    bool? supportsJsonSchemaOutput,
    bool? supportsNativeWebSearch,
    bool? supportsMidConversationSystem,
    List<String>? reasoningLevels,
    String? reasoningLevelMap,
    Set<String>? overridden,
    bool? clearPersonalConfig,
    bool? enabled,
    bool? builtin,
    Map<String, dynamic>? sourcePersonalConfig,
    Map<String, dynamic>? sourceEffectiveConfig,
    Map<String, dynamic>? inheritedConfig,
  }) => ZrModelDraft(
    modelId: modelId ?? this.modelId,
    useRecommendedConfig: useRecommendedConfig ?? this.useRecommendedConfig,
    contextWindow: contextWindow ?? this.contextWindow,
    maxOutputTokens: maxOutputTokens ?? this.maxOutputTokens,
    supportsText: supportsText ?? this.supportsText,
    supportsImage: supportsImage ?? this.supportsImage,
    supportsVideo: supportsVideo ?? this.supportsVideo,
    supportsPdf: supportsPdf ?? this.supportsPdf,
    supportsJsonSchemaOutput:
        supportsJsonSchemaOutput ?? this.supportsJsonSchemaOutput,
    supportsNativeWebSearch:
        supportsNativeWebSearch ?? this.supportsNativeWebSearch,
    supportsMidConversationSystem:
        supportsMidConversationSystem ?? this.supportsMidConversationSystem,
    reasoningLevels: reasoningLevels ?? this.reasoningLevels,
    reasoningLevelMap: reasoningLevelMap ?? this.reasoningLevelMap,
    overridden: overridden ?? this.overridden,
    clearPersonalConfig: clearPersonalConfig ?? this.clearPersonalConfig,
    enabled: enabled ?? this.enabled,
    builtin: builtin ?? this.builtin,
    sourcePersonalConfig: sourcePersonalConfig ?? this.sourcePersonalConfig,
    sourceEffectiveConfig: sourceEffectiveConfig ?? this.sourceEffectiveConfig,
    inheritedConfig: inheritedConfig ?? this.inheritedConfig,
  );

  ZrModelDraft changed({
    String? modelId,
    String? contextWindow,
    String? maxOutputTokens,
    bool? supportsImage,
    bool? supportsVideo,
    bool? supportsPdf,
    bool? supportsJsonSchemaOutput,
    bool? supportsNativeWebSearch,
    bool? supportsMidConversationSystem,
    List<String>? reasoningLevels,
    String? reasoningLevelMap,
  }) {
    final marked = <String>{...overridden};
    if (supportsJsonSchemaOutput != null) {
      marked.add('supportsJsonSchemaOutputValue');
    }
    if (supportsNativeWebSearch != null) {
      marked.add('supportsNativeWebSearchValue');
    }
    if (supportsMidConversationSystem != null) {
      marked.add('supportsMidConversationSystemValue');
    }
    if (reasoningLevels != null) marked.add('reasoningLevelValuesValue');
    if (supportsImage != null && supportsImage != this.supportsImage) {
      marked.add('inputFormatValue.supportsImage');
    }
    if (supportsVideo != null && supportsVideo != this.supportsVideo) {
      marked.add('inputFormatValue.supportsVideo');
    }
    if (supportsPdf != null && supportsPdf != this.supportsPdf) {
      marked.add('inputFormatValue.supportsPdf');
    }
    return copyWith(
      modelId: modelId,
      contextWindow: contextWindow,
      maxOutputTokens: maxOutputTokens,
      supportsImage: supportsImage,
      supportsVideo: supportsVideo,
      supportsPdf: supportsPdf,
      supportsJsonSchemaOutput: supportsJsonSchemaOutput,
      supportsNativeWebSearch: supportsNativeWebSearch,
      supportsMidConversationSystem: supportsMidConversationSystem,
      reasoningLevels: reasoningLevels,
      reasoningLevelMap: reasoningLevelMap,
      overridden: marked,
    );
  }

  ZrModelDraft resolved(Map<String, dynamic> resolvedInherited) {
    final next = copyWith(inheritedConfig: resolvedInherited);
    if (!next.useRecommendedConfig) return next;
    final base = ZrModelDraft.forModel(
      ZrProviderModel(
        modelId: next.modelId,
        personalConfig: const {},
        effectiveConfig: resolvedInherited,
        inheritedConfig: resolvedInherited,
        enabled: next.enabled,
      ),
    );
    bool keep(String field, bool current, bool inherited) =>
        next.overridden.contains(field) ? current : inherited;
    return next.copyWith(
      supportsJsonSchemaOutput: keep(
        'supportsJsonSchemaOutputValue',
        next.supportsJsonSchemaOutput,
        base.supportsJsonSchemaOutput,
      ),
      supportsNativeWebSearch: keep(
        'supportsNativeWebSearchValue',
        next.supportsNativeWebSearch,
        base.supportsNativeWebSearch,
      ),
      supportsMidConversationSystem: keep(
        'supportsMidConversationSystemValue',
        next.supportsMidConversationSystem,
        base.supportsMidConversationSystem,
      ),
      reasoningLevels: next.overridden.contains('reasoningLevelValuesValue')
          ? next.reasoningLevels
          : base.reasoningLevels,
      supportsText: keep('inputFormatValue.supportsText', next.supportsText, base.supportsText),
      supportsImage: keep('inputFormatValue.supportsImage', next.supportsImage, base.supportsImage),
      supportsVideo: keep('inputFormatValue.supportsVideo', next.supportsVideo, base.supportsVideo),
      supportsPdf: keep('inputFormatValue.supportsPdf', next.supportsPdf, base.supportsPdf),
    );
  }

  ZrModelDraft restored() {
    final inherit = inheritedConfig;
    final base = ZrModelDraft.forModel(
      ZrProviderModel(
        modelId: modelId,
        personalConfig: const {},
        effectiveConfig: inherit,
        inheritedConfig: inherit,
        enabled: enabled,
      ),
    );
    return base.copyWith(
      modelId: modelId,
      enabled: enabled,
      clearPersonalConfig: true,
      overridden: const {},
    );
  }

  ZrModelDraft withSmartConfig(bool on) {
    if (on) return restored();
    final fallback = inheritedConfig.isNotEmpty
        ? inheritedConfig
        : sourceEffectiveConfig;
    final props = _asMap(fallback['properties']);
    final specs = _asMap(fallback['optionSpecs']);
    final fallbackMap = _reasoningMapText(
      _asMap(specs['reasoningLevel'])['map'],
    );
    return copyWith(
      useRecommendedConfig: false,
      contextWindow: contextWindow.isNotEmpty
          ? contextWindow
          : (_intOr(props['contextWindow'])?.toString() ?? ''),
      maxOutputTokens: maxOutputTokens.isNotEmpty
          ? maxOutputTokens
          : (_intOr(_asMap(specs['maxOutputTokens'])['max'])?.toString() ?? ''),
      reasoningLevelMap: reasoningLevelMap.isNotEmpty
          ? reasoningLevelMap
          : (fallbackMap ?? ''),
    );
  }

  Set<String> get displayOverrides {
    if (!useRecommendedConfig) return const {};
    final set = <String>{...overridden};
    void mark(String key, String text) {
      if (text.trim().isNotEmpty) {
        set.add(key);
      } else {
        set.remove(key);
      }
    }

    mark('contextWindowValue', contextWindow);
    mark('maxOutputTokensValue', maxOutputTokens);
    mark('reasoningLevelMapValue', reasoningLevelMap);
    return set;
  }

  bool showsOverride(String field, {bool fallback = false}) =>
      useRecommendedConfig && (displayOverrides.contains(field) || fallback);

  String? validate() {
    if (modelId.trim().isEmpty) return 'id';
    final smart = useRecommendedConfig;
    final inherited = smart ? inheritedConfig : const <String, dynamic>{};

    final cwText = contextWindow.trim();
    final cw = cwText.isNotEmpty
        ? _positiveInt(cwText)
        : _intOr(_asMap(inherited['properties'])['contextWindow']);
    if (cw == null) return 'contextWindow';

    final moText = maxOutputTokens.trim();
    final mo = moText.isNotEmpty ? _positiveInt(moText) : null;
    if (moText.isNotEmpty && mo == null) return 'maxOutputTokens';
    if (moText.isEmpty && !smart) return 'maxOutputTokens';

    if (!supportsText) return 'inputFormat';

    final levels = [for (final e in reasoningLevels) e.trim()];
    if (levels.isEmpty || levels.any((e) => e.isEmpty)) {
      return 'reasoningLevelValues';
    }
    if (levels.toSet().length != levels.length) return 'reasoningLevelValues';

    final mapText = reasoningLevelMap.trim();
    final map = mapText.isNotEmpty ? mapText : _inheritedReasoningMap(inherited);
    if (map == null || !_reasoningMapCoversLevels(map, levels)) {
      return 'reasoningLevelMap';
    }
    return null;
  }

  static String errorFieldKey(String field) =>
      field == 'inputFormat' ? 'inputModalities' : field;

  Map<String, dynamic> buildPersonalConfig() {
    final smart = useRecommendedConfig;
    final inherited = smart ? inheritedConfig : const <String, dynamic>{};

    final base = clearPersonalConfig
        ? <String, dynamic>{}
        : _deepCopy(sourcePersonalConfig);
    final eff = clearPersonalConfig
        ? <String, dynamic>{
            ...inheritedConfig,
            'enabled': sourceEffectiveConfig['enabled'],
          }
        : sourceEffectiveConfig;

    final cw =
        _positiveInt(contextWindow.trim()) ??
        _intOr(_asMap(inherited['properties'])['contextWindow']) ??
        0;
    final moText = maxOutputTokens.trim();
    final mo = moText.isEmpty ? null : _positiveInt(moText);
    final levels = [for (final e in reasoningLevels) e.trim()];
    final mapText = reasoningLevelMap.trim();
    final map = mapText.isNotEmpty
        ? mapText
        : (_inheritedReasoningMap(inherited) ?? '');

    final srcProps = _asMap(eff['properties']);
    final srcFmt = _asMap(srcProps['inputFormat']);
    final inheritedProps = _asMap(inherited['properties']);
    final inheritedFmt = _asMap(inheritedProps['inputFormat']);
    final srcSpecs = _asMap(eff['optionSpecs']);
    final inheritedMaxOut = _asMap(
      _asMap(inherited['optionSpecs'])['maxOutputTokens'],
    );

    final newProps = <String, dynamic>{
      'requiresMfjsToolSchema': srcProps['requiresMfjsToolSchema'],
      'contextWindow': cw,
      'inputFormat': <String, dynamic>{
        ...srcFmt,
        'supportsImage': supportsImage,
        'supportsVideo': supportsVideo,
        'supportsPdf': supportsPdf,
      },
      'outputFormat': srcProps['outputFormat'],
      'supportsToolCall': srcProps['supportsToolCall'],
      'supportsJsonSchemaOutput': supportsJsonSchemaOutput,
      'supportsNativeWebSearch': supportsNativeWebSearch,
      'supportsMidConversationSystem': supportsMidConversationSystem,
    };
    final newSpecs = <String, dynamic>{
      ...srcSpecs,
      'reasoningLevel': <String, dynamic>{'values': levels, 'map': map},
    };
    if (mo != null) {
      newSpecs['maxOutputTokens'] = <String, dynamic>{
        ..._asMap(srcSpecs['maxOutputTokens']),
        'max': mo,
      };
    } else if (inheritedMaxOut.isEmpty) {
      newSpecs.remove('maxOutputTokens');
    } else {
      newSpecs['maxOutputTokens'] = inheritedMaxOut;
    }

    if (!smart) {
      final pinProps = <String, dynamic>{
        'contextWindow': newProps['contextWindow'],
        'supportsJsonSchemaOutput': newProps['supportsJsonSchemaOutput'],
        'supportsNativeWebSearch': newProps['supportsNativeWebSearch'],
        'supportsMidConversationSystem': newProps['supportsMidConversationSystem'],
        'inputFormat': <String, dynamic>{
          'supportsImage': _asMap(newProps['inputFormat'])['supportsImage'],
          'supportsVideo': _asMap(newProps['inputFormat'])['supportsVideo'],
          'supportsPdf': _asMap(newProps['inputFormat'])['supportsPdf'],
        },
      };
      final pinSpecs = <String, dynamic>{
        'reasoningLevel': _asMap(newSpecs['reasoningLevel']),
        if (_asMap(newSpecs['maxOutputTokens'])['max'] != null)
          'maxOutputTokens': <String, dynamic>{
            'max': _asMap(newSpecs['maxOutputTokens'])['max'],
          },
      };
      return <String, dynamic>{
        if (base['enabled'] != null) 'enabled': base['enabled'],
        'properties': pinProps,
        'optionSpecs': pinSpecs,
      };
    }

    final props = <String, dynamic>{..._asMap(base['properties'])};
    _foldInherited(props, 'contextWindow', cw, inheritedProps['contextWindow']);
    for (final k in _capabilityKeys) {
      _foldIfEffectiveChanged(
        props,
        k,
        newProps[k],
        srcProps[k],
        inheritedProps[k],
      );
    }
    final fmt = <String, dynamic>{..._asMap(props['inputFormat'])};
    for (final k in _modalityKeys) {
      _foldIfEffectiveChanged(
        fmt,
        k,
        newProps['inputFormat'][k],
        srcFmt[k],
        inheritedFmt[k],
      );
    }
    if (fmt.isEmpty) {
      props.remove('inputFormat');
    } else {
      props['inputFormat'] = fmt;
    }
    if (contextWindow.trim().isNotEmpty) {
      props['contextWindow'] = cw;
    } else {
      props.remove('contextWindow');
    }
    for (final k in _capabilityKeys) {
      if (overridden.contains('${k}Value')) props[k] = newProps[k];
    }
    for (final k in _modalityKeys) {
      final drafted = _draftModality(k);
      if (overridden.contains('inputFormatValue.$k') || drafted != srcFmt[k]) {
        props['inputFormat'] = <String, dynamic>{
          ..._asMap(props['inputFormat']),
          k: drafted,
        };
      }
    }

    final out = <String, dynamic>{...base};
    if (base['enabled'] != null) out['enabled'] = base['enabled'];
    if (props.isEmpty) {
      out.remove('properties');
    } else {
      out['properties'] = props;
    }

    final specs = <String, dynamic>{..._asMap(base['optionSpecs'])};
    final personalLevels = _asMap(specs['reasoningLevel']);
    final effectiveLevels = _stringList(
      _asMap(srcSpecs['reasoningLevel'])['values'],
    );
    final inheritedReasoning = _asMap(
      _asMap(inherited['optionSpecs'])['reasoningLevel'],
    );
    final inheritedLevels = _stringList(inheritedReasoning['values']);
    final levelOverlay = <String, dynamic>{...personalLevels};
    if (!_sameLevels(levels, effectiveLevels)) {
      if (_sameLevels(levels, inheritedLevels)) {
        levelOverlay.remove('values');
      } else {
        levelOverlay['values'] = [...levels];
      }
    }
    if (mapText.isEmpty ||
        mapText == _reasoningMapText(inheritedReasoning['map'])) {
      levelOverlay.remove('map');
    } else {
      levelOverlay['map'] = mapText;
    }
    if (levelOverlay.isEmpty) {
      specs.remove('reasoningLevel');
    } else {
      specs['reasoningLevel'] = levelOverlay;
    }
    if (overridden.contains('reasoningLevelValuesValue')) {
      specs['reasoningLevel'] = <String, dynamic>{
        ..._asMap(specs['reasoningLevel']),
        'values': [...levels],
      };
    }
    if (mapText.isNotEmpty) {
      specs['reasoningLevel'] = <String, dynamic>{
        ..._asMap(specs['reasoningLevel']),
        'map': mapText,
      };
    }
    final personalMaxOut = _asMap(
      _asMap(base['optionSpecs'])['maxOutputTokens'],
    );
    if (mo != null) {
      specs['maxOutputTokens'] = <String, dynamic>{
        if (personalMaxOut['map'] != null) 'map': personalMaxOut['map'],
        'max': mo,
      };
    } else if (personalMaxOut['map'] == null) {
      specs.remove('maxOutputTokens');
    } else {
      specs['maxOutputTokens'] = <String, dynamic>{
        'map': personalMaxOut['map'],
      };
    }
    if (specs.isEmpty) {
      out.remove('optionSpecs');
    } else {
      out['optionSpecs'] = specs;
    }
    return out;
  }

  bool isNoopAgainst(ZrProviderModel m) =>
      modelId.trim() == m.modelId &&
      useRecommendedConfig == m.useRecommendedConfig &&
      _deepEquals(buildPersonalConfig(), m.personalConfig);

  bool _draftModality(String key) => switch (key) {
    'supportsImage' => supportsImage,
    'supportsVideo' => supportsVideo,
    _ => supportsPdf,
  };

  static void _foldInherited(
    Map<String, dynamic> target,
    String key,
    Object? value,
    Object? inheritedValue,
  ) {
    if (_sameScalar(value, inheritedValue)) {
      target.remove(key);
    } else {
      target[key] = value;
    }
  }

  static void _foldIfEffectiveChanged(
    Map<String, dynamic> target,
    String key,
    Object? newEffective,
    Object? currentEffective,
    Object? inheritedValue,
  ) {
    if (_sameScalar(newEffective, currentEffective)) return;
    _foldInherited(target, key, newEffective, inheritedValue);
  }

  static bool _sameScalar(Object? a, Object? b) => a == b;

  static bool _sameLevels(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static List<String> _stringList(Object? raw) =>
      raw is List ? [for (final e in raw) if (e is String) e] : const [];

  static bool _reasoningMapCoversLevels(String mapText, List<String> levels) {
    final parsed = _tryJsonObject(mapText);
    if (parsed == null) return false;
    for (final lv in levels) {
      if (!parsed.containsKey(lv)) return false;
    }
    return true;
  }

  static Map<String, dynamic>? _tryJsonObject(String text) {
    try {
      final decoded = jsonDecode(text);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  static String? _reasoningMapText(Object? raw) {
    if (raw is String) return raw.trim().isEmpty ? null : raw;
    if (raw is Map && raw.isNotEmpty) return jsonEncode(raw);
    return null;
  }

  static String? _inheritedReasoningMap(Map<String, dynamic> inherited) =>
      _reasoningMapText(
        _asMap(_asMap(inherited['optionSpecs'])['reasoningLevel'])['map'],
      );

  static Map<String, dynamic> _asMap(Object? raw) =>
      raw is Map<String, dynamic> ? raw : const {};

  static Map<String, dynamic> _deepCopy(Map<String, dynamic> src) =>
      jsonDecode(jsonEncode(src)) as Map<String, dynamic>;

  static bool _deepEquals(Object? a, Object? b) => _deepCompare(a, b);

  static bool _deepCompare(Object? a, Object? b) {
    if (identical(a, b)) return true;
    if (a is Map && b is Map) {
      if (a.length != b.length) return false;
      for (final k in a.keys) {
        if (!b.containsKey(k) || !_deepCompare(a[k], b[k])) return false;
      }
      return true;
    }
    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (var i = 0; i < a.length; i++) {
        if (!_deepCompare(a[i], b[i])) return false;
      }
      return true;
    }
    return a == b;
  }

  static bool _boolOr(Object? raw, bool fallback) =>
      raw is bool ? raw : fallback;

  static int? _intOr(Object? raw) => raw is num && raw > 0 ? raw.toInt() : null;

  static int? _positiveInt(String text) {
    final n = int.tryParse(text.trim());
    return n != null && n > 0 ? n : null;
  }

  static int? _personalInt(Map<String, dynamic> personalConfig, String key) =>
      _intOr(_asMap(personalConfig['properties'])[key]);

  static int? _personalMax(Map<String, dynamic> personalConfig) => _intOr(
    _asMap(_asMap(personalConfig['optionSpecs'])['maxOutputTokens'])['max'],
  );

  static Set<String> _personalOverrides(Map<String, dynamic> personalConfig) {
    final set = <String>{};
    final props = _asMap(personalConfig['properties']);
    for (final k in _capabilityKeys) {
      if (props[k] != null) set.add('${k}Value');
    }
    final levels = _asMap(_asMap(personalConfig['optionSpecs'])['reasoningLevel']);
    if (levels['values'] != null) set.add('reasoningLevelValuesValue');
    final fmt = _asMap(props['inputFormat']);
    for (final k in fmt.keys) {
      if (fmt[k] != null) set.add('inputFormatValue.$k');
    }
    return set;
  }
}
