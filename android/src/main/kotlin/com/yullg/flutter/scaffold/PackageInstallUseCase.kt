package com.yullg.flutter.scaffold

import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageInstaller
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class PackageInstallUseCase(
    flutterPluginBinding: () -> FlutterPlugin.FlutterPluginBinding?,
    activityPluginBinding: () -> ActivityPluginBinding?,
) : UseCase(flutterPluginBinding, activityPluginBinding) {

    fun install(useCaseContext: UseCaseContext) {
        GlobalScope.launch(Dispatchers.IO) {
            try {
                val packageInstaller =
                    requiredFlutterPluginBinding.applicationContext.packageManager.packageInstaller
                val sessionParams =
                    PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL)
                val sessionId = packageInstaller.createSession(sessionParams)
                packageInstaller.openSession(sessionId).use { session ->
                    session.openWrite("app", 0, -1).use { output ->
                        requiredFlutterPluginBinding.applicationContext.contentResolver.openInputStream(
                            Uri.parse(useCaseContext.call.argument("uri"))
                        )?.use { input ->
                            input.copyTo(output)
                        }
                    }
                    val pendingIntent = PendingIntent.getBroadcast(
                        requiredFlutterPluginBinding.applicationContext,
                        sessionId,
                        Intent("${requiredFlutterPluginBinding.applicationContext.packageName}.INSTALL_COMPLETE"),
                        PendingIntent.FLAG_UPDATE_CURRENT
                    )
                    session.commit(pendingIntent.intentSender)
                }
                useCaseContext.result.success(null)
            } catch (e: Throwable) {
                useCaseContext.result.error(ERROR_CODE, e.message, null)
            }
        }
    }

}

private const val ERROR_CODE = "PackageInstallUseCaseError"