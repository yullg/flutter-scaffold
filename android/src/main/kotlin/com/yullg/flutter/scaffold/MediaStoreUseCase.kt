package com.yullg.flutter.scaffold

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
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
                val mimeType = call.argument<String>("mimeType")
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        if (Build.VERSION.SDK_INT >= 29) {
                            val tableContentUri =
                                MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
                            val contentValues = ContentValues().apply {
                                put(MediaStore.Audio.Media.IS_PENDING, 1)
                                put(MediaStore.Audio.Media.DISPLAY_NAME, displayName ?: file.name)
                                if (mimeType != null) {
                                    put(MediaStore.Audio.Media.MIME_TYPE, mimeType)
                                }
                            }
                            val contentResolver = applicationContext.contentResolver
                            val rowContentUri =
                                contentResolver.insert(tableContentUri, contentValues)!!
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
                        } else {
                            val targetFile = copyToPublicDirectory(
                                file,
                                Environment.DIRECTORY_MUSIC,
                                displayName
                            )
                            val targetFileUri = Uri.fromFile(targetFile)
                            sendMediaScanBroadcast(applicationContext, targetFileUri)
                            result.success(targetFileUri.toString())
                        }
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }

            "insertImageFile" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val file = File(call.argument<String>("file")!!)
                val displayName = call.argument<String>("displayName")
                val mimeType = call.argument<String>("mimeType")
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        if (Build.VERSION.SDK_INT >= 29) {
                            val tableContentUri =
                                MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
                            val contentValues = ContentValues().apply {
                                put(MediaStore.Images.Media.IS_PENDING, 1)
                                put(MediaStore.Images.Media.DISPLAY_NAME, displayName ?: file.name)
                                if (mimeType != null) {
                                    put(MediaStore.Images.Media.MIME_TYPE, mimeType)
                                }
                            }
                            val contentResolver = applicationContext.contentResolver
                            val rowContentUri =
                                contentResolver.insert(tableContentUri, contentValues)!!
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
                        } else {
                            val targetFile = copyToPublicDirectory(
                                file,
                                Environment.DIRECTORY_PICTURES,
                                displayName
                            )
                            val targetFileUri = Uri.fromFile(targetFile)
                            sendMediaScanBroadcast(applicationContext, targetFileUri)
                            result.success(targetFileUri.toString())
                        }
                    } catch (e: Throwable) {
                        Log.e(TAG, "InsertImage", e)
                        result.error(ERROR_CODE, e.message, null)
                    }
                }

            }

            "insertVideoFile" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val file = File(call.argument<String>("file")!!)
                val displayName = call.argument<String>("displayName")
                val mimeType = call.argument<String>("mimeType")
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        if (Build.VERSION.SDK_INT >= 29) {
                            val tableContentUri =
                                MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
                            val contentValues = ContentValues().apply {
                                put(MediaStore.Video.Media.IS_PENDING, 1)
                                put(MediaStore.Video.Media.DISPLAY_NAME, displayName ?: file.name)
                                if (mimeType != null) {
                                    put(MediaStore.Video.Media.MIME_TYPE, mimeType)
                                }
                            }
                            val contentResolver = applicationContext.contentResolver
                            val rowContentUri =
                                contentResolver.insert(tableContentUri, contentValues)!!
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
                        } else {
                            val targetFile = copyToPublicDirectory(
                                file,
                                Environment.DIRECTORY_MOVIES,
                                displayName
                            )
                            val targetFileUri = Uri.fromFile(targetFile)
                            sendMediaScanBroadcast(applicationContext, targetFileUri)
                            result.success(targetFileUri.toString())
                        }
                    } catch (e: Throwable) {
                        Log.e(TAG, "InsertVideo", e)
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }

            "insertDownloadFile" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val file = File(call.argument<String>("file")!!)
                val displayName = call.argument<String>("displayName")
                val mimeType = call.argument<String>("mimeType")
                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        if (Build.VERSION.SDK_INT >= 29) {
                            val tableContentUri =
                                MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
                            val contentValues = ContentValues().apply {
                                put(MediaStore.MediaColumns.IS_PENDING, 1)
                                put(MediaStore.MediaColumns.DISPLAY_NAME, displayName ?: file.name)
                                if (mimeType != null) {
                                    put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                                }
                            }
                            val contentResolver = applicationContext.contentResolver
                            val rowContentUri =
                                contentResolver.insert(tableContentUri, contentValues)!!
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
//                            sendMediaScanBroadcast(applicationContext, targetFileUri)
                            result.success(targetFileUri.toString())
                        }
                    } catch (e: Throwable) {
                        Log.e(TAG, "InsertDownload", e)
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

    private fun sendMediaScanBroadcast(context: Context, fileUri: Uri) {
        val intent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE).apply {
            data = fileUri
        }
        context.sendBroadcast(intent)
    }

}

private const val TAG = "MediaStoreUseCase"
private const val ERROR_CODE = "MediaStoreUseCaseError"