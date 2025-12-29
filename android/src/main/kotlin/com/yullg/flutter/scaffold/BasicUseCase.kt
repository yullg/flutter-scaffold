package com.yullg.flutter.scaffold

import android.os.SystemClock
import android.widget.Toast
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object BasicUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/basic"
) {

    private var toast: Toast? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "ToastABM" -> {
                when (call.argument<String>("method")) {
                    "show" -> {
                        val text = call.argument<String>("text")!!
                        val duration = when (call.argument<Boolean>("longDuration")) {
                            true -> Toast.LENGTH_LONG
                            else -> Toast.LENGTH_SHORT
                        }
                        toast?.cancel()
                        toast = Toast.makeText(
                            requiredFlutterPluginBinding.applicationContext,
                            text,
                            duration
                        ).apply {
                            show()
                        }
                        result.success(null)
                    }

                    "cancel" -> {
                        toast?.cancel()
                        toast = null
                        result.success(null)
                    }

                    else -> throw IllegalArgumentException()
                }
            }

            "SystemClockABM" -> {
                when (call.arguments<String>()) {
                    "uptimeMillis" -> {
                        result.success(SystemClock.uptimeMillis())
                    }

                    "elapsedRealtime" -> {
                        result.success(SystemClock.elapsedRealtime())
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