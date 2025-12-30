package com.yullg.flutter.scaffold

import android.os.SystemClock
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object BasicUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/basic"
) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
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