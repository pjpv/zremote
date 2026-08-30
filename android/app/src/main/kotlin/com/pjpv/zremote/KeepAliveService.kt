package com.pjpv.zremote

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager

class KeepAliveService : Service() {

    companion object {
        @Volatile
        var isRunning = false
            private set

        @Volatile
        var lastStartBlocked = false
            private set

        private const val CHANNEL_ID = "zr_keep"
        private const val NOTIFICATION_ID = 901
        private const val WAKE_LOCK_TAG = "zremote:keepalive"
        private const val RETRY_MS = 2000L

        fun start(context: Context) {
            context.startForegroundService(
                Intent(context, KeepAliveService::class.java),
            )
        }
    }

    private var wakeLock: PowerManager.WakeLock? = null

    private val screenReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                Intent.ACTION_SCREEN_OFF -> holdWakeLock()
                Intent.ACTION_SCREEN_ON -> releaseWakeLock()
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_OFF)
            addAction(Intent.ACTION_SCREEN_ON)
        }
        if (Build.VERSION.SDK_INT >= 33) {
            registerReceiver(screenReceiver, filter, RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(screenReceiver, filter)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        isRunning = true
        if (!promoteToForeground()) {
            _handler.postDelayed(
                {
                    if (isRunning && !promoteToForeground()) stopSelf()
                },
                RETRY_MS,
            )
        }
        if (!powerManager.isInteractive) holdWakeLock()
        return START_STICKY
    }

    private val _handler = Handler(Looper.getMainLooper())

    private fun promoteToForeground(): Boolean = try {
        val notification = buildNotification()
        if (Build.VERSION.SDK_INT >= 34) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
        lastStartBlocked = false
        true
    } catch (e: Exception) {
        lastStartBlocked = true
        false
    }

    override fun onDestroy() {
        _handler.removeCallbacksAndMessages(null)
        try {
            unregisterReceiver(screenReceiver)
        } catch (e: Exception) {
        }
        releaseWakeLock()
        isRunning = false
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private val powerManager: PowerManager
        get() = getSystemService(POWER_SERVICE) as PowerManager

    private fun buildNotification(): Notification {
        if (Build.VERSION.SDK_INT >= 26) {
            val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_ID,
                    "后台守护",
                    NotificationManager.IMPORTANCE_LOW,
                ).apply {
                    description = "保持会话监控运行所需的常驻通知"
                    setShowBadge(false)
                },
            )
        }
        val contentIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val builder = if (Build.VERSION.SDK_INT >= 26) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        return builder
            .setContentTitle("ZRemote 后台守护中")
            .setContentText("正在保持会话监控与事件通知")
            .setSmallIcon(R.drawable.ic_notification)
            .setContentIntent(contentIntent)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .build()
    }

    @SuppressLint("WakelockTimeout")
    private fun holdWakeLock() {
        val lock = wakeLock ?: powerManager
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, WAKE_LOCK_TAG)
            .also {
                it.setReferenceCounted(false)
                wakeLock = it
            }
        if (!lock.isHeld) lock.acquire()
    }

    private fun releaseWakeLock() {
        wakeLock?.takeIf { it.isHeld }?.release()
    }
}
