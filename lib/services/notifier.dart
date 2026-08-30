import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../l10n/app_localizations.dart';
import '../models/device.dart';
import '../models/device_label.dart';
import 'event_observer.dart';

class NotificationSpec {
  const NotificationSpec({
    required this.channelId,
    required this.channelName,
    required this.importance,
    required this.priority,
    required this.title,
    required this.body,
    required this.payload,
  });

  final String channelId;
  final String channelName;
  final Importance importance;
  final Priority priority;
  final String title;
  final String body;

  final String payload;

  static int stableId(RemoteDevice device, ObservedEvent event) =>
      (device.id.hashCode ^
          event.type.hashCode ^
          (event.taskId?.hashCode ?? 0)) &
      0x7FFFFFFF;

  static NotificationSpec? from(
    RemoteDevice device,
    ObservedEvent event, [
    AppLocalizations? l10n,
  ]) {
    final l = l10n ?? l10nZh;
    final session = event.sessionTitle?.trim().isNotEmpty == true
        ? event.sessionTitle!.trim()
        : l.notifSessionFallback;
    final what = event.summary?.trim().isNotEmpty == true
        ? event.summary!.trim()
        : null;
    final label = device.displayName(l);
    switch (event.type) {
      case 'permission_request':
        return NotificationSpec(
          channelId: 'zr_perm',
          channelName: l.notifChannelApproval,
          importance: Importance.high,
          priority: Priority.high,
          title: l.notifPermTitle(label, session),
          body: what ?? l.notifPermBody,
          payload: device.id,
        );
      case 'elicitation_request':
        return NotificationSpec(
          channelId: 'zr_perm',
          channelName: l.notifChannelApproval,
          importance: Importance.high,
          priority: Priority.high,
          title: l.notifElicitTitle(label, session),
          body: what ?? l.notifElicitBody,
          payload: device.id,
        );
      case 'error':
        return NotificationSpec(
          channelId: 'zr_fail',
          channelName: l.notifChannelFail,
          importance: Importance.high,
          priority: Priority.high,
          title: l.notifErrorTitle(label, session),
          body: what ?? l.notifErrorBody,
          payload: device.id,
        );
      case 'completed':
        return NotificationSpec(
          channelId: 'zr_done',
          channelName: l.notifChannelDone,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          title: l.notifDoneTitle(label, session),
          body: what ?? l.notifDoneBody,
          payload: device.id,
        );
      default:
        return null;
    }
  }
}

abstract final class NotificationTap {
  static String? _pending;
  static void Function(String deviceId)? _onTap;

  static void bind(void Function(String deviceId)? onTap) => _onTap = onTap;

  static void route(String? payload) {
    if (payload == null || payload.isEmpty) return;
    final onTap = _onTap;
    if (onTap != null) {
      onTap(payload);
    } else {
      _pending = payload;
    }
  }

  static String? consumePending() {
    final pending = _pending;
    _pending = null;
    return pending;
  }
}

class NotifierService {
  NotifierService._();

  static final NotifierService instance = NotifierService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _inited = false;
  bool _permissionAsked = false;

  Future<void> ensurePermission() async {
    if (_permissionAsked) return;
    _permissionAsked = true;
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } catch (_) {
    }
  }

  Future<void> init() async {
    if (_inited) return;
    _inited = true;
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse: (response) =>
            NotificationTap.route(response.payload),
      );
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp ?? false) {
        NotificationTap.route(details?.notificationResponse?.payload);
      }
    } catch (_) {
    }
  }

  Future<void> notifyFrom(
    RemoteDevice device,
    ObservedEvent event, {
    AppLocalizations? l10n,
  }) async {
    final spec = NotificationSpec.from(device, event, l10n);
    if (spec == null) return;
    try {
      if (!_permissionAsked) await ensurePermission();
      final id = NotificationSpec.stableId(device, event);
      await _plugin.show(
        id: id,
        title: spec.title,
        body: spec.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            spec.channelId,
            spec.channelName,
            importance: spec.importance,
            priority: spec.priority,
          ),
        ),
        payload: spec.payload,
      );
    } catch (_) {
    }
  }
}
