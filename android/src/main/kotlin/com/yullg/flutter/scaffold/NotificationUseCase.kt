package com.yullg.flutter.scaffold

import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationManagerCompat
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object NotificationUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/notification"
) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "createNotificationChannel" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val id = call.argument<String>("id")!!
                val importance = call.argument<Int>("importance")!!
                val name = call.argument<String>("name")!!
                val description = call.argument<String>("description")
                val vibrationEnabled = call.argument<Boolean>("vibrationEnabled")
                val lightsEnabled = call.argument<Boolean>("lightsEnabled")
                val showBadge = call.argument<Boolean>("showBadge")
                val channel = NotificationChannelCompat.Builder(id, importance).apply {
                    setName(name)
                    description?.also { setDescription(it) }
                    vibrationEnabled?.also { setVibrationEnabled(it) }
                    lightsEnabled?.also { setLightsEnabled(it) }
                    showBadge?.also { setShowBadge(it) }
                }.build()
                NotificationManagerCompat.from(applicationContext)
                    .createNotificationChannel(channel)
                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

}