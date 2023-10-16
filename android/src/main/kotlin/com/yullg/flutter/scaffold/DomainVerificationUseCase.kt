package com.yullg.flutter.scaffold

import android.content.Context
import android.content.Intent
import android.content.pm.verify.domain.DomainVerificationManager
import android.net.Uri
import android.os.Build
import android.provider.Settings

object DomainVerificationUseCase {

    fun isLinkHandlingAllowed(context: Context, packageName: String): Boolean? {
        if (Build.VERSION.SDK_INT >= 31) {
            val manager = context.getSystemService(DomainVerificationManager::class.java)
            val userState = manager.getDomainVerificationUserState(packageName)
            return userState?.isLinkHandlingAllowed
        }
        return null
    }

    fun isMyLinkHandlingAllowed(context: Context): Boolean? {
        return isLinkHandlingAllowed(context, context.packageName)
    }

    fun getHostToStateMap(context: Context, packageName: String): Map<String, Int>? {
        if (Build.VERSION.SDK_INT >= 31) {
            val manager = context.getSystemService(DomainVerificationManager::class.java)
            val userState = manager.getDomainVerificationUserState(packageName)
            return userState?.hostToStateMap
        }
        return null
    }

    fun getMyHostToStateMap(context: Context): Map<String, Int>? {
        return getHostToStateMap(context, context.packageName)
    }

    fun toSettings(context: Context, packageName: String): Boolean? {
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
            context.startActivity(intent)
            return true
        }
        return null
    }

    fun toMySettings(context: Context): Boolean? {
        if (Build.VERSION.SDK_INT >= 31) {
            val intent = Intent(
                if (Build.MANUFACTURER.equals("samsung", ignoreCase = true)) {
                    // 三星设备不兼容，改为跳转应用设置
                    // https://stackoverflow.com/questions/70953672/android-12-deep-link-association-by-user-fails-because-of-crash-in-samsung-setti
                    Settings.ACTION_APPLICATION_DETAILS_SETTINGS
                } else {
                    Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS
                },
                Uri.parse("package:${context.packageName}"),
            ).apply {
                addCategory(Intent.CATEGORY_DEFAULT)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
                addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS)
            }
            context.startActivity(intent)
            return true
        }
        return null
    }

}