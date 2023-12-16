package com.yullg.flutter.scaffold

import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** ScaffoldPlugin */
class ScaffoldPlugin : FlutterPlugin, ActivityAware, MethodCallHandler,
    PluginRegistry.ActivityResultListener {

    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var activityPluginBinding: ActivityPluginBinding? = null
    private var channel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = binding
        channel = MethodChannel(
            binding.binaryMessenger, "com.yullg.flutter.scaffold/default"
        ).apply {
            setMethodCallHandler(this@ScaffoldPlugin)
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(this)
        this.activityPluginBinding = binding
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(this)
        this.activityPluginBinding = binding
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "dvIsLinkHandlingAllowed" -> {
                flutterPluginBinding?.applicationContext?.let {
                    result.success(
                        DomainVerificationUseCase.isLinkHandlingAllowed(
                            it,
                            call.arguments()!!
                        )
                    )
                }
            }

            "dvIsMyLinkHandlingAllowed" -> {
                flutterPluginBinding?.applicationContext?.let {
                    result.success(DomainVerificationUseCase.isMyLinkHandlingAllowed(it))
                }
            }

            "dvGetHostToStateMap" -> {
                flutterPluginBinding?.applicationContext?.let {
                    result.success(
                        DomainVerificationUseCase.getHostToStateMap(
                            it,
                            call.arguments()!!
                        )
                    )
                }
            }

            "dvGetMyHostToStateMap" -> {
                flutterPluginBinding?.applicationContext?.let {
                    result.success(DomainVerificationUseCase.getMyHostToStateMap(it))
                }
            }

            "dvToSettings" -> {
                flutterPluginBinding?.applicationContext?.let {
                    result.success(DomainVerificationUseCase.toSettings(it, call.arguments()!!))
                }
            }

            "dvToMySettings" -> {
                flutterPluginBinding?.applicationContext?.let {
                    result.success(DomainVerificationUseCase.toMySettings(it))
                }
            }

            "scElapsedRealtime" -> {
                result.success(SystemClockUseCase.elapsedRealtime())
            }

            "scUptimeMillis" -> {
                result.success(SystemClockUseCase.uptimeMillis())
            }

            "safOpenDocument" -> {
                activityPluginBinding?.activity?.let {
                    StorageAccessFrameworkUseCase.openDocument(it, result, call.arguments()!!)
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return StorageAccessFrameworkUseCase.onActivityResult(requestCode, resultCode, data)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.activityPluginBinding?.removeActivityResultListener(this)
        this.activityPluginBinding = null
    }

    override fun onDetachedFromActivity() {
        this.activityPluginBinding?.removeActivityResultListener(this)
        this.activityPluginBinding = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.channel?.setMethodCallHandler(null)
        this.channel = null
        this.flutterPluginBinding = null
    }

}