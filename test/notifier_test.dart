import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/services/event_observer.dart';
import 'package:zremote/services/notifier.dart';

RemoteDevice _device(String id) => RemoteDevice(
      id: id,
      baseUrl: 'https://zcode.z.ai/remote/v4',
      params: {'sid': 's', 'hash': 'h'},
      label: '',
      createdAt: DateTime(2026, 1, 1),
    );

void main() {
  group('NotificationSpec.cancellableIds', () {
    test('恰为该会话审批/追问两类通知位 id（三元稳定同款算法）', () {
      final device = _device('d1');
      final ids = NotificationSpec.cancellableIds(device, 'sess_b');

      final perm = NotificationSpec.stableId(
        device,
        const ObservedEvent(type: 'permission_request', taskId: 'sess_b'),
      );
      final elicit = NotificationSpec.stableId(
        device,
        const ObservedEvent(type: 'elicitation_request', taskId: 'sess_b'),
      );
      expect(ids, {perm, elicit});
      expect(ids, hasLength(2));
    });

    test('不同会话/不同设备的 id 不同（撤回不误伤）', () {
      final a = NotificationSpec.cancellableIds(_device('d1'), 'sess_a');
      final b = NotificationSpec.cancellableIds(_device('d1'), 'sess_b');
      final c = NotificationSpec.cancellableIds(_device('d2'), 'sess_a');
      expect(a.intersection(b), isEmpty);
      expect(a.intersection(c), isEmpty);
    });

    test('完成/失败通知不在撤回集——语义独立', () {
      final device = _device('d1');
      final ids = NotificationSpec.cancellableIds(device, 'sess_b');
      final done = NotificationSpec.stableId(
        device,
        const ObservedEvent(type: 'completed', taskId: 'sess_b'),
      );
      expect(ids.contains(done), isFalse);
    });
  });

  group('锁屏可见性', () {
    test('生物锁开启 → private（锁屏不露正文）', () {
      expect(
        lockScreenVisibility(lockEnabled: true),
        NotificationVisibility.private,
      );
    });

    test('生物锁关闭 → public（完整展示）', () {
      expect(
        lockScreenVisibility(lockEnabled: false),
        NotificationVisibility.public,
      );
    });
  });
}
