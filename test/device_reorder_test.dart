import 'package:flutter/services.dart';
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
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );
  final backing = <String, String>{};

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    backing.clear();
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      final args = call.arguments as Map<Object?, Object?>;
      switch (call.method) {
        case 'read':
          return backing[args['key'] as String];
        case 'write':
          backing[args['key'] as String] = args['value'] as String;
          return null;
        case 'delete':
          backing.remove(args['key'] as String);
          return null;
      }
      return null;
    });
  });

  tearDown(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  Future<void> seedStore(List<RemoteDevice> devices) async {
    for (final d in devices) {
      await DeviceStore.instance.add(d);
    }
  }

  group('DeviceStore.saveOrder 落盘', () {
    test('saveOrder 写回 index，loadAll 按新顺序返回', () async {
      await seedStore([_device('a'), _device('b'), _device('c')]);

      await DeviceStore.instance.saveOrder(['c', 'a', 'b']);

      final loaded = await DeviceStore.instance.loadAll();
      expect(loaded.map((d) => d.id), ['c', 'a', 'b']);
    });

    test('顺序数组缺设备 → 拒绝写入（防丢设备）', () async {
      await seedStore([_device('a'), _device('b')]);

      await DeviceStore.instance.saveOrder(['b']);

      expect((await DeviceStore.instance.loadAll()).map((d) => d.id), [
        'a',
        'b',
      ]);
    });

    test('顺序数组混入未知 id → 拒绝写入', () async {
      await seedStore([_device('a'), _device('b')]);

      await DeviceStore.instance.saveOrder(['a', 'ghost']);

      expect((await DeviceStore.instance.loadAll()).map((d) => d.id), [
        'a',
        'b',
      ]);
    });

    test('顺序数组含重复 id → 拒绝写入（[a,a] 不许顶掉 b）', () async {
      await seedStore([_device('a'), _device('b')]);

      await DeviceStore.instance.saveOrder(['a', 'a']);

      expect((await DeviceStore.instance.loadAll()).map((d) => d.id), [
        'a',
        'b',
      ]);
    });
  });

  group('DeviceListNotifier.reorder', () {
    test('上移：reorder(2, 0) → [c, a, b] 并落盘', () async {
      await seedStore([_device('a'), _device('b'), _device('c')]);
      final c = _container([_device('a'), _device('b'), _device('c')]);
      addTearDown(c.dispose);

      await c.read(deviceListProvider.notifier).reorder(2, 0);

      expect(c.read(deviceListProvider).map((d) => d.id), ['c', 'a', 'b']);
      expect(
        (await DeviceStore.instance.loadAll()).map((d) => d.id),
        ['c', 'a', 'b'],
      );
    });

    test('下移：ReorderableListView 的 newIndex 偏移被纠正', () async {
      await seedStore([_device('a'), _device('b'), _device('c')]);
      final c = _container([_device('a'), _device('b'), _device('c')]);
      addTearDown(c.dispose);

      await c.read(deviceListProvider.notifier).reorder(0, 2);

      expect(c.read(deviceListProvider).map((d) => d.id), ['b', 'a', 'c']);
      expect(
        (await DeviceStore.instance.loadAll()).map((d) => d.id),
        ['b', 'a', 'c'],
      );
    });

    test('原位不动：reorder(1, 1) 是 no-op', () async {
      await seedStore([_device('a'), _device('b'), _device('c')]);
      final c = _container([_device('a'), _device('b'), _device('c')]);
      addTearDown(c.dispose);

      await c.read(deviceListProvider.notifier).reorder(1, 1);

      expect(c.read(deviceListProvider).map((d) => d.id), ['a', 'b', 'c']);
    });

    test('活动设备 tab 随重排回迁到新下标', () async {
      await seedStore([_device('a'), _device('b'), _device('c')]);
      final c = _container([_device('a'), _device('b'), _device('c')]);
      addTearDown(c.dispose);
      c.read(activeTabProvider.notifier).set(2);

      await c.read(deviceListProvider.notifier).reorder(2, 0);

      expect(c.read(activeTabProvider), 0);
    });

    test('活动 tab 是管理页 → 重排不动它', () async {
      await seedStore([_device('a'), _device('b')]);
      final c = _container([_device('a'), _device('b')]);
      addTearDown(c.dispose);
      c.read(activeTabProvider.notifier).set(2);

      await c.read(deviceListProvider.notifier).reorder(0, 1);

      expect(c.read(activeTabProvider), 2);
    });

    test('管理页下标 = 设备数，重排后仍合法', () async {
      await seedStore([_device('a'), _device('b')]);
      final c = _container([_device('a'), _device('b')]);
      addTearDown(c.dispose);
      c.read(activeTabProvider.notifier).set(1);

      await c.read(deviceListProvider.notifier).reorder(1, 0);

      expect(c.read(activeTabProvider), 0);
    });
  });
}
