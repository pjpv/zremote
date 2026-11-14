import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/webview_popup.dart';

void main() {
  group('PopupPolicy.externalTarget', () {
    test('http / https 原样放行，query 完整保留（授权地址带 state、redirect）', () {
      const url =
          'https://chat.z.ai/api/oauth/authorize?redirect_uri=https%3A%2F%2Fzcode.z.ai%2Fweb-remote%2Fcallback'
          '&response_type=code&client_id=abc&state=xyz';
      expect(PopupPolicy.externalTarget(url).toString(), url);
      expect(
        PopupPolicy.externalTarget('http://example.com/a')?.host,
        'example.com',
      );
    });

    test('scheme 大小写不敏感，首尾空白容忍', () {
      expect(PopupPolicy.externalTarget('  HTTPS://example.com/x \n'), isNotNull);
    });

    test('空 / null / about:blank 不外开', () {
      expect(PopupPolicy.externalTarget(null), isNull);
      expect(PopupPolicy.externalTarget(''), isNull);
      expect(PopupPolicy.externalTarget('   '), isNull);
      expect(PopupPolicy.externalTarget('about:blank'), isNull);
    });

    test('非 http(s) 协议一律拒绝', () {
      for (final u in [
        'javascript:alert(1)',
        'data:text/html,<script>alert(1)</script>',
        'file:///sdcard/x.html',
        'intent://scan/#Intent;scheme=zxing;end',
        'zcode://oauth/callback?sid=s&hash=h',
        'market://details?id=x',
        'content://x/y',
        'blob:https://example.com/uuid',
      ]) {
        expect(PopupPolicy.externalTarget(u), isNull, reason: u);
      }
    });

    test('无 host / 带 userinfo 拒绝', () {
      expect(PopupPolicy.externalTarget('https://'), isNull);
      expect(PopupPolicy.externalTarget('https:///path'), isNull);
      expect(
        PopupPolicy.externalTarget('https://accounts.google.com@evil.example/x'),
        isNull,
      );
    });

    test('无法解析的垃圾输入返回 null 而不是抛', () {
      expect(PopupPolicy.externalTarget('http://[bad'), isNull);
      expect(PopupPolicy.externalTarget('随便什么文字'), isNull);
    });
  });

  group('PopupPolicy.classify', () {
    test('空 / about:blank → allow（等页面随后设置真实地址）', () {
      expect(PopupPolicy.classify(null), PopupNav.allow);
      expect(PopupPolicy.classify(''), PopupNav.allow);
      expect(PopupPolicy.classify('about:blank'), PopupNav.allow);
      expect(PopupPolicy.classify(' ABOUT:BLANK '), PopupNav.allow);
    });

    test('http(s) → external', () {
      expect(PopupPolicy.classify('https://chat.z.ai/x'), PopupNav.external);
    });

    test('其他协议 → block', () {
      expect(PopupPolicy.classify('javascript:void(0)'), PopupNav.block);
      expect(PopupPolicy.classify('intent://x#Intent;end'), PopupNav.block);
      expect(PopupPolicy.classify('https://u:p@host/x'), PopupNav.block);
    });
  });

  group('PopupTicket（只路由一次）', () {
    test('window.open(url) 形态：首个真实 URL 被认领', () {
      final t = PopupTicket();
      final u = t.claim('https://chat.z.ai/auth?state=1');
      expect(u?.host, 'chat.z.ai');
      expect(t.routed, isTrue);
    });

    test('window.open("about:blank") 再改 location 形态：about:blank 不消耗名额', () {
      final t = PopupTicket();
      expect(t.claim('about:blank'), isNull);
      expect(t.routed, isFalse);
      expect(t.claim('https://chat.z.ai/auth?state=1'), isNotNull);
      expect(t.routed, isTrue);
    });

    test('shouldOverrideUrlLoading 与 onLoadStart 先后各给一次同一 URL，只认领一次', () {
      final t = PopupTicket();
      expect(t.claim('https://chat.z.ai/auth?state=1'), isNotNull);
      expect(t.claim('https://chat.z.ai/auth?state=1'), isNull);
    });

    test('认领后的重定向链不再触发', () {
      final t = PopupTicket();
      t.claim('https://a.example/start');
      expect(t.claim('https://b.example/next'), isNull);
    });

    test('非 http(s) 不认领也不消耗名额', () {
      final t = PopupTicket();
      expect(t.claim('javascript:void(0)'), isNull);
      expect(t.routed, isFalse);
      expect(t.claim('https://ok.example/'), isNotNull);
    });
  });

  group('PopupLimiter', () {
    test('并发上限：满额拒绝，关闭一个后恢复', () {
      final l = PopupLimiter(maxConcurrent: 2);
      expect(l.tryOpen(1), isTrue);
      expect(l.tryOpen(2), isTrue);
      expect(l.tryOpen(3), isFalse);
      expect(l.openCount, 2);
      l.close(1);
      expect(l.tryOpen(3), isTrue);
    });

    test('同一 windowId 不会重复占位', () {
      final l = PopupLimiter();
      expect(l.tryOpen(7), isTrue);
      expect(l.tryOpen(7), isFalse);
      expect(l.openCount, 1);
    });

    test('close 未知 id 无副作用', () {
      final l = PopupLimiter();
      l.close(99);
      expect(l.openCount, 0);
    });

    test('同 URL 在去重窗口内只放行一次，窗口后可再放行', () {
      final l = PopupLimiter(dedupWindow: const Duration(seconds: 2));
      final u = Uri.parse('https://chat.z.ai/auth?state=1');
      final t0 = DateTime(2026, 11, 14, 12);
      expect(l.allowLaunch(u, t0), isTrue);
      expect(l.allowLaunch(u, t0.add(const Duration(milliseconds: 500))), isFalse);
      expect(l.allowLaunch(u, t0.add(const Duration(seconds: 3))), isTrue);
    });

    test('不同 URL 不互相去重（重新点登录会产生新 state）', () {
      final l = PopupLimiter();
      final t0 = DateTime(2026, 11, 14, 12);
      expect(l.allowLaunch(Uri.parse('https://chat.z.ai/a?state=1'), t0), isTrue);
      expect(l.allowLaunch(Uri.parse('https://chat.z.ai/a?state=2'), t0), isTrue);
    });
  });

  group('PopupLimiter 休眠弹窗（已转交浏览器、子窗口保留）', () {
    test('markRouted 后成为可驱逐对象；未转交的不会被驱逐', () {
      final l = PopupLimiter(maxConcurrent: 3);
      l.tryOpen(1);
      l.tryOpen(2);
      expect(l.oldestRouted(), isNull); // 都还在等 URL
      l.markRouted(2);
      expect(l.oldestRouted(), 2);
    });

    test('oldestRouted 取登记最早的休眠弹窗', () {
      final l = PopupLimiter(maxConcurrent: 3);
      for (final id in [10, 11, 12]) {
        l.tryOpen(id);
      }
      l.markRouted(12);
      l.markRouted(11);
      expect(l.oldestRouted(), 11); // 11 比 12 先登记
      l.close(11);
      expect(l.oldestRouted(), 12);
    });

    test('满额时：驱逐休眠者后新弹窗可进入（重试登录不被拒）', () {
      final l = PopupLimiter(maxConcurrent: 2);
      l.tryOpen(1);
      l.tryOpen(2);
      l.markRouted(1);
      expect(l.tryOpen(3), isFalse);
      final victim = l.oldestRouted();
      expect(victim, 1);
      l.close(victim!);
      expect(l.tryOpen(3), isTrue);
    });

    test('满额且无休眠者：没有可驱逐对象（应拒绝）', () {
      final l = PopupLimiter(maxConcurrent: 1);
      l.tryOpen(1);
      expect(l.tryOpen(2), isFalse);
      expect(l.oldestRouted(), isNull);
    });

    test('markRouted 对未知 id 无副作用', () {
      final l = PopupLimiter();
      l.markRouted(404);
      expect(l.openCount, 0);
      expect(l.oldestRouted(), isNull);
    });
  });

  group('ExternalReturnGuard（授权往返回来不刷新页面）', () {
    final t0 = DateTime(2026, 11, 14, 13, 40);

    test('没拉起过浏览器：不跳过，恢复逻辑照常', () {
      final g = ExternalReturnGuard();
      expect(g.armed, isFalse);
      expect(g.consumeReturn(t0), isFalse);
    });

    test('拉起浏览器后回来：跳过一次，且只跳过一次', () {
      final g = ExternalReturnGuard();
      g.noteLaunch(t0);
      expect(g.armed, isTrue);
      expect(g.consumeReturn(t0.add(const Duration(seconds: 70))), isTrue);
      expect(g.armed, isFalse);
      // 之后的回前台走正常恢复
      expect(g.consumeReturn(t0.add(const Duration(seconds: 200))), isFalse);
    });

    test('超过授权往返窗口才回来：不再跳过，并清除标记', () {
      final g = ExternalReturnGuard(window: const Duration(minutes: 10));
      g.noteLaunch(t0);
      expect(g.consumeReturn(t0.add(const Duration(minutes: 11))), isFalse);
      expect(g.armed, isFalse);
    });

    test('窗口边界：恰好等于窗口仍算往返', () {
      final g = ExternalReturnGuard(window: const Duration(minutes: 10));
      g.noteLaunch(t0);
      expect(g.consumeReturn(t0.add(const Duration(minutes: 10))), isTrue);
    });

    test('再次拉起会重新计时（用户重试登录）', () {
      final g = ExternalReturnGuard(window: const Duration(minutes: 10));
      g.noteLaunch(t0);
      g.noteLaunch(t0.add(const Duration(minutes: 9)));
      expect(g.consumeReturn(t0.add(const Duration(minutes: 15))), isTrue);
    });
  });

  group('WebViewPopupRouter', () {
    CreateWindowAction action(int id, {String? url}) => CreateWindowAction(
      request: URLRequest(url: url == null ? null : WebUri(url)),
      windowId: id,
      isForMainFrame: true,
    );

    test('非 Android 平台保持原行为：不接管、不拉起浏览器', () async {
      final opened = <Uri>[];
      final router = WebViewPopupRouter(
        isAndroid: false,
        openExternal: (u) async {
          opened.add(u);
          return true;
        },
      );
      expect(await router.onCreateWindow(action(1, url: 'https://x.example/')), isFalse);
      expect(opened, isEmpty);
      router.dispose();
    });

    test('dispose 之后不再接管', () async {
      final router = WebViewPopupRouter(
        isAndroid: true,
        openExternal: (_) async => true,
      );
      router.dispose();
      expect(await router.onCreateWindow(action(2)), isFalse);
    });

    test('并发满额时拒绝（不建原生 WebView）', () async {
      final limiter = PopupLimiter(maxConcurrent: 1);
      expect(limiter.tryOpen(100), isTrue); // 已有一个弹窗占位
      final router = WebViewPopupRouter(
        isAndroid: true,
        limiter: limiter,
        openExternal: (_) async => true,
      );
      expect(await router.onCreateWindow(action(101)), isFalse);
      router.dispose();
    });
  });

  group('回归守卫：session_view 必须接管 window.open', () {
    // 原生 WebView 行为无法在 widget test 里复现；这里守住导致“点授权登录没反应”的
    // 三个配置不被误删：多窗口、脚本自动开窗、onCreateWindow 接管。
    final src = File('lib/ui/session_view.dart').readAsStringSync();

    test('InAppWebViewSettings 开启 supportMultipleWindows', () {
      expect(src, contains('supportMultipleWindows: true'));
    });

    test('InAppWebViewSettings 开启 javaScriptCanOpenWindowsAutomatically', () {
      expect(src, contains('javaScriptCanOpenWindowsAutomatically: true'));
    });

    test('注册了 onCreateWindow 并交给 WebViewPopupRouter，且随页面销毁', () {
      expect(src, contains('onCreateWindow:'));
      expect(src, contains('_popupRouter'));
      expect(src, contains('.onCreateWindow('));
      expect(src, contains('_popupRouter.dispose()'));
    });

    test('弹窗跳板沿用设备的 WebView profile（多账号隔离不被破坏）', () {
      expect(src, contains('profileName: webProfileNameFor(widget.device)'));
    });

    test('拉起浏览器时登记授权往返，回前台自动恢复处消费它（不把页面刷掉）', () {
      expect(src, contains('onExternalLaunch:'));
      expect(src, contains('_externalReturn.noteLaunch('));
      expect(src, contains('_externalReturn.consumeReturn('));
      // 只对“探测 / 宽限后重载”两类自动恢复豁免；渲染进程已死的 reloadNow 不豁免
      final guardIdx = src.indexOf('_externalReturn.consumeReturn(');
      final around = src.substring(guardIdx - 200, guardIdx + 60);
      expect(around, contains('ResumeSignal.verifyWritePath'));
      expect(around, contains('ResumeSignal.armGrace'));
      expect(around, isNot(contains('ResumeSignal.reloadNow')));
    });
  });
}
