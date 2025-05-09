package com.yullg.flutter.scaffold

import android.content.Intent
import android.media.projection.MediaProjectionManager
import androidx.core.content.ContextCompat
import com.yullg.flutter.scaffold.android.MediaProjectionService
import com.yullg.flutter.scaffold.core.BaseUseCase
import com.yullg.flutter.scaffold.core.RequestCode
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

object MediaProjectionUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/media_projection"
), PluginRegistry.ActivityResultListener {

    private var mediaProjectionToken: MediaProjectionToken? = null
    private var authorizeResult: MethodChannel.Result? = null

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        super.onAttachedToActivity(binding)
        binding.addActivityResultListener(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        super.onReattachedToActivityForConfigChanges(binding)
        binding.addActivityResultListener(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "authorize" -> {
                val activity = requiredActivityPluginBinding.activity
                val manager = activity.getSystemService(
                    MediaProjectionManager::class.java
                )
                val intent = manager.createScreenCaptureIntent()
                activity.startActivityForResult(
                    intent,
                    RequestCode.MEDIA_PROJECTION_CREATE_SCI.code
                )
                authorizeResult = result
            }

            "startAudioPlaybackCapture" -> {
                val activity = requiredActivityPluginBinding.activity
                val notificationJson = call.argument<String>("notification")!!
                val recorderJson = call.argument<String>("recorder")!!
                val token = mediaProjectionToken
                if (token != null) {
                    val intent = Intent(activity, MediaProjectionService::class.java).apply {
                        putExtra(
                            "action",
                            MediaProjectionService.ACTION_START_AUDIO_PLAYBACK_CAPTURE
                        )
                        putExtra("tokenResultCode", token.resultCode)
                        putExtra("tokenData", token.data)
                        putExtra("notificationJson", notificationJson)
                        putExtra("recorderJson", recorderJson)
                    }
                    ContextCompat.startForegroundService(activity, intent)
                    result.success(null)
                } else {
                    result.error(ERROR_CODE, "Not found media projection token!", null)
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (RequestCode.MEDIA_PROJECTION_CREATE_SCI.code == requestCode) {
            mediaProjectionToken = MediaProjectionToken(resultCode, data)
            authorizeResult?.success(null)
            authorizeResult = null
            return true
        } else {
            return false
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityPluginBinding?.removeActivityResultListener(this)
        super.onDetachedFromActivityForConfigChanges()
    }

    override fun onDetachedFromActivity() {
        activityPluginBinding?.removeActivityResultListener(this)
        super.onDetachedFromActivity()
    }
}

data class MediaProjectionToken(val resultCode: Int, val data: Intent?)

private const val ERROR_CODE = "MediaProjectionUseCaseError"