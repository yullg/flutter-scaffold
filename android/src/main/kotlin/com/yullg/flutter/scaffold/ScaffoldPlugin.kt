package com.yullg.flutter.scaffold

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class ScaffoldPlugin : FlutterPlugin, ActivityAware {

    private val useCaseArray = arrayOf(
        ToastUseCase(),
        PackageInstallUseCase(),
        DomainVerificationUseCase(),
        ContentResolverUseCase(),
        ActivityResultContractsUseCase(),
        FileProviderUseCase()
    )

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        useCaseArray.forEach {
            it.onAttachedToEngine(binding)
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        useCaseArray.forEach {
            it.onAttachedToActivity(binding)
        }
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        useCaseArray.forEach {
            it.onReattachedToActivityForConfigChanges(binding)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        useCaseArray.forEach {
            it.onDetachedFromActivityForConfigChanges()
        }
    }

    override fun onDetachedFromActivity() {
        useCaseArray.forEach {
            it.onDetachedFromActivity()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        useCaseArray.forEach {
            it.onDetachedFromEngine(binding)
        }
    }

}