package com.pichillilorenzo.flutter_inappwebview_android.webview.in_app_webview;

import static android.content.Context.INPUT_METHOD_SERVICE;

import android.content.Context;
import android.graphics.Rect;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebView;
import android.widget.ListPopupWindow;

import androidx.annotation.Nullable;

public class InputAwareWebView extends WebView {
  private static final String LOG_TAG = "InputAwareWebView";
  @Nullable
  public View containerView;
  private View threadedInputConnectionProxyView;
  private ThreadedInputConnectionProxyAdapterView proxyAdapterView;
  private boolean useHybridComposition = false;

  public InputAwareWebView(Context context, @Nullable View containerView, Boolean useHybridComposition) {
    super(context);
    this.containerView = containerView;
    this.useHybridComposition = useHybridComposition == null ? false : useHybridComposition;
  }

  public InputAwareWebView(Context context, AttributeSet attrs) {
    super(context, attrs);
    this.containerView = null;
  }

  public InputAwareWebView(Context context) {
    super(context);
    this.containerView = null;
  }

  public InputAwareWebView(Context context, AttributeSet attrs, int defaultStyle) {
    super(context, attrs, defaultStyle);
    this.containerView = null;
  }

  public void setContainerView(View containerView) {
    this.containerView = containerView;

    if (proxyAdapterView == null) {
      return;
    }

    Log.w(LOG_TAG, "The containerView has changed while the proxyAdapterView exists.");
    if (containerView != null) {
      setInputConnectionTarget(proxyAdapterView);
    }
  }

  public void lockInputConnection() {
    if (proxyAdapterView == null) {
      return;
    }

    proxyAdapterView.setLocked(true);
  }

  public void unlockInputConnection() {
    if (proxyAdapterView == null) {
      return;
    }

    proxyAdapterView.setLocked(false);
  }

  void dispose() {
    if (useHybridComposition) {
      return;
    }
    resetInputConnection();
  }

  @Override
  public boolean checkInputConnectionProxy(final View view) {
    if (useHybridComposition) {
      return super.checkInputConnectionProxy(view);
    }
    View previousProxy = threadedInputConnectionProxyView;
    threadedInputConnectionProxyView = view;
    if (previousProxy == view) {
      return super.checkInputConnectionProxy(view);
    }
    if (containerView == null) {
      Log.e(
        LOG_TAG,
        "Can't create a proxy view because there's no container view. Text input may not work.");
      return super.checkInputConnectionProxy(view);
    }

    proxyAdapterView =
      new ThreadedInputConnectionProxyAdapterView(
         containerView,
         view,
         view.getHandler());
    setInputConnectionTarget( proxyAdapterView);
    return super.checkInputConnectionProxy(view);
  }

  @Override
  public void clearFocus() {
    super.clearFocus();

    if (useHybridComposition) {
      return;
    }
    resetInputConnection();
  }

  private void resetInputConnection() {
    if (proxyAdapterView == null) {
      return;
    }
    if (containerView == null) {
      Log.e(LOG_TAG, "Can't reset the input connection to the container view because there is none.");
      return;
    }
    setInputConnectionTarget( containerView);
  }

  private void setInputConnectionTarget(final View targetView) {
    if (containerView == null) {
      Log.e(
        LOG_TAG,
        "Can't set the input connection target because there is no containerView to use as a handler.");
      return;
    }

    targetView.requestFocus();
    containerView.post(
      new Runnable() {
        @Override
        public void run() {
          if (containerView == null) {
            Log.e(
                    LOG_TAG,
                    "Can't set the input connection target because there is no containerView to use as a handler.");
            return;
          }

          InputMethodManager imm =
                  (InputMethodManager) getContext().getSystemService(INPUT_METHOD_SERVICE);

          targetView.onWindowFocusChanged(true);

          if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            imm.isActive(containerView);
          }
        }
      });
  }

  @Override
  protected void onFocusChanged(boolean focused, int direction, Rect previouslyFocusedRect) {
    if (useHybridComposition) {
      super.onFocusChanged(focused, direction, previouslyFocusedRect);
      return;
    }

    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P
            && isCalledFromListPopupWindowShow()
            && !focused) {
      return;
    }
    super.onFocusChanged(focused, direction, previouslyFocusedRect);
  }

  private boolean isCalledFromListPopupWindowShow() {
    StackTraceElement[] stackTraceElements = Thread.currentThread().getStackTrace();
    for (StackTraceElement stackTraceElement : stackTraceElements) {
      if (stackTraceElement.getClassName().equals(ListPopupWindow.class.getCanonicalName())
              && stackTraceElement.getMethodName().equals("show")) {
        return true;
      }
    }
    return false;
  }
}