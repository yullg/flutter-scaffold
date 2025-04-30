package com.yullg.flutter.scaffold

import android.content.ContentValues
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.File

object MediaStoreUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/media_store"
) {

    @OptIn(DelicateCoroutinesApi::class)
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {

            "insertAudio" -> {
                val contentValues = ContentValues()
                val rowUri = requiredFlutterPluginBinding.applicationContext.contentResolver.insert(
                    MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    contentValues
                )
                result.success(rowUri?.toString())
            }

            "insertImage" -> {
                val contentValues = ContentValues()
                val rowUri = requiredFlutterPluginBinding.applicationContext.contentResolver.insert(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    contentValues
                )
                result.success(rowUri?.toString())
            }

            "insertVideo" -> {
                val contentValues = ContentValues()
                val rowUri = requiredFlutterPluginBinding.applicationContext.contentResolver.insert(
                    MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                    contentValues
                )
                result.success(rowUri?.toString())
            }

            "insertAudioFile" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val file = File(call.argument<String>("file")!!)
                val displayName = call.argument<String>("displayName")
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        val contentValues = ContentValues().apply {
                            put(MediaStore.Audio.Media.IS_PENDING, 1)
                            put(MediaStore.Audio.Media.DISPLAY_NAME, displayName ?: file.name)
                        }
                        val contentResolver = applicationContext.contentResolver
                        val rowContentUri = contentResolver.insert(
                            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                            contentValues
                        )!!
                        file.inputStream().use { inputStream ->
                            contentResolver.openOutputStream(rowContentUri)!!
                                .use { outputStream ->
                                    inputStream.copyTo(outputStream)
                                }
                        }
                        contentValues.clear()
                        contentValues.put(MediaStore.Audio.Media.IS_PENDING, 0)
                        contentResolver.update(rowContentUri, contentValues, null, null)
                        result.success(rowContentUri.toString())
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }

            "insertImageFile" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val file = File(call.argument<String>("file")!!)
                val displayName = call.argument<String>("displayName")
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        val contentValues = ContentValues().apply {
                            put(MediaStore.Images.Media.IS_PENDING, 1)
                            put(MediaStore.Images.Media.DISPLAY_NAME, displayName ?: file.name)
                        }
                        val contentResolver = applicationContext.contentResolver
                        val rowContentUri = contentResolver.insert(
                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                            contentValues
                        )!!
                        file.inputStream().use { inputStream ->
                            contentResolver.openOutputStream(rowContentUri)!!
                                .use { outputStream ->
                                    inputStream.copyTo(outputStream)
                                }
                        }
                        contentValues.clear()
                        contentValues.put(MediaStore.Images.Media.IS_PENDING, 0)
                        contentResolver.update(rowContentUri, contentValues, null, null)
                        result.success(rowContentUri.toString())
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }

            }

            "insertVideoFile" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val file = File(call.argument<String>("file")!!)
                val displayName = call.argument<String>("displayName")
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        val contentValues = ContentValues().apply {
                            put(MediaStore.Video.Media.IS_PENDING, 1)
                            put(MediaStore.Video.Media.DISPLAY_NAME, displayName ?: file.name)
                        }
                        val contentResolver = applicationContext.contentResolver
                        val rowContentUri = contentResolver.insert(
                            MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                            contentValues
                        )!!
                        file.inputStream().use { inputStream ->
                            contentResolver.openOutputStream(rowContentUri)!!
                                .use { outputStream ->
                                    inputStream.copyTo(outputStream)
                                }
                        }
                        contentValues.clear()
                        contentValues.put(MediaStore.Video.Media.IS_PENDING, 0)
                        contentResolver.update(rowContentUri, contentValues, null, null)
                        result.success(rowContentUri.toString())
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }

            "insertDownloadFile" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val file = File(call.argument<String>("file")!!)
                val displayName = call.argument<String>("displayName")
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        if (Build.VERSION.SDK_INT >= 29) {
                            val contentValues = ContentValues().apply {
                                put(MediaStore.MediaColumns.IS_PENDING, 1)
                                put(MediaStore.MediaColumns.DISPLAY_NAME, displayName ?: file.name)
                            }
                            val contentResolver = applicationContext.contentResolver
                            val rowContentUri = contentResolver.insert(
                                MediaStore.Downloads.EXTERNAL_CONTENT_URI,
                                contentValues
                            )!!
                            file.inputStream().use { inputStream ->
                                contentResolver.openOutputStream(rowContentUri)!!
                                    .use { outputStream ->
                                        inputStream.copyTo(outputStream)
                                    }
                            }
                            contentValues.clear()
                            contentValues.put(MediaStore.MediaColumns.IS_PENDING, 0)
                            contentResolver.update(rowContentUri, contentValues, null, null)
                            result.success(rowContentUri.toString())
                        } else {
                            val targetFile = copyToPublicDirectory(
                                file,
                                Environment.DIRECTORY_DOWNLOADS,
                                displayName
                            )
                            val targetFileUri = Uri.fromFile(targetFile)
                            result.success(targetFileUri.toString())
                        }
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

    private fun copyToPublicDirectory(file: File, type: String, displayName: String?): File {
        val directory = Environment.getExternalStoragePublicDirectory(type)
        val fileName = displayName ?: file.extension.let {
            if (it.isEmpty()) "${System.currentTimeMillis()}" else "${System.currentTimeMillis()}.$it"
        }
        val targetFile = File(directory, fileName)
        file.copyTo(targetFile)
        return targetFile
    }

}

private const val ERROR_CODE = "MediaStoreUseCaseError"