import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/services/device_import.dart';

RemoteDevice _device(String sid, {DeviceKind kind = DeviceKind.legacy}) =>
    RemoteDevice(
      id: 'id-$sid',
      baseUrl: 'https://zcode.z.ai/remote/v4',
      params: kind == DeviceKind.v2
          ? {'sid': sid, 'app_version': '3.16.1'}
          : {'sid': sid, 'hash': 'h'},
      label: '',
      createdAt: DateTime(2026, 1, 1),
      kind: kind,
    );

void main() {
  group('findDuplicateBySid', () {
    test('同 sid 命中：返回既有条目（不是新候选）', () {
      final existing = [_device('AAA')];
      final hit = findDuplicateBySid(existing, _device('AAA'));
      expect(hit, same(existing.first));
    });

    test('不同 sid 不命中', () {
      final existing = [_device('AAA')];
      expect(findDuplicateBySid(existing, _device('BBB')), isNull);
    });

    test('候选 sid 为空（异常链接）不查重直接放行', () {
      final existing = [_device('')];
      expect(findDuplicateBySid(existing, _device('')), isNull);
    });

    test('空列表不命中', () {
      expect(findDuplicateBySid([], _device('AAA')), isNull);
    });

    test('V2 条目同 sid 仍命中，且跨形态（legacy/V2）同样视为重复', () {
      final v2 = [_device('AAA', kind: DeviceKind.v2)];
      expect(
        findDuplicateBySid(v2, _device('AAA', kind: DeviceKind.v2)),
        same(v2.first),
      );
      expect(
        findDuplicateBySid(v2, _device('AAA')),
        same(v2.first),
        reason: '同一桌面的两种链接形态不能双挂中继',
      );
    });
  });

  group('findDuplicateBySidExcept（更换链接流程）', () {
    test('撞自己的 sid → 放行（hash 轮换属合法更换）', () {
      final existing = [_device('AAA'), _device('BBB')];
      final hit = findDuplicateBySidExcept(existing, _device('AAA'), 'id-AAA');
      expect(hit, isNull);
    });

    test('撞别的设备的 sid → 命中该设备（重复接入拦截）', () {
      final existing = [_device('AAA'), _device('BBB')];
      final hit = findDuplicateBySidExcept(existing, _device('BBB'), 'id-AAA');
      expect(hit, same(existing.last));
    });
  });
}
