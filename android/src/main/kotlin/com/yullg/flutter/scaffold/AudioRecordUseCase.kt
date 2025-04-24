package com.yullg.flutter.scaffold

import android.annotation.SuppressLint
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioPlaybackCaptureConfiguration
import android.media.projection.MediaProjection
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat
import com.yullg.flutter.scaffold.core.AudioRecorder
import com.yullg.flutter.scaffold.core.BaseUseCase
import com.yullg.flutter.scaffold.android.MediaProjectionService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer

object AudioRecordUseCase : BaseUseCase(
        eventChannelName = "com.yullg.flutter.scaffold/audio_record_event",
        methodChannelName = "com.yullg.flutter.scaffold/audio_record_method"
), AudioRecorder.Listener {

    private var audioRecorder: AudioRecorder? = null;

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startAudioPlaybackCapture" -> {
                val notificationId = call.argument<Int>("notificationId")!!
                val notificationChannelId = call.argument<String>("notificationChannelId")!!
                val notificationContentTitle = call.argument<String>("notificationContentTitle")
                val notificationContentText = call.argument<String>("notificationContentText")
                val token = MediaProjectionUseCase.mediaProjectionToken
                if (token != null) {
                    requiredFlutterPluginBinding.applicationContext.also {
                        val intent = Intent(it, MediaProjectionService::class.java).apply {
                            putExtra(
                                    "action",
                                    MediaProjectionService.ACTION_START_AUDIO_PLAYBACK_CAPTURE
                            )
                            putExtra("resultCode", token.resultCode)
                            putExtra("data", token.data)
                            putExtra("notificationId", notificationId)
                            putExtra("notificationChannelId", notificationChannelId)
                            putExtra("notificationContentTitle", notificationContentTitle)
                            putExtra("notificationContentText", notificationContentText)
                        }
                        ContextCompat.startForegroundService(it, intent)
                    }
                    result.success(null)
                } else {
                    result.error(ERROR_CODE, "Not found media projection token!", null)
                }
            }

            "resume" -> {
                audioRecorder?.start()
                result.success(null)
            }

            "stop" -> {
                audioRecorder?.stop()
                result.success(null)
            }

            "release" -> {
                audioRecorder?.release()
                audioRecorder = null
                result.success(null)
            }
        }
    }

    @SuppressLint("MissingPermission")
    fun startAudioPlaybackCapture(mediaProjection: MediaProjection) {
        if (Build.VERSION.SDK_INT < 29) return
        val format = AudioFormat.Builder()
                .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                .setSampleRate(44100)
                .setChannelMask(AudioFormat.CHANNEL_IN_STEREO)
                .build()
        val config = AudioPlaybackCaptureConfiguration.Builder(mediaProjection)
                .excludeUsage(AudioAttributes.USAGE_UNKNOWN)
                .build()
        audioRecorder = AudioRecorder(
                format = format,
                config = config
        ).apply {
            listener = this@AudioRecordUseCase
        }
        audioRecorder?.start()
    }

    override fun onStatus(status: AudioRecorder.Status) {
        Log.i("AudioReordUserCase", "onStatus: $status")
    }

    override fun onData(data: ByteBuffer) {
        Log.i("AudioReordUserCase", "onData: $data")
    }

    override fun onError(error: Throwable) {
        Log.e("AudioReordUserCase", "onError: ", error)
    }

}

private const val ERROR_CODE = "AudioRecordUseCaseError"