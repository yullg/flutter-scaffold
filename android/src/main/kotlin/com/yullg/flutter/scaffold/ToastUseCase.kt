package com.yullg.flutter.scaffold

import android.widget.Toast
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ToastUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/toast",
) {

    private var toast: Toast? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "show" -> {
                val text = call.argument<String>("text")!!
                val longDuration = call.argument<Boolean>("longDuration")!!
                toast?.cancel()
                toast = Toast.makeText(
                    requiredFlutterPluginBinding.applicationContext,
                    text,
                    if (longDuration) Toast.LENGTH_LONG else Toast.LENGTH_SHORT
                ).apply {
                    show()
                }
                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

}