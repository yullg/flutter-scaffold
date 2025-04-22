package com.yullg.flutter.scaffold

import android.content.Intent
import android.media.projection.MediaProjectionManager
import com.yullg.flutter.scaffold.service.MediaProjectionService
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

object MediaProjectionUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/media_projection"
), PluginRegistry.ActivityResultListener {

    var mediaProjectionToken: MediaProjectionToken? = null
        private set

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
            "start" -> {
                val activity = requiredActivityPluginBinding.activity
                val manager = activity.getSystemService(
                    MediaProjectionManager::class.java
                )
                val intent = manager.createScreenCaptureIntent()
                activity.startActivityForResult(
                    intent,
                    RequestCode.MEDIA_PROJECTION_CREATE_SCI.code
                )
                result.success(null)
            }

            "stop" -> {
                mediaProjectionToken = null
                requiredFlutterPluginBinding.applicationContext.also {
                    it.stopService(Intent(it, MediaProjectionService::class.java))
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