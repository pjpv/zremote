package com.pichillilorenzo.flutter_inappwebview_android.webview.in_app_webview;

import static android.hardware.display.DisplayManager.DisplayListener;

import android.annotation.TargetApi;
import android.hardware.display.DisplayManager;
import android.os.Build;
import android.util.Log;
import java.lang.reflect.Field;
import java.util.ArrayList;

@TargetApi(Build.VERSION_CODES.KITKAT)
public
class DisplayListenerProxy {
    private static final String TAG = "DisplayListenerProxy";

    private ArrayList<DisplayListener> listenersBeforeWebView;

    public void onPreWebViewInitialization(DisplayManager displayManager) {
        listenersBeforeWebView = yoinkDisplayListeners(displayManager);
    }

    public void onPostWebViewInitialization(final DisplayManager displayManager) {
        final ArrayList<DisplayListener> webViewListeners = yoinkDisplayListeners(displayManager);
        webViewListeners.removeAll(listenersBeforeWebView);

        if (webViewListeners.isEmpty()) {
            return;
        }

        for (DisplayListener webViewListener : webViewListeners) {
            displayManager.unregisterDisplayListener(webViewListener);

            displayManager.registerDisplayListener(
                    new DisplayListener() {
                        @Override
                        public void onDisplayAdded(int displayId) {
                            for (DisplayListener webViewListener : webViewListeners) {
                                webViewListener.onDisplayAdded(displayId);
                            }
                        }

                        @Override
                        public void onDisplayRemoved(int displayId) {
                            for (DisplayListener webViewListener : webViewListeners) {
                                webViewListener.onDisplayRemoved(displayId);
                            }
                        }

                        @Override
                        public void onDisplayChanged(int displayId) {
                            if (displayManager.getDisplay(displayId) == null) {
                                return;
                            }
                            for (DisplayListener webViewListener : webViewListeners) {
                                webViewListener.onDisplayChanged(displayId);
                            }
                        }
                    },
                    null);
        }
    }

    @SuppressWarnings({"unchecked", "PrivateApi"})
    private static ArrayList<DisplayListener> yoinkDisplayListeners(DisplayManager displayManager) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            return new ArrayList<>();
        }
        try {
            Field displayManagerGlobalField = DisplayManager.class.getDeclaredField("mGlobal");
            displayManagerGlobalField.setAccessible(true);
            Object displayManagerGlobal = displayManagerGlobalField.get(displayManager);
            Field displayListenersField =
                    displayManagerGlobal.getClass().getDeclaredField("mDisplayListeners");
            displayListenersField.setAccessible(true);
            ArrayList<Object> delegates =
                    (ArrayList<Object>) displayListenersField.get(displayManagerGlobal);

            Field listenerField = null;
            ArrayList<DisplayManager.DisplayListener> listeners = new ArrayList<>();
            for (Object delegate : delegates) {
                if (listenerField == null) {
                    listenerField = delegate.getClass().getField("mListener");
                    listenerField.setAccessible(true);
                }
                DisplayManager.DisplayListener listener =
                        (DisplayManager.DisplayListener) listenerField.get(delegate);
                listeners.add(listener);
            }
            return listeners;
        } catch (NoSuchFieldException | IllegalAccessException e) {
            Log.w(TAG, "Could not extract WebView's display listeners. " + e);
            return new ArrayList<>();
        }
    }
}