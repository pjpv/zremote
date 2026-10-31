
package com.pichillilorenzo.flutter_inappwebview_android.print_job;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.pichillilorenzo.flutter_inappwebview_android.InAppWebViewFlutterPlugin;
import com.pichillilorenzo.flutter_inappwebview_android.types.Disposable;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

@RequiresApi(api = Build.VERSION_CODES.KITKAT)
public class PrintJobManager implements Disposable {
  protected static final String LOG_TAG = "PrintJobManager";
  @Nullable
  public InAppWebViewFlutterPlugin plugin;
  public final Map<String, PrintJobController> jobs = new HashMap<>();

  public PrintJobManager(@NonNull final InAppWebViewFlutterPlugin plugin) {
    super();
    this.plugin = plugin;
  }

  public void dispose() {
    Collection<PrintJobController> printJobControllers = jobs.values();
    for (PrintJobController job : printJobControllers) {
      if (job != null) {
        job.dispose();
      }
    }
    jobs.clear();
    plugin = null;
  }
}
