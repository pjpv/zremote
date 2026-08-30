import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/session_pool.dart';
import 'manage_page.dart';
import 'session_view.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(deviceListProvider);
    final active = ref.watch(activeTabProvider);

    ref.listen(deviceListProvider, (_, _) {
      final count = ref.read(deviceListProvider).length + 1;
      ref.read(activeTabProvider.notifier).clampTo(count);
    });

    final children = <Widget>[
      for (final d in devices)
        KeyedSubtree(
          key: ValueKey(d.id),
          child: SessionView(device: d),
        ),
      const ManagePage(),
    ];

    final onManage = active >= devices.length;

    return PopScope(
      canPop: onManage,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        ref
            .read(activeTabProvider.notifier)
            .set(ref.read(deviceListProvider).length);
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: active.clamp(0, children.length - 1),
            children: children,
          ),
        ),
      ),
    );
  }
}
