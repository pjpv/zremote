import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/models/usage_stats.dart';

void main() {
  group('IANA 形态直传', () {
    test('Asia/Shanghai', () {
      expect(zrTimeZoneFromName('Asia/Shanghai'), 'Asia/Shanghai');
    });
    test('三段 America/Argentina/Buenos_Aires', () {
      expect(
        zrTimeZoneFromName('America/Argentina/Buenos_Aires'),
        'America/Argentina/Buenos_Aires',
      );
    });
    test('UTC 恒等', () => expect(zrTimeZoneFromName('UTC'), 'UTC'));
  });

  group('偏移形态 → Etc/GMT-XX（POSIX 符号反转）', () {
    test('+08 → Etc/GMT-8', () {
      expect(zrTimeZoneFromName('+08'), 'Etc/GMT-8');
    });
    test('GMT+8 → Etc/GMT-8', () {
      expect(zrTimeZoneFromName('GMT+8'), 'Etc/GMT-8');
    });
    test('UTC+05:30 半点 → null（无 Etc 等价物，宁缺勿错）', () {
      expect(zrTimeZoneFromName('UTC+05:30'), isNull);
    });
    test('GMT-5（西半球）→ Etc/GMT+5', () {
      expect(zrTimeZoneFromName('GMT-5'), 'Etc/GMT+5');
    });
    test('+00 → UTC', () {
      expect(zrTimeZoneFromName('+00'), 'UTC');
    });
  });

  group('名字不可判 → 偏移兜底（zrTimeZoneFromParts）', () {
    test('CST + 8h（Android 设备实测形态）→ Etc/GMT-8', () {
      expect(
        zrTimeZoneFromParts('CST', const Duration(hours: 8)),
        'Etc/GMT-8',
      );
    });
    test('CST - 6h（同缩写字典另一成员）→ Etc/GMT+6', () {
      expect(
        zrTimeZoneFromParts('CST', const Duration(hours: -6)),
        'Etc/GMT+6',
      );
    });
    test('Windows 全名 + 8h → Etc/GMT-8', () {
      expect(
        zrTimeZoneFromParts('China Standard Time', const Duration(hours: 8)),
        'Etc/GMT-8',
      );
    });
    test('半点偏移 +5:30 → null（无 Etc 等价物）', () {
      expect(
        zrTimeZoneFromParts('CST', const Duration(hours: 5, minutes: 30)),
        isNull,
      );
    });
    test('偏移 0 → UTC', () {
      expect(
        zrTimeZoneFromParts('CST', Duration.zero),
        'UTC',
      );
    });
    test('IANA 名优先于偏移（有历史 DST 时更准）', () {
      expect(
        zrTimeZoneFromParts('Asia/Shanghai', const Duration(hours: 8)),
        'Asia/Shanghai',
      );
    });
  });

  group('不可判定 → null（官方回落 UTC）', () {
    test('Windows 全名', () {
      expect(zrTimeZoneFromName('China Standard Time'), isNull);
    });
    test('空串', () => expect(zrTimeZoneFromName(''), isNull));
    test('乱串', () => expect(zrTimeZoneFromName('zzz'), isNull));
  });
}
