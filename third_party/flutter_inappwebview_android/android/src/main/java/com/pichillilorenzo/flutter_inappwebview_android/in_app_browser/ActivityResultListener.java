package com.pichillilorenzo.flutter_inappwebview_android.in_app_browser;

import android.content.Intent;

public interface ActivityResultListener {
  boolean onActivityResult(int requestCode, int resultCode, Intent data);
}
