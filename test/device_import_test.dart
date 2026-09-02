import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/services/device_import.dart';

RemoteDevice _device(String sid) => RemoteDevice(
      id: 'id-$sid',
      baseUrl: 'https://zcode.z.ai/remote/v4',
      params: {'sid': sid, 'hash': 'h'},
      label: '',
      createdAt: DateTime(2026, 1, 1),
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
