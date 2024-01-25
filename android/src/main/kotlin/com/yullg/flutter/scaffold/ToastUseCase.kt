package com.yullg.flutter.scaffold

import android.widget.Toast
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class ToastUseCase(
    flutterPluginBinding: () -> FlutterPlugin.FlutterPluginBinding?,
    activityPluginBinding: () -> ActivityPluginBinding?,
) : UseCase(flutterPluginBinding, activityPluginBinding) {

    private var toast: Toast? = null

    fun show(useCaseContext: UseCaseContext) {
        val text = useCaseContext.call.argument<String>("text")!!
        val longTime = useCaseContext.call.argument<Boolean>("longTime")!!
        toast?.cancel()
        toast = Toast.makeText(
            requiredFlutterPluginBinding.applicationContext,
            text,
            if (longTime) Toast.LENGTH_LONG else Toast.LENGTH_SHORT
        ).apply {
            show()
        }
        useCaseContext.result.success(null)
    }

}