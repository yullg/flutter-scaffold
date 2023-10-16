package com.yullg.flutter.scaffold

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** ScaffoldPlugin */
class ScaffoldPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext()
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.yullg.flutter.scaffold/default")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "dvIsLinkHandlingAllowed" -> {
                val argument = call.arguments<String?>() as String
                result.success(DomainVerificationUseCase.isLinkHandlingAllowed(context, argument))
            }

            "dvIsMyLinkHandlingAllowed" -> {
                result.success(DomainVerificationUseCase.isMyLinkHandlingAllowed(context))
            }

            "dvGetHostToStateMap" -> {
                val argument = call.arguments<String?>() as String
                result.success(DomainVerificationUseCase.getHostToStateMap(context, argument))
            }

            "dvGetMyHostToStateMap" -> {
                result.success(DomainVerificationUseCase.getMyHostToStateMap(context))
            }

            "dvToSettings" -> {
                val argument = call.arguments<String?>() as String
                result.success(DomainVerificationUseCase.toSettings(context, argument))
            }

            "dvToMySettings" -> {
                result.success(DomainVerificationUseCase.toMySettings(context))
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
