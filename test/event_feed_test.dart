import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/event_observer.dart';
import 'package:zremote/state/event_feed.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  ObservedEvent ev(String type, {String? summary}) =>
      ObservedEvent(type: type, summary: summary);

  group('EventFeedNotifier', () {
    test('白名单事件计数 +1', () {
      final notifier = container.read(eventFeedProvider.notifier);
      notifier.ingest('d1', ev('completed', summary: '修复登录页'));
      notifier.ingest('d1', ev('error'));

      final feed = container.read(eventFeedProvider)['d1'];
      expect(feed?.unread, 2);
      expect(feed?.lastSummary, 'error');
    });

    test('status/meta 类高频事件不计入（防徽标风暴）', () {
      final notifier = container.read(eventFeedProvider.notifier);
      notifier.ingest('d1', ev('streaming'));
      notifier.ingest('d1', ev('updated'));
      notifier.ingest('d1', ev('tool_call_update'));

      expect(container.read(eventFeedProvider).containsKey('d1'), isFalse);
    });

    test('permission_request 置 permPending', () {
      final notifier = container.read(eventFeedProvider.notifier);
      notifier.ingest('d1', ev('permission_request', summary: 'npm install'));

      final feed = container.read(eventFeedProvider)['d1'];
      expect(feed?.unread, 1);
      expect(feed?.permPending, isTrue);
      expect(feed?.lastSummary, 'npm install');
    });

    test('普通事件不置 permPending', () {
      final notifier = container.read(eventFeedProvider.notifier);
      notifier.ingest('d1', ev('completed'));
      expect(container.read(eventFeedProvider)['d1']?.permPending, isFalse);
    });

    test('clear 清零（看了即清）', () {
      final notifier = container.read(eventFeedProvider.notifier);
      notifier.ingest('d1', ev('permission_request'));
      notifier.clear('d1');
      expect(container.read(eventFeedProvider).containsKey('d1'), isFalse);
    });

    test('forget 移除条目；多设备互不影响', () {
      final notifier = container.read(eventFeedProvider.notifier);
      notifier.ingest('d1', ev('error'));
      notifier.ingest('d2', ev('error'));
      notifier.forget('d1');

      final state = container.read(eventFeedProvider);
      expect(state.containsKey('d1'), isFalse);
      expect(state['d2']?.unread, 1);
    });
  });
}
