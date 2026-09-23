import 'package:flutter/foundation.dart';

import 'rpc_bridge.dart';

abstract final class ServiceProbe {
  static const List<String> candidateKeys = [
    'fileService',
    'mediaPreviewService',
    'gitService',
    'gitCheckpointService',
    'systemService',
    'terminalService',
    'settingService',
    'onboardingRecordService',
    'credentialService',
    'broadcastService',
    'zcodeTaskService',
    'windowControllerService',
    'zcodeAgentService',
    'zcodeSessionService',
    'cuaPermissionService',
    'conversationShareService',
    'fileWatcherService',
    'oauthService',
    'providerSettingsService',
    'modelSelectionService',
    'providerProvisioningTargetService',
    'usageStatsService',
    'codingPlanSubscriptionService',
    'clientConfigService',
    'clientScenesService',
    'offPeakTaskService',
    'skillsService',
    'skillSyncService',
    'mcpSyncService',
    'pluginSyncService',
    'pluginsService',
    'pluginManagementService',
    'subagentsService',
    'commandsService',
    'hooksService',
    'memoryService',
    'settingsSyncService',
    'feedbackService',
    'promptAttachmentTransferService',
  ];

  static const Map<String, List<String>> methodChecks = {
    'usageStatsService': [
      'getEntitlementSnapshot',
      'getAppUsageSnapshot',
      'getCodingPlanUsageSnapshot',
      'useCodingPlanReset',
    ],
    'zcodeTaskService': [
      'respondPermission',
      'respondElicitation',
      'stopGeneration',
      'renameTask',
    ],
    'windowControllerService': [
      'listTaskList',
      'mutateTask',
      'subscribeControllerV4',
    ],
    'zcodeAgentService': [
      'listAutomationRuns',
      'restartAutomation',
      'listSavedWorkflows',
    ],
    'offPeakTaskService': [
      'getCodingPlanSupport',
      'getTakeNumberAvailability',
      'deleteHistory',
    ],
    'settingService': ['get', 'update'],
    'providerSettingsService': [
      'getView',
      'savePersonalProviderOverlay',
      'testModelConnectivity',
    ],
    'modelSelectionService': ['getView'],
    'codingPlanSubscriptionService': [
      'getManualClaimPlanPreviews',
      'getCaptchaConfig',
    ],
    'skillsService': ['list', 'setEnabled'],
    'pluginManagementService': ['getPluginsOverview', 'listPlugins'],
    'mcpSyncService': ['listWorkspaceMcpServerStatuses'],
    'subagentsService': ['list'],
    'commandsService': ['list'],
    'hooksService': ['loadHooks'],
    'memoryService': ['listProjectMemories'],
    'gitService': ['getRepositorySummary'],
    'oauthService': ['getProviders'],
    'conversationShareService': ['getCapabilities'],
    'feedbackService': ['getDeviceSnapshot'],
    'systemService': ['info'],
    'clientConfigService': ['getSnapshot'],
  };

  static const List<({String channel, String service, String method})>
  liveCalls = [
    (
      channel: 'off-peak-task',
      service: 'offPeakTaskService',
      method: 'getCodingPlanSupport',
    ),
    (
      channel: 'usage-stats',
      service: 'usageStatsService',
      method: 'getEntitlementSnapshot',
    ),
  ];

  static const Duration callTimeout = Duration(seconds: 10);

  static const Duration noServicesRetryDelay = Duration(seconds: 3);
  static const int noServicesMaxAttempts = 10;

  static const int errorMaxChars = 200;

  static Future<Map<String, Object?>> run(
    RpcBridge bridge, {
    Duration timeout = callTimeout,
    Duration retryDelay = noServicesRetryDelay,
    int noServicesAttempts = noServicesMaxAttempts,
  }) async {
    final dump = await _retryOnNoServices(
      'dump',
      () => _dump(bridge, timeout),
      retryDelay,
      noServicesAttempts,
    );
    final calls = <Map<String, Object?>>[
      for (final call in liveCalls)
        await _retryOnNoServices(
          'live ${call.service}.${call.method}',
          () => _liveCall(bridge, call, timeout),
          retryDelay,
          noServicesAttempts,
        ),
    ];
    final report = <String, Object?>{
      'at': DateTime.now().toIso8601String(),
      'device': bridge.deviceId,
      'dump': dump,
      'liveCalls': calls,
    };
    _log(report);
    return report;
  }

  static Future<Map<String, Object?>> _retryOnNoServices(
    String label,
    Future<Map<String, Object?>> Function() attempt,
    Duration delay,
    int attempts,
  ) async {
    var tried = 0;
    while (true) {
      final result = await attempt();
      tried += 1;
      final error = result['error'];
      if (result['ok'] == true ||
          tried >= attempts ||
          error is! String ||
          !error.contains('no-services')) {
        return result;
      }
      debugPrint('[probe] $label retry on no-services ($tried/$attempts)');
      await Future<void>.delayed(delay);
    }
  }

  static Future<Map<String, Object?>> _dump(
    RpcBridge bridge,
    Duration timeout,
  ) async {
    final checklist = <Map<String, Object?>>[
      for (final entry in methodChecks.entries)
        {'s': entry.key, 'm': entry.value},
    ];
    try {
      final response = await bridge.callArgs(
        'zr-probe',
        'dump',
        args: [checklist],
        timeout: timeout,
      );
      final payload = response.firstObject;
      final rawKeys = payload?['keys'];
      final rawChecks = payload?['checks'];
      if (payload == null || rawKeys is! List || rawChecks is! Map) {
        return {'ok': false, 'error': 'bad-dump-shape'};
      }
      final keys = [
        for (final key in rawKeys)
          if (key is String) key,
      ];
      final keySet = keys.toSet();
      return {
        'ok': true,
        'error': null,
        'keys': keys,
        'missing': [
          for (final key in candidateKeys)
            if (!keySet.contains(key)) key,
        ],
        'checks': <String, Object?>{
          for (final entry in rawChecks.entries)
            if (entry.key is String) entry.key: entry.value,
        },
      };
    } catch (e) {
      return {'ok': false, 'error': _clip(e.toString())};
    }
  }

  static Future<Map<String, Object?>> _liveCall(
    RpcBridge bridge,
    ({String channel, String service, String method}) call,
    Duration timeout,
  ) async {
    try {
      await bridge.call(call.channel, call.method, timeout: timeout);
      return {
        'service': call.service,
        'method': call.method,
        'ok': true,
        'error': null,
      };
    } catch (e) {
      return {
        'service': call.service,
        'method': call.method,
        'ok': false,
        'error': _clip(e.toString()),
      };
    }
  }

  static void _log(Map<String, Object?> report) {
    final dump = report['dump'] as Map<String, Object?>;
    if (dump['ok'] == true) {
      final keys = (dump['keys'] as List).whereType<String>().toList();
      debugPrint('[probe] keys(${keys.length}): ${keys.join(',')}');
      final missing = (dump['missing'] as List).whereType<String>().toList();
      if (missing.isNotEmpty) {
        debugPrint('[probe] missing(${missing.length}): ${missing.join(',')}');
      }
      final checks = dump['checks'] as Map<String, Object?>;
      var present = 0;
      var absent = 0;
      var noSvc = 0;
      for (final entry in checks.entries) {
        debugPrint('[probe] check ${entry.key}=${entry.value}');
        switch (entry.value) {
          case true:
            present++;
          case false:
            absent++;
          case 'no-svc':
            noSvc++;
        }
      }
      debugPrint(
        '[probe] checks summary: $present method-ok / '
        '$absent method-missing / $noSvc no-svc',
      );
    } else {
      debugPrint('[probe] dump failed: ${dump['error']}');
    }
    for (final call in (report['liveCalls'] as List).whereType<Map>()) {
      final label = '${call['service']}.${call['method']}';
      if (call['ok'] == true) {
        debugPrint('[probe] live $label ok');
      } else {
        debugPrint('[probe] live $label err: ${call['error']}');
      }
    }
  }

  static String _clip(String text) =>
      text.length <= errorMaxChars ? text : text.substring(0, errorMaxChars);
}
