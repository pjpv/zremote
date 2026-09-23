import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/resume_health.dart';

void main() {
  const t = ResumeHealthPolicy.quietThreshold;
  const long = Duration(minutes: 30);

  test('短后台（<90s）一律不动', () {
    for (final rendererGone in [false, true]) {
      for (final live in [false, true]) {
        expect(
          ResumeHealthPolicy.decide(
            backgroundFor: const Duration(seconds: 89),
            rendererGone: rendererGone,
            live: live,
            sinceWsActivity: Duration(hours: 1),
          ),
          ResumeHealthAction.ok,
        );
      }
    }
  });

  test('渲染进程死（久置）→ 立即重载，无论 LED/心跳形态', () {
    for (final live in [false, true]) {
      for (final activity in [const Duration(seconds: 5), long]) {
        expect(
          ResumeHealthPolicy.decide(
            backgroundFor: long,
            rendererGone: true,
            live: live,
            sinceWsActivity: activity,
          ),
          ResumeHealthAction.reload,
        );
      }
    }
  });

  test('久置 + live + 心跳新鲜（前台服务扛住了）→ 不动', () {
    expect(
      ResumeHealthPolicy.decide(
        backgroundFor: long,
        rendererGone: false,
        live: true,
        sinceWsActivity: const Duration(seconds: 45),
      ),
      ResumeHealthAction.ok,
    );
  });

  test('久置 + 非 live（WS 断，页面自愈中/放弃）→ 自愈窗口', () {
    expect(
      ResumeHealthPolicy.decide(
        backgroundFor: long,
        rendererGone: false,
        live: false,
        sinceWsActivity: const Duration(seconds: 5),
      ),
      ResumeHealthAction.graceThenReload,
    );
  });

  test('久置 + live 但心跳静默（WS 半死无 close 事件）→ 自愈窗口', () {
    expect(
      ResumeHealthPolicy.decide(
        backgroundFor: long,
        rendererGone: false,
        live: true,
        sinceWsActivity: long,
      ),
      ResumeHealthAction.graceThenReload,
    );
  });

  test('边界：恰在阈值上按久置处理', () {
    expect(
      ResumeHealthPolicy.decide(
        backgroundFor: t,
        rendererGone: false,
        live: true,
        sinceWsActivity: const Duration(seconds: 1),
      ),
      ResumeHealthAction.ok,
    );
    expect(
      ResumeHealthPolicy.decide(
        backgroundFor: t,
        rendererGone: false,
        live: false,
        sinceWsActivity: const Duration(seconds: 1),
      ),
      ResumeHealthAction.graceThenReload,
    );
  });

  group('ResumeWatch 状态机（2026-09-17 Ethan 复报：久置回前台不重连）', () {
    test('宽限窗口内的 inactive 抖动不得否决已武装的重载', () {
      final w = ResumeWatch();
      final t0 = DateTime(2026, 9, 17, 9, 0);
      w.onState(AppLifecycleState.inactive, t0);
      w.onState(AppLifecycleState.paused, t0.add(const Duration(seconds: 1)));
      final back = t0.add(const Duration(hours: 3));
      expect(
        w.onResumed(
          now: back,
          rendererGone: false,
          live: false,
          sinceWsActivity: long,
        ),
        ResumeSignal.armGrace,
      );
      w.onState(AppLifecycleState.inactive, back.add(const Duration(seconds: 2)));
      expect(
        w.onResumed(
          now: back.add(const Duration(seconds: 3)),
          rendererGone: false,
          live: false,
          sinceWsActivity: long,
        ),
        ResumeSignal.keepGrace,
      );
      expect(w.graceArmed, isTrue, reason: '宽限窗口必须存活到定时器到期');
    });

    test('inactive 单独不算离开：shade 下拉再合上不重置后台时钟', () {
      final w = ResumeWatch();
      final t0 = DateTime(2026, 9, 17, 9, 0);
      w.onState(AppLifecycleState.inactive, t0);
      w.onResumed(
          now: t0.add(const Duration(seconds: 5)),
          rendererGone: false,
          live: true,
          sinceWsActivity: const Duration(seconds: 2),
        );
      w.onState(AppLifecycleState.hidden, t0.add(const Duration(seconds: 60)));
      w.onState(AppLifecycleState.paused, t0.add(const Duration(seconds: 61)));
      expect(
        w.onResumed(
          now: t0.add(const Duration(minutes: 11)),
          rendererGone: false,
          live: false,
          sinceWsActivity: const Duration(seconds: 5),
        ),
        ResumeSignal.armGrace,
      );
    });

    test('宽限期内再真后台 → 重新按新周期决策（重武装，不延续旧钟）', () {
      final w = ResumeWatch();
      final t0 = DateTime(2026, 9, 17, 9, 0);
      w.onState(AppLifecycleState.paused, t0);
      final back = t0.add(const Duration(hours: 1));
      expect(
        w.onResumed(
          now: back,
          rendererGone: false,
          live: false,
          sinceWsActivity: long,
        ),
        ResumeSignal.armGrace,
      );
      w.onState(AppLifecycleState.hidden, back.add(const Duration(seconds: 5)));
      w.onState(AppLifecycleState.paused, back.add(const Duration(seconds: 6)));
      expect(
        w.onResumed(
          now: back.add(const Duration(hours: 1, seconds: 6)),
          rendererGone: true,
          live: false,
          sinceWsActivity: const Duration(seconds: 5),
        ),
        ResumeSignal.reloadNow,
      );
    });

    test('健康回前台（live + 新鲜心跳）→ 无事可做；无宽限在跑时 ok 是静默', () {
      final w = ResumeWatch();
      final t0 = DateTime(2026, 9, 17, 9, 0);
      w.onState(AppLifecycleState.paused, t0);
      expect(
        w.onResumed(
          now: t0.add(const Duration(hours: 2)),
          rendererGone: false,
          live: true,
          sinceWsActivity: const Duration(seconds: 30),
        ),
        ResumeSignal.none,
      );
      expect(w.graceArmed, isFalse);
    });

    test('clearGrace 后 graceArmed 复位（到期检查路径）', () {
      final w = ResumeWatch();
      final t0 = DateTime(2026, 9, 17, 9, 0);
      w.onState(AppLifecycleState.paused, t0);
      w.onResumed(
        now: t0.add(const Duration(hours: 2)),
        rendererGone: false,
        live: false,
        sinceWsActivity: long,
      );
      expect(w.graceArmed, isTrue);
      w.clearGrace();
      expect(w.graceArmed, isFalse);
    });
  });
}
