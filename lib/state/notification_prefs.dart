import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_prefs.dart';
import '../services/device_store.dart';

class NotificationPrefsNotifier extends Notifier<NotificationPrefs> {
  @override
  NotificationPrefs build() {
    _load();
    return const NotificationPrefs();
  }

  Future<void> _load() async {
    state = await DeviceStore.instance.notificationPrefs();
  }

  Future<void> set(NotificationPrefs prefs) async {
    state = prefs;
    await DeviceStore.instance.setNotificationPrefs(prefs);
  }
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsNotifier, NotificationPrefs>(
      NotificationPrefsNotifier.new,
    );
