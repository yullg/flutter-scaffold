package com.yullg.flutter.scaffold

import android.content.Intent
import android.content.pm.verify.domain.DomainVerificationManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class DomainVerificationUseCase(
    flutterPluginBinding: () -> FlutterPlugin.FlutterPluginBinding?,
    activityPluginBinding: () -> ActivityPluginBinding?,
) : UseCase(flutterPluginBinding, activityPluginBinding) {

    fun isLinkHandlingAllowed(useCaseContext: UseCaseContext) {
        val packageName = useCaseContext.call.arguments<String>()
            ?: requiredFlutterPluginBinding.applicationContext.packageName
        if (Build.VERSION.SDK_INT >= 31) {
            val manager = requiredFlutterPluginBinding.applicationContext.getSystemService(
                DomainVerificationManager::class.java
            )
            val userState = manager.getDomainVerificationUserState(packageName)
            useCaseContext.result.success(userState?.isLinkHandlingAllowed)
        } else {
            useCaseContext.result.success(null)
        }
    }

    fun getHostToStateMap(useCaseContext: UseCaseContext) {
        val packageName = useCaseContext.call.arguments<String>()
            ?: requiredFlutterPluginBinding.applicationContext.packageName
        if (Build.VERSION.SDK_INT >= 31) {
            val manager = requiredFlutterPluginBinding.applicationContext.getSystemService(
                DomainVerificationManager::class.java
            )
            val userState = manager.getDomainVerificationUserState(packageName)
            useCaseContext.result.success(userState?.hostToStateMap)
        } else {
            useCaseContext.result.success(null)
        }
    }

    fun toSettings(useCaseContext: UseCaseContext) {
        val packageName = useCaseContext.call.arguments<String>()
            ?: requiredFlutterPluginBinding.applicationContext.packageName
        if (Build.VERSION.SDK_INT >= 31) {
            val intent = Intent(
                if (Build.MANUFACTURER.equals("samsung", ignoreCase = true)) {
                    // 三星设备不兼容，改为跳转应用设置
                    // https://stackoverflow.com/questions/70953672/android-12-deep-link-association-by-user-fails-because-of-crash-in-samsung-setti
                    Settings.ACTION_APPLICATION_DETAILS_SETTINGS
                } else {
                    Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS
                },
                Uri.parse("package:$packageName"),
            ).apply {
                addCategory(Intent.CATEGORY_DEFAULT)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
                addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS)
            }
            requiredFlutterPluginBinding.applicationContext.startActivity(intent)

        }
        useCaseContext.result.success(null)
    }

}