package com.pichillilorenzo.flutter_inappwebview_android.webview.in_app_webview;

import android.os.Handler;
import android.os.IBinder;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;

final class ThreadedInputConnectionProxyAdapterView extends View {
    final Handler imeHandler;
    final IBinder windowToken;
    final View containerView;
    final View rootView;
    final View targetView;

    private boolean triggerDelayed = true;
    private boolean isLocked = false;
    private InputConnection cachedConnection;

    ThreadedInputConnectionProxyAdapterView(View containerView, View targetView, Handler imeHandler) {
        super(containerView.getContext());
        this.imeHandler = imeHandler;
        this.containerView = containerView;
        this.targetView = targetView;
        windowToken = containerView.getWindowToken();
        rootView = containerView.getRootView();
        setFocusable(true);
        setFocusableInTouchMode(true);
        setVisibility(VISIBLE);
    }

    boolean isTriggerDelayed() {
        return triggerDelayed;
    }

    void setLocked(boolean locked) {
        isLocked = locked;
    }

    @Override
    public InputConnection onCreateInputConnection(final EditorInfo outAttrs) {
        triggerDelayed = false;
        InputConnection inputConnection =
                (isLocked) ? cachedConnection : targetView.onCreateInputConnection(outAttrs);
        triggerDelayed = true;
        cachedConnection = inputConnection;
        return inputConnection;
    }

    @Override
    public boolean checkInputConnectionProxy(View view) {
        return true;
    }

    @Override
    public boolean hasWindowFocus() {
        return true;
    }

    @Override
    public View getRootView() {
        return rootView;
    }

    @Override
    public boolean onCheckIsTextEditor() {
        return true;
    }

    @Override
    public boolean isFocused() {
        return true;
    }

    @Override
    public IBinder getWindowToken() {
        return windowToken;
    }

    @Override
    public Handler getHandler() {
        return imeHandler;
    }
}