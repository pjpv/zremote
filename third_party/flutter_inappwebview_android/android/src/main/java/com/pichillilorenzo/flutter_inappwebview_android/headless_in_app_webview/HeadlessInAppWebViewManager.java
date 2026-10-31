
package com.pichillilorenzo.flutter_inappwebview_android.headless_in_app_webview;

import android.content.Context;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;

import com.pichillilorenzo.flutter_inappwebview_android.InAppWebViewFlutterPlugin;
import com.pichillilorenzo.flutter_inappwebview_android.types.ChannelDelegateImpl;
import com.pichillilorenzo.flutter_inappwebview_android.webview.in_app_webview.FlutterWebView;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class HeadlessInAppWebViewManager extends ChannelDelegateImpl {
  protected static final String LOG_TAG = "HeadlessInAppWebViewManager";
  public static final String METHOD_CHANNEL_NAME = "com.pichillilorenzo/flutter_headless_inappwebview";
  public final Map<String, HeadlessInAppWebView> webViews = new HashMap<>();
  @Nullable
  public InAppWebViewFlutterPlugin plugin;

  public HeadlessInAppWebViewManager(final InAppWebViewFlutterPlugin plugin) {
    super(new MethodChannel(plugin.messenger, METHOD_CHANNEL_NAME));
    this.plugin = plugin;
  }

  @Override
  public void onMethodCall(final MethodCall call, @NonNull final Result result) {
    final String id = (String) call.argument("id");

    switch (call.method) {
      case "run":
        {
          HashMap<String, Object> params = (HashMap<String, Object>) call.argument("params");
          run(id, params);
        }
        result.success(true);
        break;
      default:
        result.notImplemented();
    }
  }

  public void run(String id, HashMap<String, Object> params) {
    if (plugin == null || (plugin.activity == null && plugin.applicationContext == null)) return;
    Context context = plugin.activity;
    if (context == null) {
      context = plugin.applicationContext;
    }
    FlutterWebView flutterWebView = new FlutterWebView(plugin, context, id, params);
    HeadlessInAppWebView headlessInAppWebView = new HeadlessInAppWebView(plugin, id, flutterWebView);
    webViews.put(id, headlessInAppWebView);
    headlessInAppWebView.prepare(params);
    headlessInAppWebView.onWebViewCreated();
    flutterWebView.makeInitialLoad(params);
  }

  @Override
  public void dispose() {
    super.dispose();
    Collection<HeadlessInAppWebView> headlessInAppWebViews = webViews.values();
    for (HeadlessInAppWebView headlessInAppWebView : headlessInAppWebViews) {
      if (headlessInAppWebView != null) {
        headlessInAppWebView.dispose();
      }
    }
    webViews.clear();
    plugin = null;
  }
}
