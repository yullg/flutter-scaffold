package com.yullg.flutter.scaffold

import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageInstaller
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class PackageInstallUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/package_install"
) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "install" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val contentUri = Uri.parse(call.argument<String>("contentUri")!!)
                GlobalScope.launch(Dispatchers.IO) {
                    var session: PackageInstaller.Session? = null
                    try {
                        val packageInstaller = applicationContext.packageManager.packageInstaller
                        val sessionParams =
                            PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL)
                        val sessionId = packageInstaller.createSession(sessionParams)
                        session = packageInstaller.openSession(sessionId)
                        session.openWrite("package", 0, -1).use { output ->
                            applicationContext.contentResolver.openInputStream(contentUri)
                                ?.use { input ->
                                    input.copyTo(output).let {
                                        Log.i("PackageInstallUseCase", "apk size: $it")
                                    }
                                }
                        }
                        val pendingIntent = PendingIntent.getBroadcast(
                            applicationContext,
                            sessionId,
                            Intent("${applicationContext.packageName}.SESSION_API_PACKAGE_INSTALLED"),
                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                        )
                        session.commit(pendingIntent.intentSender)
                        result.success(null)
                    } catch (e: Throwable) {
                        try {
                            session?.abandon()
                        } catch (e: Throwable) {
                            Log.e("PackageInstallUseCase", "failed to abandon session", e)
                        } finally {
                            result.error(ERROR_CODE, e.message, null)
                        }
                    }
                }
            }

            "classicalInstall" -> {
                val activity = requiredActivityPluginBinding.activity
                val contentUri = Uri.parse(call.argument<String>("contentUri")!!)
                val intent = Intent(Intent.ACTION_INSTALL_PACKAGE).apply {
                    data = contentUri
                    flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
                }
                activity.startActivity(intent)
                result.success(null)
            }

            "canRequestPackageInstalls" -> {
                val canRequest = if (Build.VERSION.SDK_INT >= 26) {
                    requiredFlutterPluginBinding.applicationContext.packageManager.canRequestPackageInstalls()
                } else true
                result.success(canRequest)
            }

            "requestPackageInstallsPermission" -> {
                if (Build.VERSION.SDK_INT >= 26) {
                    val activity = requiredActivityPluginBinding.activity
                    val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES).apply {
                        data = Uri.parse("package:${activity.packageName}")
                    }
                    activity.startActivity(intent)
                }
                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

}

private const val ERROR_CODE = "PackageInstallUseCaseError"