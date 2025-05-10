package com.yullg.flutter.scaffold

import android.annotation.SuppressLint
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioPlaybackCaptureConfiguration
import android.media.projection.MediaProjection
import android.os.Build
import com.yullg.flutter.scaffold.core.AudioRecorder
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.nio.ByteBuffer

object AudioRecordUseCase : BaseUseCase(
    eventChannelName = "com.yullg.flutter.scaffold/audio_record_event",
    methodChannelName = "com.yullg.flutter.scaffold/audio_record_method"
), AudioRecorder.Listener {

    private var eventSink: EventChannel.EventSink? = null
    private var audioRecorder: AudioRecorder? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
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

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    @SuppressLint("MissingPermission")
    fun startAudioPlaybackCapture(mediaProjection: MediaProjection, json: JSONObject) {
        if (Build.VERSION.SDK_INT < 29) return
        val format = AudioFormat.Builder()
            .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
            .setSampleRate(json.getInt("sampleRate"))
            .setChannelMask(
                if (json.getBoolean("stereo")) {
                    AudioFormat.CHANNEL_IN_STEREO
                } else {
                    AudioFormat.CHANNEL_IN_MONO
                }
            ).build()
        val config = AudioPlaybackCaptureConfiguration.Builder(mediaProjection)
            .addMatchingUsage(AudioAttributes.USAGE_MEDIA)
            .addMatchingUsage(AudioAttributes.USAGE_GAME)
            .addMatchingUsage(AudioAttributes.USAGE_UNKNOWN)
            .build()
        audioRecorder = AudioRecorder(
            format = format,
            config = config
        ).apply {
            listener = this@AudioRecordUseCase
        }
        audioRecorder?.start()
    }

    @OptIn(DelicateCoroutinesApi::class)
    override fun onStatus(status: AudioRecorder.Status) {
        eventSink?.also {
            GlobalScope.launch(Dispatchers.Main) {
                it.success(
                    mapOf(
                        "event" to "status",
                        "value" to status.name
                    )
                )
            }
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    override fun onData(data: ByteBuffer) {
        eventSink?.also {
            GlobalScope.launch(Dispatchers.Main) {
                it.success(data.array())
            }
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    override fun onError(error: Throwable) {
        eventSink?.also {
            GlobalScope.launch(Dispatchers.Main) {
                it.error(ERROR_CODE, error.message, null)
            }
        }
    }

}

private const val ERROR_CODE = "AudioRecordUseCaseError"