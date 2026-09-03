import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/services/device_store.dart';
import 'package:zremote/state/session_pool.dart';

class _StubDevices extends DeviceListNotifier {
  _StubDevices(this.devices);

  final List<RemoteDevice> devices;

  @override
  List<RemoteDevice> build() => devices;
}

RemoteDevice _device(String id) => RemoteDevice(
  id: id,
  baseUrl: 'https://example.invalid',
  params: const {},
  label: 'lab-$id',
  createdAt: DateTime(2026),
);

ProviderContainer _container(List<RemoteDevice> devices) =>
    ProviderContainer(
      overrides: [deviceListProvider.overrideWith(() => _StubDevices(devices))],
    )..read(deviceListProvider);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('ActiveTabNotifier 启动恢复', () {
    test('set(设备 tab) 落盘该设备 id', () async {
      final c = _container([_device('a'), _device('b')]);
      addTearDown(c.dispose);

      c.read(activeTabProvider.notifier).set(1);
      expect(c.read(activeTabProvider), 1);
      await Future<void>.delayed(Duration.zero);
      expect(await DeviceStore.instance.lastDeviceId(), 'b');
    });

    test('set(管理页) 不改写已存设备 id', () async {
      final c = _container([_device('a'), _device('b')]);
      addTearDown(c.dispose);

      c.read(activeTabProvider.notifier).set(0);
      await Future<void>.delayed(Duration.zero);
      c.read(activeTabProvider.notifier).set(2);
      await Future<void>.delayed(Duration.zero);
      expect(await DeviceStore.instance.lastDeviceId(), 'a');
    });

    test('restoreLast 恢复到已存设备（非首位）', () async {
      await DeviceStore.instance.setLastDeviceId('b');
      final c = _container([_device('a'), _device('b'), _device('c')]);
      addTearDown(c.dispose);

      expect(c.read(activeTabProvider), 0);
      await c.read(activeTabProvider.notifier).restoreLast();
      expect(c.read(activeTabProvider), 1);
    });

    test('无记录保持 0（首次使用）', () async {
      final c = _container([_device('a'), _device('b')]);
      addTearDown(c.dispose);

      await c.read(activeTabProvider.notifier).restoreLast();
      expect(c.read(activeTabProvider), 0);
    });

    test('记录指向已删除设备 → 保持 0', () async {
      await DeviceStore.instance.setLastDeviceId('gone');
      final c = _container([_device('a'), _device('b')]);
      addTearDown(c.dispose);

      await c.read(activeTabProvider.notifier).restoreLast();
      expect(c.read(activeTabProvider), 0);
    });

    test('通知点击先行 set → restoreLast 不覆盖', () async {
      final c = _container([_device('a'), _device('b'), _device('c')]);
      addTearDown(c.dispose);

      c.read(activeTabProvider.notifier).set(2);
      await c.read(activeTabProvider.notifier).restoreLast();
      expect(c.read(activeTabProvider), 2);
    });

    test('恢复 await 窗口期的通知点击 → restoreLast 让位', () async {
      await DeviceStore.instance.setLastDeviceId('b');
      final c = _container([_device('a'), _device('b'), _device('c')]);
      addTearDown(c.dispose);

      final restore = c.read(activeTabProvider.notifier).restoreLast();
      c.read(activeTabProvider.notifier).set(2);
      await restore;
      expect(c.read(activeTabProvider), 2);
    });

    test('通知点击落到首位（state 仍 0）→ restoreLast 仍让位', () async {
      await DeviceStore.instance.setLastDeviceId('b');
      final c = _container([_device('a'), _device('b')]);
      addTearDown(c.dispose);

      c.read(activeTabProvider.notifier).set(0);
      await c.read(activeTabProvider.notifier).restoreLast();
      expect(c.read(activeTabProvider), 0);
      await Future<void>.delayed(Duration.zero);
      expect(await DeviceStore.instance.lastDeviceId(), 'a');
    });
  });

  group('BiometricNotifier 冷启动初始注入（main 预载）', () {
    test('initial=true 首读即持久值——无「先不锁再补锁」窗口', () async {
      SharedPreferences.setMockInitialValues({
        'zremote.biometricEnabled': true,
      });
      final c = ProviderContainer(
        overrides: [
          biometricProvider.overrideWith(
            () => BiometricNotifier(initial: true),
          ),
        ],
      );
      addTearDown(c.dispose);
      expect(c.read(biometricProvider), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(biometricProvider), isTrue);
    });
  });
}
