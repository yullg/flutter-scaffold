package com.yullg.flutter.scaffold

import android.widget.Toast
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object ToastUseCase : BaseUseCase(
        methodChannelName = "com.yullg.flutter.scaffold/toast",
) {

    private var toast: Toast? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "show" -> {
                val text = call.argument<String>("text")!!
                val isLongLength = call.argument<Boolean>("isLongLength")!!
                toast?.cancel()
                toast = Toast.makeText(
                        requiredFlutterPluginBinding.applicationContext,
                        text,
                        if (isLongLength) Toast.LENGTH_LONG else Toast.LENGTH_SHORT
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