package com.pichillilorenzo.flutter_inappwebview_android.chrome_custom_tabs;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Browser;

import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsCallback;
import androidx.browser.customtabs.CustomTabsClient;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.browser.customtabs.CustomTabsServiceConnection;
import androidx.browser.customtabs.CustomTabsSession;
import androidx.browser.trusted.TrustedWebActivityIntent;

import java.util.List;
import java.util.Map;

public class CustomTabActivityHelper implements ServiceConnectionCallback {
    private CustomTabsSession mCustomTabsSession;
    private CustomTabsClient mClient;
    private CustomTabsServiceConnection mConnection;
    private ConnectionCallback mConnectionCallback;
    private CustomTabsCallback mCustomTabsCallback;

    public static void openCustomTab(Activity activity,
                                     Intent intent,
                                     Uri uri,
                                     @Nullable Map<String, String> headers,
                                     @Nullable Uri referrer,
                                     int requestCode) {
        intent.setData(uri);
        if (headers != null) {
            Bundle bundleHeaders = new Bundle();
            for (Map.Entry<String, String> header : headers.entrySet()) {
                bundleHeaders.putString(header.getKey(), header.getValue());
            }
            intent.putExtra(Browser.EXTRA_HEADERS, bundleHeaders);
        }
        if (referrer != null) {
            intent.putExtra(Intent.EXTRA_REFERRER, referrer);
        }
        activity.startActivityForResult(intent, requestCode);
    }

    public static void openCustomTab(Activity activity,
                                     CustomTabsIntent customTabsIntent,
                                     Uri uri,
                                     @Nullable Map<String, String> headers,
                                     @Nullable Uri referrer,
                                     int requestCode) {
        CustomTabActivityHelper.openCustomTab(activity, customTabsIntent.intent, uri,
                headers, referrer, requestCode);
    }

    public static void openTrustedWebActivity(Activity activity,
                                              TrustedWebActivityIntent trustedWebActivityIntent,
                                              Uri uri,
                                              @Nullable Map<String, String> headers,
                                              @Nullable Uri referrer,
                                              int requestCode) {
        CustomTabActivityHelper.openCustomTab(activity, trustedWebActivityIntent.getIntent(), uri,
                headers, referrer, requestCode);
    }

    public static boolean isAvailable(Activity activity) {
        return CustomTabsHelper.getPackageNameToUse(activity) != null;
    }

    public void unbindCustomTabsService(Activity activity) {
        if (mConnection == null) return;
        activity.unbindService(mConnection);
        mClient = null;
        mCustomTabsSession = null;
        mConnection = null;
    }

    @Nullable
    public CustomTabsSession getSession() {
        if (mClient == null) {
            mCustomTabsSession = null;
        } else if (mCustomTabsSession == null) {
            mCustomTabsSession = mClient.newSession(mCustomTabsCallback);
        }
        return mCustomTabsSession;
    }

    public void setConnectionCallback(ConnectionCallback connectionCallback) {
        this.mConnectionCallback = connectionCallback;
    }

    public void setCustomTabsCallback(CustomTabsCallback customTabsCallback) {
        this.mCustomTabsCallback = customTabsCallback;
    }

    public boolean bindCustomTabsService(Activity activity) {
        if (mClient != null) return true;

        String packageName = CustomTabsHelper.getPackageNameToUse(activity);
        if (packageName == null) return false;

        mConnection = new ServiceConnection(this);
        return CustomTabsClient.bindCustomTabsService(activity, packageName, mConnection);
    }

    public boolean mayLaunchUrl(Uri uri, Bundle extras, List<Bundle> otherLikelyBundles) {
        if (mClient == null) return false;

        CustomTabsSession session = getSession();
        if (session == null) return false;

        return session.mayLaunchUrl(uri, extras, otherLikelyBundles);
    }

    @Override
    public void onServiceConnected(CustomTabsClient client) {
        mClient = client;
        mClient.warmup(0L);
        if (mConnectionCallback != null) mConnectionCallback.onCustomTabsConnected();
    }

    @Override
    public void onServiceDisconnected() {
        mClient = null;
        mCustomTabsSession = null;
        if (mConnectionCallback != null) mConnectionCallback.onCustomTabsDisconnected();
    }

    public interface ConnectionCallback {
        void onCustomTabsConnected();

        void onCustomTabsDisconnected();
    }
}