package com.yullg.flutter.scaffold

import android.net.Uri
import android.content.Intent
import androidx.core.content.FileProvider
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class FileProviderUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/file_provider"
) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getUriForFile" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val file = File(call.argument<String>("file")!!)
                val displayName = call.argument<String>("displayName")
                val contentUri = if (displayName != null) {
                    FileProvider.getUriForFile(
                        applicationContext,
                        "${applicationContext.packageName}.yullg.scaffoldfileprovider",
                        file,
                        displayName
                    )
                } else {
                    FileProvider.getUriForFile(
                        applicationContext,
                        "${applicationContext.packageName}.yullg.scaffoldfileprovider",
                        file
                    )
                }
                result.success(contentUri.toString())
            }

            "grantUriPermission" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val toPackage = call.argument<String>("toPackage")!!
                val contentUri = Uri.parse(call.argument<String>("contentUri")!!)
                val modeFlags = call.parseModeFlags()
                applicationContext.grantUriPermission(
                    toPackage,
                    contentUri,
                    modeFlags
                )
                result.success(null)
            }

            "revokeUriPermission" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val contentUri = Uri.parse(call.argument<String>("contentUri")!!)
                val modeFlags = call.parseModeFlags()
                applicationContext.revokeUriPermission(
                    contentUri,
                    modeFlags
                )
                result.success(null)
            }

            "filesPath" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                result.success(File(applicationContext.filesDir, "yullg/share").path)
            }

            "cachePath" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                result.success(File(applicationContext.cacheDir, "yullg/share").path)
            }

            "externalFilesPath" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                result.success(
                    File(applicationContext.getExternalFilesDir(null), "yullg/share").path
                )
            }

            "externalCachePath" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                result.success(
                    File(applicationContext.externalCacheDir, "yullg/share").path
                )
            }

            else -> {
                result.notImplemented()
            }
        }
    }

}

private const val ERROR_CODE = "FileProviderUseCaseError"

private fun MethodCall.parseModeFlags(): Int {
    val modeFlags = argument<List<String>>("modeFlags").orEmpty()
    return modeFlags.fold(0) { flags, modeFlag ->
        flags or when (modeFlag) {
            "read" -> Intent.FLAG_GRANT_READ_URI_PERMISSION
            "write" -> Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            "persistable" -> Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
            "prefix" -> Intent.FLAG_GRANT_PREFIX_URI_PERMISSION
            else -> throw IllegalArgumentException("unsupported mode flag: $modeFlag")
        }
    }
}
