import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

/// 子窗口（`window.open` / `target=_blank`）如何处理：纯策略，不触平台，便于单测。
///
/// 背景：ZCode 远控页的“通过浏览器授权登录”要 `window.open` 一个授权窗口。Android
/// WebView 默认不支持多窗口，`window.open` 直接返回 null、没有任何界面反应。授权本身
/// 在系统浏览器里完成，页面这边靠自己持有的窗口引用 / 轮询来感知结果，所以：
///  - 子窗口拿到真实 URL 转交浏览器后**不能立刻销毁**——页面常用 `popup.closed` 判断
///    “用户中途关了授权窗口”，一旦判为已关闭就会放弃等待并报“授权流程未完成”；
///  - 用户在浏览器里授权期间 App 会退到后台，回来时不能让 App 自己的恢复逻辑把
///    页面刷新掉（见 [ExternalReturnGuard]）。
abstract final class PopupPolicy {
  /// 同时存活的弹窗跳板上限。页面异常连环 `window.open` 时直接拒绝，避免堆积原生 WebView。
  static const int maxConcurrent = 3;

  /// 跳板创建后等待“第一次真实导航”的上限。`window.open('about:blank')` 之后页面
  /// 通常很快改 location；超时仍无导航说明页面没有后续动作，回收即可。
  static const Duration waitForUrl = Duration(seconds: 15);

  /// 地址已转交浏览器后，子窗口保留多久（页面自己 `window.close()` 会提前回收）。
  /// 覆盖一次完整的授权（输入账号、验证码、扫码）所需时间。
  static const Duration keepAliveAfterRoute = Duration(minutes: 10);

  /// 同一 URL 在此窗口内不重复拉起浏览器（防双击 / 重入）。
  static const Duration dedupWindow = Duration(seconds: 2);

  /// 从系统浏览器回来时，多久之内仍视为“授权往返”而不触发自动刷新。
  static const Duration externalReturnWindow = Duration(minutes: 10);

  /// 可交给系统浏览器的目标：仅 http(s)、有 host、无 userinfo。
  /// `about:blank`、`javascript:`、`data:`、`intent:`、自定义协议等一律返回 null。
  static Uri? externalTarget(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') return null;
    if (uri.host.isEmpty) return null;
    if (uri.userInfo.isNotEmpty) return null;
    return uri;
  }

  /// 弹窗内一次导航该如何处置。
  /// - [PopupNav.allow]：空 / `about:blank`，页面稍后才会设置真实地址，继续等。
  /// - [PopupNav.external]：真实 http(s) 地址，转交系统浏览器。
  /// - [PopupNav.block]：其他协议，直接丢弃。
  static PopupNav classify(String? raw) {
    final trimmed = raw?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'about:blank') {
      return PopupNav.allow;
    }
    return externalTarget(trimmed) != null ? PopupNav.external : PopupNav.block;
  }
}

enum PopupNav { allow, external, block }

/// 单个弹窗“只路由一次”的状态。
///
/// `shouldOverrideUrlLoading` 与 `onLoadStart` 可能先后各给出一次同一个 URL，
/// 必须只拉起一次浏览器；而 `about:blank` 不消耗名额——页面之后改 location 才是真目标。
class PopupTicket {
  bool _routed = false;

  bool get routed => _routed;

  /// 首次拿到可外开的 URL 时返回它，之后一律返回 null。
  Uri? claim(String? raw) {
    if (_routed) return null;
    final target = PopupPolicy.externalTarget(raw);
    if (target == null) return null;
    _routed = true;
    return target;
  }
}

/// 并发数上限 + 休眠弹窗驱逐 + 短时间内同 URL 去重。
///
/// 已转交浏览器的弹窗会被保留一段时间（见 [PopupPolicy.keepAliveAfterRoute]），
/// 它们是“休眠”的；用户重试登录时若已满额，应驱逐最旧的休眠弹窗，而不是拒绝新的。
class PopupLimiter {
  PopupLimiter({
    this.maxConcurrent = PopupPolicy.maxConcurrent,
    this.dedupWindow = PopupPolicy.dedupWindow,
  });

  final int maxConcurrent;
  final Duration dedupWindow;

  /// windowId → 是否已转交浏览器（休眠）；LinkedHashMap 保持登记顺序。
  final Map<int, bool> _open = <int, bool>{};
  String? _lastUrl;
  DateTime? _lastAt;

  int get openCount => _open.length;

  bool tryOpen(int windowId) {
    if (_open.containsKey(windowId)) return false;
    if (_open.length >= maxConcurrent) return false;
    _open[windowId] = false;
    return true;
  }

  /// 该弹窗已把地址转交浏览器，进入休眠。
  void markRouted(int windowId) {
    if (_open.containsKey(windowId)) _open[windowId] = true;
  }

  /// 最早登记的休眠弹窗（没有则 null）——满额时的驱逐对象。
  int? oldestRouted() {
    for (final e in _open.entries) {
      if (e.value) return e.key;
    }
    return null;
  }

  void close(int windowId) => _open.remove(windowId);

  /// 同一 URL 在 [dedupWindow] 内只放行一次。
  bool allowLaunch(Uri url, DateTime now) {
    final key = url.toString();
    final lastAt = _lastAt;
    if (_lastUrl == key &&
        lastAt != null &&
        now.difference(lastAt) < dedupWindow) {
      return false;
    }
    _lastUrl = key;
    _lastAt = now;
    return true;
  }
}

/// 记录“本页刚把用户送去了系统浏览器”，供回到前台时跳过自动恢复。
///
/// ZRemote 的恢复逻辑在后台 ≥30 秒后回前台会探测页面写通道，探测失败就刷新页面。
/// 登录页上业务服务尚未就绪，探测必然失败，于是用户在浏览器里授权完回来，页面
/// 被刷新、正在等待授权的状态丢失。授权往返期间应让页面原样保留。
///
/// 只吞“一次”：回到前台并实际跳过一次探测后即清除标记，之后恢复逻辑照常工作。
class ExternalReturnGuard {
  ExternalReturnGuard({this.window = PopupPolicy.externalReturnWindow});

  final Duration window;
  DateTime? _launchedAt;

  bool get armed => _launchedAt != null;

  /// 即将拉起系统浏览器时调用。
  void noteLaunch(DateTime now) => _launchedAt = now;

  /// 回到前台、且原本要做自动探测/重载时调用：仍在授权往返窗口内则返回 true
  /// 并清除标记（本次跳过）；过期则清除标记并返回 false。
  bool consumeReturn(DateTime now) {
    final at = _launchedAt;
    if (at == null) return false;
    _launchedAt = null;
    return now.difference(at) <= window;
  }
}

/// 把 URL 交给 Android 系统浏览器。
abstract final class ExternalBrowser {
  /// 先 Custom Tab（留在应用任务栈内、与 Chrome 共享登录态；Google 等拒绝内嵌
  /// WebView 的登录页也能用），失败再退回外部浏览器应用。
  static Future<bool> open(Uri url) async {
    for (final mode in const [
      LaunchMode.inAppBrowserView,
      LaunchMode.externalApplication,
    ]) {
      try {
        if (await launchUrl(url, mode: mode)) return true;
      } catch (e) {
        debugPrint('[zr-popup] launch $mode failed: $e');
      }
    }
    return false;
  }
}

class _Popup {
  _Popup(this.windowId);

  final int windowId;
  final PopupTicket ticket = PopupTicket();
  Timer? timer;
  HeadlessInAppWebView? webView;
}

/// 接管 `InAppWebView.onCreateWindow`：为弹窗建一个无界面的子 WebView 当“跳板”，
/// 接住它的第一次真实导航，转交系统浏览器；之后子窗口**保留**，直到页面自己
/// `window.close()`、超时或页面销毁。
///
/// 为什么必须建子 WebView：Android 侧 `CreateWindowAction.request.url` 取自
/// `getHitTestResult().getExtra()`，只对“点链接”有值；JS 的 `window.open(url)` 恒为空，
/// 真实地址只会出现在子窗口随后的导航里（同时覆盖 `window.open('about:blank')` 再改
/// `location` 的写法）。
///
/// 仅 Android 生效；其他平台保持原行为（返回 false）。
class WebViewPopupRouter {
  WebViewPopupRouter({
    required this.openExternal,
    this.onOpenFailed,
    this.onExternalLaunch,
    PopupLimiter? limiter,
    DateTime Function()? clock,
    bool? isAndroid,
  }) : _limiter = limiter ?? PopupLimiter(),
       _clock = clock ?? DateTime.now,
       _isAndroid = isAndroid ?? defaultTargetPlatform == TargetPlatform.android;

  final Future<bool> Function(Uri url) openExternal;

  /// 浏览器拉起失败时回调（用于界面提示）。
  final VoidCallback? onOpenFailed;

  /// 即将把用户送去系统浏览器时回调（早于拉起，用于登记“授权往返”）。
  final VoidCallback? onExternalLaunch;

  final PopupLimiter _limiter;
  final DateTime Function() _clock;
  final bool _isAndroid;
  final Map<int, _Popup> _popups = <int, _Popup>{};
  bool _disposed = false;

  /// 返回 true 表示已接管：平台侧会把弹窗交给我们创建的子 WebView。
  Future<bool> onCreateWindow(
    CreateWindowAction action, {
    String? profileName,
  }) async {
    if (_disposed || !_isAndroid) return false;
    final windowId = action.windowId;
    if (!_limiter.tryOpen(windowId)) {
      // 满额：优先驱逐最旧的休眠弹窗（用户重试登录），否则才拒绝。
      final victim = _limiter.oldestRouted();
      if (victim == null) {
        debugPrint('[zr-popup] refuse window=$windowId (too many popups)');
        return false;
      }
      debugPrint('[zr-popup] evict dormant window=$victim for window=$windowId');
      _release(victim);
      if (!_limiter.tryOpen(windowId)) return false;
    }
    final popup = _Popup(windowId);
    _popups[windowId] = popup;

    void route(String? raw) {
      final target = popup.ticket.claim(raw);
      if (target == null) return;
      unawaited(_launch(target));
      // 保留子窗口：页面可能持有它的引用并轮询 closed / 之后再 close()。
      _limiter.markRouted(windowId);
      popup.timer?.cancel();
      popup.timer = Timer(PopupPolicy.keepAliveAfterRoute, () {
        debugPrint('[zr-popup] window=$windowId released: keep-alive expired');
        _release(windowId);
      });
    }

    final webView = HeadlessInAppWebView(
      windowId: windowId,
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        useShouldOverrideUrlLoading: true,
        // 与父 WebView 同一 profile：弹窗内容进程挂在父 WebView 的浏览上下文里，
        // 子 WebView 若落到默认 profile 会与之不一致。
        androidWebProfile: profileName,
      ),
      shouldOverrideUrlLoading: (_, navigation) async {
        final raw = navigation.request.url?.toString();
        switch (PopupPolicy.classify(raw)) {
          case PopupNav.allow:
            return NavigationActionPolicy.ALLOW;
          case PopupNav.external:
            route(raw);
            return NavigationActionPolicy.CANCEL;
          case PopupNav.block:
            return NavigationActionPolicy.CANCEL;
        }
      },
      // 兜底：个别内核版本不为弹窗首次导航触发 shouldOverrideUrlLoading。
      onLoadStart: (_, url) => route(url?.toString()),
      // 页面自己 window.close()：正常收尾。
      onCloseWindow: (_) {
        debugPrint('[zr-popup] window=$windowId closed by page');
        _release(windowId);
      },
    );
    popup.webView = webView;
    popup.timer = Timer(PopupPolicy.waitForUrl, () {
      debugPrint('[zr-popup] window=$windowId released: no navigation');
      _release(windowId);
    });

    try {
      await webView.run();
    } catch (e) {
      debugPrint('[zr-popup] run failed window=$windowId: $e');
      _release(windowId);
      return false;
    }
    return true;
  }

  Future<void> _launch(Uri target) async {
    if (_disposed) return;
    if (!_limiter.allowLaunch(target, _clock())) return;
    // 日志只记 host：授权地址的 query 里带 state。
    debugPrint('[zr-popup] open external host=${target.host}');
    onExternalLaunch?.call();
    final ok = await openExternal(target);
    if (!ok) onOpenFailed?.call();
  }

  void _release(int windowId) {
    final popup = _popups.remove(windowId);
    if (popup == null) return;
    popup.timer?.cancel();
    _limiter.close(windowId);
    final webView = popup.webView;
    if (webView == null) return;
    // 延后销毁：此刻可能正处在该 WebView 的回调栈内，立刻 dispose 会让回调的应答落空。
    Timer(const Duration(milliseconds: 300), () {
      unawaited(
        webView.dispose().catchError((Object e) {
          debugPrint('[zr-popup] dispose failed window=$windowId: $e');
        }),
      );
    });
  }

  void dispose() {
    _disposed = true;
    for (final id in _popups.keys.toList()) {
      _release(id);
    }
  }
}
