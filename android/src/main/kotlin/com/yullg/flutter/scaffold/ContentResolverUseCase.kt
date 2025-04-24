package com.yullg.flutter.scaffold

import android.net.Uri
import android.provider.OpenableColumns
import android.webkit.MimeTypeMap
import androidx.documentfile.provider.DocumentFile
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.File

class ContentResolverUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/content_resolver"
) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getMetadata" -> {
                val contentUri = Uri.parse(call.arguments<String>()!!)
                GlobalScope.launch(Dispatchers.Default) {
                    try {
                        val contentResolver =
                            requiredFlutterPluginBinding.applicationContext.contentResolver
                        val mimeType = contentResolver.getType(contentUri)
                        var displayName: String? = null
                        var size: Long? = null
                        contentResolver.query(
                            contentUri,
                            arrayOf(OpenableColumns.DISPLAY_NAME, OpenableColumns.SIZE),
                            null,
                            null,
                            null
                        )?.use { cursor ->
                            if (cursor.moveToFirst()) {
                                displayName =
                                    cursor.getString(cursor.getColumnIndexOrThrow(OpenableColumns.DISPLAY_NAME))
                                size =
                                    cursor.getLong(cursor.getColumnIndexOrThrow(OpenableColumns.SIZE))
                            }
                        }
                        result.success(
                            mapOf(
                                "mimeType" to mimeType,
                                "displayName" to displayName,
                                "size" to size
                            )
                        )
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }

            "copyFileToContentUri" -> {
                val file = File(call.argument<String>("file")!!)
                val contentUri = Uri.parse(call.argument<String>("contentUri")!!)
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        requiredFlutterPluginBinding.applicationContext.contentResolver.openOutputStream(
                            contentUri
                        )?.use { outputStream ->
                            file.inputStream().use { inputStream ->
                                inputStream.copyTo(outputStream)
                            }
                        }
                        result.success(null)
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }

            "copyContentUriToFile" -> {
                val contentUri = Uri.parse(call.argument<String>("contentUri")!!)
                val file = File(call.argument<String>("file")!!)
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        requiredFlutterPluginBinding.applicationContext.contentResolver.openInputStream(
                            contentUri
                        )?.use { inputStream ->
                            file.parentFile?.mkdirs()
                            file.outputStream().use { outputStream ->
                                inputStream.copyTo(outputStream)
                            }
                        }
                        result.success(null)
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }

            "createSubTreeUri" -> {
                val treeUri = Uri.parse(call.argument<String>("treeUri")!!)
                val displayName = call.argument<String>("displayName")!!
                val documentFile = DocumentFile.fromTreeUri(
                    requiredFlutterPluginBinding.applicationContext,
                    treeUri
                )!!
                val subDocumentFile = documentFile.createDirectory(displayName)!!
                result.success(subDocumentFile.uri.toString())
            }

            "copyFileToTreeUri" -> {
                val file = File(call.argument<String>("file")!!)
                val treeUri = Uri.parse(call.argument<String>("treeUri")!!)
                val mimeType = call.argument<String>("mimeType")
                val displayName = call.argument<String>("displayName")
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        val documentFile = DocumentFile.fromTreeUri(
                            requiredFlutterPluginBinding.applicationContext,
                            treeUri
                        )!!
                        val subDocumentFile = documentFile.createFile(
                            mimeType ?: getMimeTypeFromExtension(file.extension),
                            displayName ?: file.nameWithoutExtension
                        )!!
                        requiredFlutterPluginBinding.applicationContext.contentResolver.openOutputStream(
                            subDocumentFile.uri
                        )?.use { outputStream ->
                            file.inputStream().use { inputStream ->
                                inputStream.copyTo(outputStream)
                            }
                        }
                        result.success(subDocumentFile.uri.toString())
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }

            "copyDirectoryToTreeUri" -> {
                val directory = File(call.argument<String>("directory")!!)
                val treeUri = Uri.parse(call.argument<String>("treeUri")!!)
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        val documentFile = DocumentFile.fromTreeUri(
                            requiredFlutterPluginBinding.applicationContext,
                            treeUri
                        )!!
                        doCopyDirectoryToTreeUri(directory, documentFile)
                        result.success(null)
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun doCopyDirectoryToTreeUri(directory: File, documentFile: DocumentFile) {
        val files = directory.listFiles() ?: return
        for (file in files) {
            if (file.isDirectory) {
                val subDocumentFile = documentFile.createDirectory(file.name)!!
                doCopyDirectoryToTreeUri(file, subDocumentFile)
            } else if (file.isFile) {
                val subDocumentFile = documentFile.createFile(
                    getMimeTypeFromExtension(file.extension),
                    file.nameWithoutExtension
                )!!
                requiredFlutterPluginBinding.applicationContext.contentResolver.openOutputStream(
                    subDocumentFile.uri
                )?.use { outputStream ->
                    file.inputStream().use { inputStream ->
                        inputStream.copyTo(outputStream)
                    }
                }
            }
        }
    }

    private fun getMimeTypeFromExtension(extension: String): String {
        return MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)
            ?: "application/octet-stream"
    }

}

private const val ERROR_CODE = "ContentResolverUseCaseError"