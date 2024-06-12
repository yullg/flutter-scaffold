package com.yullg.flutter.scaffold

import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageInstaller
import android.net.Uri
import android.util.Log
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
            var session: PackageInstaller.Session? = null
            try {
                val packageInstaller =
                    requiredFlutterPluginBinding.applicationContext.packageManager.packageInstaller
                val sessionParams =
                    PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL)
                val sessionId = packageInstaller.createSession(sessionParams)
                session = packageInstaller.openSession(sessionId)
                session.openWrite("app", 0, -1).use { output ->
                    requiredFlutterPluginBinding.applicationContext.contentResolver.openInputStream(
                        Uri.parse(useCaseContext.call.argument("uri"))
                    )?.use { input ->
                        input.copyTo(output).let {
                            Log.i("PackageInstallUseCase", "apk size: $it")
                        }
                    }
                }
                val pendingIntent = PendingIntent.getBroadcast(
                    requiredFlutterPluginBinding.applicationContext,
                    sessionId,
                    Intent("${requiredFlutterPluginBinding.applicationContext.packageName}.SESSION_API_PACKAGE_INSTALLED"),
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                session.commit(pendingIntent.intentSender)
                useCaseContext.result.success(null)
            } catch (e: Throwable) {
                try {
                    session?.abandon()
                } catch (e: Throwable) {
                    Log.e("PackageInstallUseCase", "failed to abandon session", e)
                } finally {
                    useCaseContext.result.error(ERROR_CODE, e.message, null)
                }
            }
        }
    }

}

private const val ERROR_CODE = "PackageInstallUseCaseError"