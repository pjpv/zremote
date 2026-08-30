class NotificationPrefs {
  const NotificationPrefs({
    this.approval = true,
    this.complete = false,
    this.fail = false,
  });

  final bool approval;

  final bool complete;

  final bool fail;

  NotificationPrefs copyWith({bool? approval, bool? complete, bool? fail}) =>
      NotificationPrefs(
        approval: approval ?? this.approval,
        complete: complete ?? this.complete,
        fail: fail ?? this.fail,
      );

  bool enabled(String eventType) => switch (eventType) {
    'permission_request' || 'elicitation_request' => approval,
    'completed' => complete,
    'error' => fail,
    _ => false,
  };
}
