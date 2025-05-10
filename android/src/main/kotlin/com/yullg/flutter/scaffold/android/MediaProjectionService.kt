package com.yullg.flutter.scaffold.android

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
import org.json.JSONObject

class MediaProjectionService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent == null) {
            stopSelf(startId)
            return START_NOT_STICKY
        }
        try {
            val action = intent.getIntExtra("action", 0)
            if (ACTION_START_AUDIO_PLAYBACK_CAPTURE == action) {
                val tokenResultCode = intent.getIntExtra("tokenResultCode", 0)
                val tokenData =
                    IntentCompat.getParcelableExtra(intent, "tokenData", Intent::class.java)!!
                val notificationJson = JSONObject(intent.getStringExtra("notificationJson")!!)
                val recorderJson = JSONObject(intent.getStringExtra("recorderJson")!!)
                val notification =
                    NotificationCompat.Builder(this, notificationJson.getString("channelId"))
                        .apply {
                            setSmallIcon(R.drawable.scaffold_media_projection_notification_small_icon)
                            if (!notificationJson.isNull("contentTitle")) {
                                setContentTitle(notificationJson.getString("contentTitle"))
                            }
                            if (!notificationJson.isNull("contentText")) {
                                setContentText(notificationJson.getString("contentText"))
                            }
                        }.build()
                ServiceCompat.startForeground(
                    this,
                    notificationJson.getInt("id"),
                    notification,
                    if (Build.VERSION.SDK_INT >= 29) {
                        ServiceInfo.FOREGROUND_SERVICE_TYPE_MANIFEST
                    } else {
                        0
                    }
                )
                val manager = getSystemService(MediaProjectionManager::class.java)
                val mediaProjection = manager.getMediaProjection(tokenResultCode, tokenData)
                AudioRecordUseCase.startAudioPlaybackCapture(mediaProjection, recorderJson)
            } else {
                stopSelf(startId)
            }
        } catch (e: Throwable) {
            Log.e(TAG, "Command start failed", e)
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