import 'package:flutter/foundation.dart';

DateTime? parseSecOrMs(dynamic v) {
  final ms = parseSecOrMsToMillis(v);
  return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
}

int? parseSecOrMsToMillis(dynamic v) =>
    v is num ? (v < 1e12 ? (v * 1000).toInt() : v.toInt()) : null;

class ClaimEntitlement {
  const ClaimEntitlement({
    this.showName = '',
    this.units,
    this.unitType = '',
    this.period = '',
    this.meter = '',
  });

  final String showName;

  final num? units;

  final String unitType;

  final String period;

  final String meter;

  static ClaimEntitlement fromJson(Map<String, dynamic> j) {
    final unitsRaw = j['units'] is num ? j['units'] : j['grantUnits'];
    return ClaimEntitlement(
      showName: j['showName'] is String ? j['showName'] as String : '',
      units: unitsRaw is num ? unitsRaw : null,
      unitType: j['unitType'] is String ? j['unitType'] as String : '',
      period: j['period'] is String ? j['period'] as String : '',
      meter: j['meter'] is String ? j['meter'] as String : '',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ClaimEntitlement &&
      other.showName == showName &&
      other.units == units &&
      other.unitType == unitType &&
      other.period == period &&
      other.meter == meter;

  @override
  int get hashCode => Object.hashAll([
        showName,
        units,
        unitType,
        period,
        meter,
      ]);
}

class ClaimPreview {
  const ClaimPreview({
    required this.planId,
    this.name = '',
    this.description = '',
    this.priority = 0,
    this.entitlements = const [],
  });

  final String planId;
  final String name;
  final String description;

  final int priority;

  final List<ClaimEntitlement> entitlements;

  static ClaimPreview? fromJson(Map<String, dynamic> j) {
    final id = j['planId'];
    if (id is! String || id.isEmpty) return null;
    final entitlements = <ClaimEntitlement>[
      if (j['entitlements'] is List)
        for (final e in j['entitlements'] as List<dynamic>)
          if (e is Map<String, dynamic>) ClaimEntitlement.fromJson(e),
    ];
    return ClaimPreview(
      planId: id,
      name: j['name'] is String ? j['name'] as String : '',
      description: j['description'] is String ? j['description'] as String : '',
      priority: j['priority'] is num ? (j['priority'] as num).toInt() : 0,
      entitlements: entitlements,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ClaimPreview &&
      other.planId == planId &&
      other.name == name &&
      other.description == description &&
      other.priority == priority &&
      listEquals(other.entitlements, entitlements);

  @override
  int get hashCode => Object.hashAll([
        planId,
        name,
        description,
        priority,
        Object.hashAll(entitlements),
      ]);
}

class CaptchaConfig {
  const CaptchaConfig({
    this.enabled = false,
    this.region = '',
    this.prefix = '',
    this.sceneId = '',
  });

  final bool enabled;
  final String region;
  final String prefix;
  final String sceneId;

  static CaptchaConfig fromJson(Map<String, dynamic> j) => CaptchaConfig(
        enabled: j['enabled'] == true,
        region: j['region'] is String ? j['region'] as String : '',
        prefix: j['prefix'] is String ? j['prefix'] as String : '',
        sceneId: j['sceneId'] is String ? j['sceneId'] as String : '',
      );

  @override
  bool operator ==(Object other) =>
      other is CaptchaConfig &&
      other.enabled == enabled &&
      other.region == region &&
      other.prefix == prefix &&
      other.sceneId == sceneId;

  @override
  int get hashCode => Object.hashAll([enabled, region, prefix, sceneId]);
}

class ClaimOutcome {
  const ClaimOutcome({
    this.success = false,
    this.code,
    this.message = '',
    this.failureEndsAt,
    this.serverTime,
    this.startsAtMillis,
    this.endsAt,
  });

  final bool success;

  final int? code;
  final String message;

  final DateTime? failureEndsAt;

  final int? serverTime;

  final int? startsAtMillis;

  final DateTime? endsAt;

  static ClaimOutcome fromJson(Map<String, dynamic> j) {
    final plan = j['plan'];
    return ClaimOutcome(
      success: j['success'] == true,
      code: j['code'] is num ? (j['code'] as num).toInt() : null,
      message: j['message'] is String ? j['message'] as String : '',
      failureEndsAt: parseSecOrMs(j['failureEndsAt']),
      serverTime: parseSecOrMsToMillis(j['serverTime']),
      startsAtMillis: parseSecOrMsToMillis(j['startsAt']),
      endsAt:
          parseSecOrMs(j['endsAt']) ??
          (plan is Map ? parseSecOrMs(plan['endsAt']) : null),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ClaimOutcome &&
      other.success == success &&
      other.code == code &&
      other.message == message &&
      other.failureEndsAt == failureEndsAt &&
      other.serverTime == serverTime &&
      other.startsAtMillis == startsAtMillis &&
      other.endsAt == endsAt;

  @override
  int get hashCode => Object.hashAll([
        success,
        code,
        message,
        failureEndsAt,
        serverTime,
        startsAtMillis,
        endsAt,
      ]);
}
