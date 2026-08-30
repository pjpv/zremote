import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/main.dart';
import 'package:zremote/state/session_pool.dart';

class _FakeBiometricNotifier extends BiometricNotifier {
  _FakeBiometricNotifier(this.value);

  final bool value;

  @override
  bool build() => value;
}

Future<void> pumpGate(
  WidgetTester tester, {
  required bool enabled,
  required Duration relockAfter,
  required Future<bool> Function(String reason) authenticate,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        biometricProvider.overrideWith(() => _FakeBiometricNotifier(enabled)),
      ],
      child: MaterialApp(
        home: BiometricGate(
          relockAfter: relockAfter,
          authenticate: authenticate,
          child: const Text('SECRET'),
        ),
      ),
    ),
  );
}

Finder get visibleSecret => find.text('SECRET').hitTestable();
Finder get visibleLock => find.text('已锁定').hitTestable();

void main() {
  testWidgets('宽限期后自动上锁并验证，通过则进入内容', (tester) async {
    var calls = 0;
    await pumpGate(
      tester,
      enabled: true,
      relockAfter: const Duration(seconds: 10),
      authenticate: (reason) async {
        calls++;
        return true;
      },
    );
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();
    expect(visibleSecret, findsOneWidget);
    expect(visibleLock, findsNothing);
    expect(calls, 1);
  });

  testWidgets('验证被取消：停在锁屏，且不自动重弹', (tester) async {
    var calls = 0;
    await pumpGate(
      tester,
      enabled: true,
      relockAfter: const Duration(seconds: 10),
      authenticate: (reason) async {
        calls++;
        return false;
      },
    );
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(seconds: 2));
    expect(visibleLock, findsOneWidget);
    expect(visibleSecret, findsNothing);
    expect(calls, 1, reason: '取消后不得循环重弹验证框');
  });

  testWidgets('短暂离开回前台免验证', (tester) async {
    var calls = 0;
    await pumpGate(
      tester,
      enabled: true,
      relockAfter: const Duration(hours: 1),
      authenticate: (reason) async {
        calls++;
        return true;
      },
    );
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();
    expect(calls, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump(const Duration(milliseconds: 100));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(visibleSecret, findsOneWidget);
    expect(calls, 1, reason: '宽限期内不得二次验证');
  });

  testWidgets('超时离开回前台重新上锁并验证', (tester) async {
    var calls = 0;
    await pumpGate(
      tester,
      enabled: true,
      relockAfter: Duration.zero,
      authenticate: (reason) async {
        calls++;
        return true;
      },
    );
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();
    expect(calls, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();

    expect(calls, 2, reason: '超过宽限期应重新验证');
    expect(visibleSecret, findsOneWidget);
  });

  testWidgets('验证 UI 引起的 inactive 不算离开（防慢速验证后二次弹框）', (tester) async {
    var calls = 0;
    final gate = Completer<bool>();
    await pumpGate(
      tester,
      enabled: true,
      relockAfter: const Duration(seconds: 10),
      authenticate: (reason) async {
        calls++;
        return gate.future;
      },
    );
    await tester.pump(const Duration(milliseconds: 700));
    expect(visibleLock, findsOneWidget);
    expect(calls, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(calls, 1, reason: '被自身验证 UI 盖住不算离开');

    gate.complete(true);
    await tester.pump();
    await tester.pump();
    expect(visibleSecret, findsOneWidget);
    expect(calls, 1);
  });
}
