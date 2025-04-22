package com.yullg.flutter.scaffold

import android.annotation.SuppressLint
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioPlaybackCaptureConfiguration
import android.media.AudioRecord
import android.media.projection.MediaProjection
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat
import com.yullg.flutter.scaffold.core.AudioRecorder
import com.yullg.flutter.scaffold.service.MediaProjectionService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

object AudioRecordUseCase : BaseUseCase(
    eventChannelName = "com.yullg.flutter.scaffold/audio_record_event",
    methodChannelName = "com.yullg.flutter.scaffold/audio_record_method"
), AudioRecorder.Listener {

    private val executor = Executors.newSingleThreadExecutor()
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
            }

            "stop" -> {
                audioRecorder?.stop()
            }

            "release" -> {
                audioRecorder?.release()
                audioRecorder = null
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
        val minBufferSize = AudioRecord.getMinBufferSize(
            format.sampleRate,
            format.channelMask,
            format.encoding
        )
        val recorder = AudioRecord.Builder()
            .setAudioPlaybackCaptureConfig(
                AudioPlaybackCaptureConfiguration.Builder(mediaProjection)
                    .excludeUsage(AudioAttributes.USAGE_UNKNOWN)
                    .build()
            )
            .setAudioFormat(format)
            .setBufferSizeInBytes(minBufferSize * 2)
            .build()
        this.audioRecorder = AudioRecorder(
            recorder,
            executor,
            minBufferSize * 2,
            this
        )
        audioRecorder?.start()
    }

    override fun onData(data: ShortArray) {
        Log.i("AudioRecordUseCase", "onData: " + data.size)
    }

}

private const val ERROR_CODE = "AudioRecordUseCaseError"