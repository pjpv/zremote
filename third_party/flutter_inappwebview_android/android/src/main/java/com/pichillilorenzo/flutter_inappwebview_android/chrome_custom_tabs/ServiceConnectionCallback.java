package com.pichillilorenzo.flutter_inappwebview_android.chrome_custom_tabs;

import androidx.browser.customtabs.CustomTabsClient;

public interface ServiceConnectionCallback {
    void onServiceConnected(CustomTabsClient client);

    void onServiceDisconnected();
}