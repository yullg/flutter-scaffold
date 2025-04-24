package com.yullg.flutter.scaffold

import android.content.Intent
import android.content.pm.verify.domain.DomainVerificationManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class DomainVerificationUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/domain_verification"
) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isLinkHandlingAllowed" -> {
                if (Build.VERSION.SDK_INT >= 31) {
                    val packageName = call.arguments<String>()
                        ?: requiredFlutterPluginBinding.applicationContext.packageName
                    val manager = requiredFlutterPluginBinding.applicationContext.getSystemService(
                        DomainVerificationManager::class.java
                    )
                    val userState = manager.getDomainVerificationUserState(packageName)
                    result.success(userState?.isLinkHandlingAllowed)
                } else {
                    result.success(null)
                }
            }

            "getHostToStateMap" -> {
                if (Build.VERSION.SDK_INT >= 31) {
                    val packageName = call.arguments<String>()
                        ?: requiredFlutterPluginBinding.applicationContext.packageName
                    val manager = requiredFlutterPluginBinding.applicationContext.getSystemService(
                        DomainVerificationManager::class.java
                    )
                    val userState = manager.getDomainVerificationUserState(packageName)
                    result.success(userState?.hostToStateMap)
                } else {
                    result.success(null)
                }
            }

            "toSettings" -> {
                if (Build.VERSION.SDK_INT >= 31) {
                    val packageName = call.arguments<String>()
                        ?: requiredFlutterPluginBinding.applicationContext.packageName
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
                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

}