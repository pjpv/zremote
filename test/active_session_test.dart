import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/state/active_session.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  group('ActiveSessionNotifier（每设备当前查看会话，面板蓝点数据）', () {
    test('report 建立设备条目；再次 report 覆盖旧值', () {
      final notifier = container.read(activeSessionProvider.notifier);
      notifier.report('d1', 's1');
      expect(container.read(activeSessionProvider)['d1'], 's1');
      notifier.report('d1', 's2');
      expect(container.read(activeSessionProvider)['d1'], 's2');
    });

    test('同值 report 是 no-op（不发新状态）', () {
      final notifier = container.read(activeSessionProvider.notifier);
      notifier.report('d1', 's1');
      var emissions = 0;
      container.listen(activeSessionProvider, (_, _) => emissions++);
      notifier.report('d1', 's1');
      expect(emissions, 0);
      expect(container.read(activeSessionProvider)['d1'], 's1');
    });

    test('多设备互不串扰', () {
      final notifier = container.read(activeSessionProvider.notifier);
      notifier.report('d1', 's1');
      notifier.report('d2', 's2');
      expect(container.read(activeSessionProvider)['d1'], 's1');
      expect(container.read(activeSessionProvider)['d2'], 's2');
    });

    test('forget 清设备条目；未知设备 forget 是 no-op', () {
      final notifier = container.read(activeSessionProvider.notifier);
      notifier.report('d1', 's1');
      notifier.report('d2', 's2');
      notifier.forget('d1');
      expect(container.read(activeSessionProvider).containsKey('d1'), isFalse);
      expect(container.read(activeSessionProvider)['d2'], 's2');
      notifier.forget('d_unknown');
      expect(container.read(activeSessionProvider)['d2'], 's2');
    });
  });
}
