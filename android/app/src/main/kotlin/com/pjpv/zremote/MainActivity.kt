package com.pjpv.zremote

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "zremote/keepalive",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    try {
                        KeepAliveService.start(this)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("start_failed", e.message, null)
                    }
                }
                "stop" -> {
                    stopService(Intent(this, KeepAliveService::class.java))
                    result.success(null)
                }
                "isRunning" -> result.success(KeepAliveService.isRunning)
                "isBlocked" -> result.success(KeepAliveService.lastStartBlocked)
                "isBatteryIgnored" -> result.success(isBatteryIgnored())
                "requestBatteryIgnore" -> {
                    if (requestBatteryIgnore()) result.success(null)
                    else result.error("battery_ignore_failed", null, null)
                }
                "requestVendorExemption" -> {
                    if (requestVendorExemption()) result.success(null)
                    else result.error("vendor_exemption_failed", null, null)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "zremote/app",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "openAppSettings" -> {
                    try {
                        startActivity(
                            Intent(
                                Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                                Uri.parse("package:$packageName"),
                            ),
                        )
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("open_failed", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isBatteryIgnored(): Boolean =
        (getSystemService(Context.POWER_SERVICE) as PowerManager)
            .isIgnoringBatteryOptimizations(packageName)

    private fun requestBatteryIgnore(): Boolean = try {
        startActivity(
            Intent(
                Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                Uri.parse("package:$packageName"),
            ),
        )
        true
    } catch (e: Exception) {
        false
    }

    private fun requestVendorExemption(): Boolean {
        val miuiCandidates = listOf(
            Intent().setClassName(
                "com.miui.powerkeeper",
                "com.miui.powerkeeper.powersettings.PowerSettingsActivity",
            ),
            Intent().setClassName(
                "com.miui.powerkeeper",
                "com.miui.powerkeeper.ui.HiddenAppsConfigActivity",
            )
                .putExtra("package_name", packageName)
                .putExtra("power_keeper_activity", "PowerKeeperActivityCustom"),
            Intent().setClassName(
                "com.miui.securitycenter",
                "com.miui.permcenter.autostart.AutoStartManagementActivity",
            ),
        )
        for (intent in miuiCandidates) {
            try {
                startActivity(intent)
                return true
            } catch (e: Exception) {
            }
        }
        return try {
            startActivity(
                Intent(
                    Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                    Uri.parse("package:$packageName"),
                ),
            )
            true
        } catch (e: Exception) {
            false
        }
    }
}
