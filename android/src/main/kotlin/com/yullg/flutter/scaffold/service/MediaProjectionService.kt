package com.yullg.flutter.scaffold.service

import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.IntentCompat
import com.yullg.flutter.scaffold.AudioRecordUseCase
import com.yullg.flutter.scaffold.R

class MediaProjectionService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent == null) {
            stopSelf(startId)
            return START_NOT_STICKY
        }
        try {
            val action = intent.getIntExtra("action", 0)
            if (ACTION_START_AUDIO_PLAYBACK_CAPTURE == action) {
                val resultCode = intent.getIntExtra("resultCode", 0)
                val data = IntentCompat.getParcelableExtra(intent, "data", Intent::class.java)!!
                val notificationId = intent.getIntExtra("notificationId", 1)
                val notificationChannelId = intent.getStringExtra("notificationChannelId")!!
                val notificationContentTitle = intent.getStringExtra("notificationContentTitle")
                val notificationContentText = intent.getStringExtra("notificationContentText")
                ServiceCompat.startForeground(
                    this,
                    notificationId,
                    NotificationCompat.Builder(this, notificationChannelId)
                        .setSmallIcon(R.drawable.scaffold_media_projection_notification_small_icon)
                        .setContentTitle(notificationContentTitle)
                        .setContentText(notificationContentText)
                        .build(),
                    if (Build.VERSION.SDK_INT >= 29) {
                        ServiceInfo.FOREGROUND_SERVICE_TYPE_MANIFEST
                    } else {
                        0
                    }
                )
                val manager = getSystemService(MediaProjectionManager::class.java)
                val mediaProjection = manager.getMediaProjection(resultCode, data)
                AudioRecordUseCase.startAudioPlaybackCapture(mediaProjection)
            } else {
                stopSelf(startId)
                return START_NOT_STICKY
            }
        } catch (e: Throwable) {
            Log.e(TAG, "onStartCommand: ", e)
        }
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    companion object {
        const val ACTION_START_AUDIO_PLAYBACK_CAPTURE = 1
    }
}

private const val TAG = "MediaProjectionService"