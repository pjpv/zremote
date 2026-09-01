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

  ObservedEvent ev(String type, {String? summary, String? taskId}) =>
      ObservedEvent(type: type, summary: summary, taskId: taskId);

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

    test('resolved 清审批红旗，未读数不动（历史是历史）', () {
      final notifier = container.read(eventFeedProvider.notifier);
      notifier.ingest('d1', ev('permission_request', summary: 'npm install'));
      notifier.ingest('d1', ev('completed'));
      notifier.ingest('d1', ev('resolved', taskId: 'sess_b'));

      final feed = container.read(eventFeedProvider)['d1'];
      expect(feed?.unread, 2, reason: 'resolved 不计入未读');
      expect(feed?.permPending, isFalse, reason: '待办已解决，红旗必须落下');
      expect(feed?.lastSummary, 'completed', reason: 'resolved 不覆盖摘要');
    });

    test('resolved 在空 feed 上 no-op（不建条目）', () {
      final notifier = container.read(eventFeedProvider.notifier);
      notifier.ingest('d1', ev('resolved'));
      expect(container.read(eventFeedProvider).containsKey('d1'), isFalse);
    });
  });
}
