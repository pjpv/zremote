import 'package:flutter/widgets.dart' show AppLifecycleState;

enum ResumeHealthAction {
  ok,

  reload,

  graceThenReload,
}

abstract final class ResumeHealthPolicy {
  static const Duration quietThreshold = Duration(seconds: 90);

  static const Duration grace = Duration(seconds: 12);

  static const _backgroundStates = <AppLifecycleState>{
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
    AppLifecycleState.detached,
  };

  static bool isBackgrounded(AppLifecycleState state) =>
      _backgroundStates.contains(state);

  static ResumeHealthAction decide({
    required Duration backgroundFor,
    required bool rendererGone,
    required bool live,
    required Duration sinceWsActivity,
  }) {
    if (backgroundFor < quietThreshold) return ResumeHealthAction.ok;
    if (rendererGone) return ResumeHealthAction.reload;
    final healthy = live && sinceWsActivity < quietThreshold;
    return healthy ? ResumeHealthAction.ok : ResumeHealthAction.graceThenReload;
  }
}

enum ResumeSignal {
  none,

  reloadNow,

  armGrace,

  keepGrace,
}

class ResumeWatch {
  DateTime? _backgroundedAt;
  bool _graceArmed = false;

  bool get graceArmed => _graceArmed;

  void onState(AppLifecycleState next, DateTime now) {
    if (ResumeHealthPolicy.isBackgrounded(next)) _backgroundedAt ??= now;
  }

  ResumeSignal onResumed({
    required DateTime now,
    required bool rendererGone,
    required bool live,
    required Duration sinceWsActivity,
  }) {
    final bgAt = _backgroundedAt;
    _backgroundedAt = null;
    final backgroundFor = bgAt == null ? Duration.zero : now.difference(bgAt);
    switch (ResumeHealthPolicy.decide(
      backgroundFor: backgroundFor,
      rendererGone: rendererGone,
      live: live,
      sinceWsActivity: sinceWsActivity,
    )) {
      case ResumeHealthAction.ok:
        return _graceArmed ? ResumeSignal.keepGrace : ResumeSignal.none;
      case ResumeHealthAction.reload:
        _graceArmed = false;
        return ResumeSignal.reloadNow;
      case ResumeHealthAction.graceThenReload:
        _graceArmed = true;
        return ResumeSignal.armGrace;
    }
  }

  void clearGrace() => _graceArmed = false;
}
