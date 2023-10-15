package com.yullg.flutter.scaffold

import android.content.Context
import android.content.pm.verify.domain.DomainVerificationManager
import android.os.Build

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

}