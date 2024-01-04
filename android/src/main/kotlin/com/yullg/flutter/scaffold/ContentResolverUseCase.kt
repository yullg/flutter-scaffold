package com.yullg.flutter.scaffold

import android.net.Uri
import android.webkit.MimeTypeMap
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.File

private const val ERROR_CODE = "ContentResolverUseCaseError"

class ContentResolverUseCase(
    flutterPluginBinding: () -> FlutterPlugin.FlutterPluginBinding?,
    activityPluginBinding: () -> ActivityPluginBinding?,
) : UseCase(flutterPluginBinding, activityPluginBinding) {

    fun writeFromFile(useCaseContext: UseCaseContext) {
        val atFile = File(useCaseContext.call.argument<String>("atFilePath")!!)
        val toContentUri = Uri.parse(useCaseContext.call.argument<String>("toContentUri"))
        GlobalScope.launch(Dispatchers.IO) {
            try {
                requiredFlutterPluginBinding.applicationContext.contentResolver.openOutputStream(
                    toContentUri
                )?.use { outputStream ->
                    atFile.inputStream().use { inputStream ->
                        inputStream.copyTo(outputStream)
                    }
                }
                useCaseContext.result.success(null)
            } catch (e: Throwable) {
                useCaseContext.result.error(ERROR_CODE, e.message, null)
            }
        }
    }

    fun readToFile(useCaseContext: UseCaseContext) {
        val atContentUri = Uri.parse(useCaseContext.call.argument<String>("atContentUri"))
        val toFile = File(useCaseContext.call.argument<String>("toFilePath")!!)
        GlobalScope.launch(Dispatchers.IO) {
            try {
                requiredFlutterPluginBinding.applicationContext.contentResolver.openInputStream(
                    atContentUri
                )?.use { inputStream ->
                    toFile.outputStream().use { outputStream ->
                        inputStream.copyTo(outputStream)
                    }
                }
                useCaseContext.result.success(null)
            } catch (e: Throwable) {
                useCaseContext.result.error(ERROR_CODE, e.message, null)
            }
        }
    }

    fun getExtensionFromContentUri(useCaseContext: UseCaseContext) {
        val contentUri = Uri.parse(useCaseContext.call.arguments<String>())
        val mimeType =
            requiredFlutterPluginBinding.applicationContext.contentResolver.getType(contentUri)
        if (mimeType == null) {
            useCaseContext.result.success(null)
            return
        }
        useCaseContext.result.success(MimeTypeMap.getSingleton().getExtensionFromMimeType(mimeType))
    }

}