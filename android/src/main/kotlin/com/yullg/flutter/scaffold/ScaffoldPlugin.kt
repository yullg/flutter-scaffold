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

class ScaffoldPlugin : FlutterPlugin, ActivityAware, MethodCallHandler,
    PluginRegistry.ActivityResultListener {

    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var activityPluginBinding: ActivityPluginBinding? = null
    private var channel: MethodChannel? = null

    private val domainVerificationUseCase: DomainVerificationUseCase
    private val activityResultContractsUseCase: ActivityResultContractsUseCase
    private val contentResolverUseCase: ContentResolverUseCase

    init {
        domainVerificationUseCase = DomainVerificationUseCase(
            flutterPluginBinding = { flutterPluginBinding },
            activityPluginBinding = { activityPluginBinding },
        )
        activityResultContractsUseCase = ActivityResultContractsUseCase(
            flutterPluginBinding = { flutterPluginBinding },
            activityPluginBinding = { activityPluginBinding },
        )
        contentResolverUseCase = ContentResolverUseCase(
            flutterPluginBinding = { flutterPluginBinding },
            activityPluginBinding = { activityPluginBinding },
        )
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = binding
        channel = MethodChannel(
            binding.binaryMessenger,
            "com.yullg.flutter.scaffold/default"
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
        val useCaseContext = UseCaseContext(call, result)
        when (call.method) {
            "dvIsLinkHandlingAllowed" -> {
                domainVerificationUseCase.isLinkHandlingAllowed(useCaseContext)
            }

            "dvGetHostToStateMap" -> {
                domainVerificationUseCase.getHostToStateMap(useCaseContext)
            }

            "dvToSettings" -> {
                domainVerificationUseCase.toSettings(useCaseContext)
            }

            "arcCreateDocument" -> {
                activityResultContractsUseCase.createDocument(useCaseContext)
            }

            "arcOpenDocument" -> {
                activityResultContractsUseCase.openDocument(useCaseContext)
            }

            "crWriteFromFile" -> {
                contentResolverUseCase.writeFromFile(useCaseContext)
            }

            "crReadToFile" -> {
                contentResolverUseCase.readToFile(useCaseContext)
            }

            "crGetExtensionFromContentUri" -> {
                contentResolverUseCase.getExtensionFromContentUri(useCaseContext)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean =
        when {
            activityResultContractsUseCase.matches(requestCode) ->
                activityResultContractsUseCase.onActivityResult(requestCode, resultCode, data)

            else -> false
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
        this.activityPluginBinding = null
    }

}