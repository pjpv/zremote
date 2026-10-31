import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/state/service_readiness.dart';

void main() {
  test('report 写入并按设备隔离', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(serviceReadinessProvider.notifier);

    notifier.report('d1', ServiceReadiness.unavailable);
    notifier.report('d2', ServiceReadiness.ready);

    expect(container.read(serviceReadinessProvider), {
      'd1': ServiceReadiness.unavailable,
      'd2': ServiceReadiness.ready,
    });
  });

  test('report 相同值不重建 map（引用相等）', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(serviceReadinessProvider.notifier);

    notifier.report('d1', ServiceReadiness.ready);
    final before = container.read(serviceReadinessProvider);
    notifier.report('d1', ServiceReadiness.ready);
    expect(identical(container.read(serviceReadinessProvider), before), isTrue);
  });

  test('reset 回 unknown；forget 摘除条目', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(serviceReadinessProvider.notifier);

    notifier.report('d1', ServiceReadiness.ready);
    notifier.reset('d1');
    expect(
      container.read(serviceReadinessProvider)['d1'],
      ServiceReadiness.unknown,
    );

    notifier.forget('d1');
    expect(container.read(serviceReadinessProvider).containsKey('d1'), isFalse);
    notifier.forget('nope');
  });

  test('门控只对 unavailable 复查；unknown/ready 放行', () {
    expect(serviceNeedsProbe(ServiceReadiness.unavailable), isTrue);
    expect(serviceNeedsProbe(ServiceReadiness.unknown), isFalse);
    expect(serviceNeedsProbe(ServiceReadiness.ready), isFalse);
  });
}
