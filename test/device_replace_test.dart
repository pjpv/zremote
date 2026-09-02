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

RemoteDevice _device(String id, {String label = 'lab'}) => RemoteDevice(
  id: id,
  baseUrl: 'https://old.example/remote/v4',
  params: const {'sid': 'old-sid', 'hash': 'old-hash'},
  label: label,
  createdAt: DateTime(2026, 1, 1),
);

RemoteDevice _parsed({String? label}) => RemoteDevice(
  id: 'fresh-uuid-from-parser',
  baseUrl: 'https://new.example/remote/v5',
  params: {'sid': 'new-sid', 'hash': 'new-hash', 'name': ?label},
  label: label ?? '',
  createdAt: DateTime(2030, 5, 5),
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

  group('DeviceListNotifier.replaceLink', () {
    test('换 baseUrl/params，保 id/createdAt/非空 label，位置不变，落盘', () async {
      final a = _device('a', label: '我家');
      final b = _device('b', label: '公司');
      for (final d in [a, b]) {
        await DeviceStore.instance.add(d);
      }
      final c = _container([a, b]);
      addTearDown(c.dispose);

      await c.read(deviceListProvider.notifier).replaceLink('a', _parsed());

      final state = c.read(deviceListProvider);
      expect(state.length, 2);
      expect(state[0].id, 'a');
      expect(state[0].sid, 'new-sid');
      expect(state[0].baseUrl, 'https://new.example/remote/v5');
      expect(state[0].label, '我家');
      expect(state[0].createdAt, DateTime(2026, 1, 1));
      expect(state[1].id, 'b');

      final stored = await DeviceStore.instance.loadAll();
      expect(stored.firstWhere((d) => d.id == 'a').sid, 'new-sid');
    });

    test('原条目未命名（label 空）→ 采纳新链接的 name 参数', () async {
      final c = _container([_device('a', label: '')]);
      addTearDown(c.dispose);

      await c.read(
        deviceListProvider.notifier,
      ).replaceLink('a', _parsed(label: '书房'));

      expect(c.read(deviceListProvider).first.label, '书房');
    });

    test('id 不存在 → 静默 no-op', () async {
      final c = _container([_device('a')]);
      addTearDown(c.dispose);

      await c.read(deviceListProvider.notifier).replaceLink('gone', _parsed());

      expect(c.read(deviceListProvider).first.sid, 'old-sid');
    });
  });
}
