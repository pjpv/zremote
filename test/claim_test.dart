import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/models/claim.dart';
import 'package:zremote/ui/claim_ticket_dialog.dart';

void main() {
  group('ClaimPreview.fromJson', () {
    test('happy path：全字段 + 官方序数据', () {
      final p = ClaimPreview.fromJson(const {
        'planId': 'plan-1',
        'name': '周末体验包',
        'description': '3 亿 Token 体验额度',
        'priority': 10,
        'entitlements': [
          {
            'showName': 'GLM-4.6',
            'units': 300000000,
            'unitType': 'token',
            'period': 'daily',
            'meter': 'model_usage',
          },
        ],
      });
      expect(p, isNotNull);
      expect(p!.planId, 'plan-1');
      expect(p.name, '周末体验包');
      expect(p.description, '3 亿 Token 体验额度');
      expect(p.priority, 10);
      expect(p.entitlements, hasLength(1));
      expect(p.entitlements.single.showName, 'GLM-4.6');
      expect(p.entitlements.single.units, 300000000);
      expect(p.entitlements.single.meter, 'model_usage');
    });

    test('缺 planId / planId 非 String / 空串 → 整对象丢弃 null', () {
      expect(ClaimPreview.fromJson(const {'name': 'x'}), isNull);
      expect(ClaimPreview.fromJson(const {'planId': 42}), isNull);
      expect(ClaimPreview.fromJson(const {'planId': ''}), isNull);
    });

    test('宽容：字段类型不符给默认值，未知字段忽略，entitlements 非 List 忽略', () {
      final p = ClaimPreview.fromJson(const {
        'planId': 'p',
        'name': 1,
        'description': true,
        'priority': 'high',
        'entitlements': 'nope',
        'unknownKey': {'a': 1},
      });
      expect(p, isNotNull);
      expect(p!.name, '');
      expect(p.description, '');
      expect(p.priority, 0);
      expect(p.entitlements, isEmpty);
    });
  });

  group('ClaimEntitlement.fromJson', () {
    test('units / grantUnits 双键宽容（官方蛇形 grantUnits）', () {
      final a = ClaimEntitlement.fromJson(const {
        'showName': 'A',
        'units': 100,
        'unitType': 'token',
      });
      final b = ClaimEntitlement.fromJson(const {
        'showName': 'B',
        'grantUnits': 200,
        'unitType': 'token',
      });
      expect(a.units, 100);
      expect(b.units, 200);
      final c = ClaimEntitlement.fromJson(const {
        'units': 1,
        'grantUnits': 2,
      });
      expect(c.units, 1);
      final d = ClaimEntitlement.fromJson(const {});
      expect(
        d,
        const ClaimEntitlement(
          showName: '',
          units: null,
          unitType: '',
          period: '',
          meter: '',
        ),
      );
    });
  });

  group('CaptchaConfig.fromJson', () {
    test('实测形态直取', () {
      final c = CaptchaConfig.fromJson(const {
        'enabled': true,
        'region': 'cn',
        'prefix': 'no8xfe',
        'sceneId': '11xygtvd',
      });
      expect(
        c,
        const CaptchaConfig(
          enabled: true,
          region: 'cn',
          prefix: 'no8xfe',
          sceneId: '11xygtvd',
        ),
      );
      expect(CaptchaConfig.fromJson(const {}), const CaptchaConfig());
    });
  });

  group('ClaimOutcome.fromJson', () {
    test('failureEndsAt 秒/ms 容错（评审 P1-3 回归锁）', () {
      final sec = ClaimOutcome.fromJson(const {
        'success': false,
        'code': 1005,
        'failureEndsAt': 1779000000,
      });
      expect(
        sec.failureEndsAt!.millisecondsSinceEpoch,
        1779000000000,
      );
      final ms = ClaimOutcome.fromJson(const {
        'success': false,
        'failureEndsAt': 1779000000000,
      });
      expect(ms.failureEndsAt!.millisecondsSinceEpoch, 1779000000000);
      expect(ClaimOutcome.fromJson(const {}).failureEndsAt, isNull);
    });

    test('code 缺省 null + 成功响应字段（serverTime/startsAt/endsAt 双路径）', () {
      final empty = ClaimOutcome.fromJson(const {'success': false});
      expect(empty.code, isNull);
      expect(empty.message, '');

      final ok = ClaimOutcome.fromJson(const {
        'success': true,
        'serverTime': 1780000000000,
        'startsAt': 1779900000,
        'endsAt': 1790000000,
      });
      expect(ok.serverTime, 1780000000000);
      expect(ok.startsAtMillis, 1779900000000);
      expect(ok.endsAt!.millisecondsSinceEpoch, 1790000000000);

      final nested = ClaimOutcome.fromJson(const {
        'success': true,
        'plan': {'endsAt': 1790000000},
      });
      expect(nested.endsAt!.millisecondsSinceEpoch, 1790000000000);
    });
  });

  group('== / hashCode', () {
    test('值相等（widget 测试断言依赖）', () {
      final a = ClaimPreview.fromJson(const {
        'planId': 'p',
        'name': 'n',
        'priority': 1,
        'entitlements': [
          {'showName': 's', 'units': 5, 'unitType': 'token'},
        ],
      });
      final b = ClaimPreview.fromJson(const {
        'planId': 'p',
        'name': 'n',
        'priority': 1,
        'entitlements': [
          {'showName': 's', 'units': 5, 'unitType': 'token'},
        ],
      });
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(
        const ClaimOutcome(success: true, code: 1, message: 'm'),
        const ClaimOutcome(success: true, code: 1, message: 'm'),
      );
    });
  });

  group('ClaimFormat', () {
    test('全量分组 / 紧凑（zh 3亿、en 300M）', () {
      expect(ClaimFormat.grouped(300000000), '300,000,000');
      expect(ClaimFormat.compact(300000000, 'zh'), '3亿');
      expect(ClaimFormat.compact(300000000, 'en'), '300M');
      expect(ClaimFormat.compactOrNull(null, 'zh'), '');
    });

    test('medium+short：zh 24h / en 12h（spec §5 官方规则）', () {
      final t = DateTime(2026, 9, 12, 14, 30);
      expect(ClaimFormat.dateTime(t, 'zh'), '2026年9月12日 14:30');
      expect(ClaimFormat.dateTime(t, 'en'), 'Sep 12, 2026, 2:30 PM');
    });

    test('ListFormat conjunction：zh「A、B 和 C」/ en「A, B, and C」', () {
      expect(ClaimFormat.listJoin(const ['A'], 'zh'), 'A');
      expect(ClaimFormat.listJoin(const ['A', 'B'], 'zh'), 'A和B');
      expect(
        ClaimFormat.listJoin(const ['A', 'B', 'C'], 'zh'),
        'A、B和C',
      );
      expect(ClaimFormat.listJoin(const ['A', 'B'], 'en'), 'A and B');
      expect(
        ClaimFormat.listJoin(const ['A', 'B', 'C'], 'en'),
        'A, B, and C',
      );
    });
  });
}
