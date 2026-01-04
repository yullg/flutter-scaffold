package com.yullg.flutter.scaffold

import android.os.SystemClock
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationManagerCompat
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.regex.Pattern

object BasicUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/basic"
) {

    private val pattern = Pattern.compile("^(.+?)(\\.(.+))?$")

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val matcher = pattern.matcher(call.method)
        if (!matcher.matches()) {
            throw IllegalArgumentException()
        }
        when (matcher.group(1)) {
            "SystemClockABM" -> {
                when (matcher.group(3)) {
                    "uptimeMillis" -> {
                        result.success(SystemClock.uptimeMillis())
                    }

                    "elapsedRealtime" -> {
                        result.success(SystemClock.elapsedRealtime())
                    }

                    else -> throw IllegalArgumentException()
                }
            }

            "NotificationChannelABM" -> {
                when (matcher.group(3)) {
                    "create" -> {
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

                    else -> throw IllegalArgumentException()
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

}