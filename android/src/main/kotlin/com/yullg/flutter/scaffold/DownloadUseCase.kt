package com.yullg.flutter.scaffold

import android.app.DownloadManager
import android.app.DownloadManager.Request
import android.net.Uri
import android.os.Environment
import androidx.core.content.ContextCompat
import com.yullg.flutter.scaffold.core.BaseUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class DownloadUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/download"
) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "enqueue" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val uri = Uri.parse(call.argument<String>("uri")!!)
                val filename = call.argument<String>("filename").let {
                    if (it.isNullOrBlank()) {
                        val lastPathSegment = uri.lastPathSegment
                        if (lastPathSegment.isNullOrBlank()) {
                            return@let UUID.randomUUID().toString()
                        } else {
                            return@let lastPathSegment
                        }
                    } else {
                        return@let it
                    }
                }
                val request = Request(uri).apply {
                    call.argument<Map<String, String>>("requestHeader")?.onEach { (key, value) ->
                        addRequestHeader(key, value)
                    }
                    call.argument<String>("destination")?.also {
                        when (it) {
                            "externalFilesDir" -> setDestinationInExternalFilesDir(
                                applicationContext,
                                null,
                                filename
                            )

                            "externalPublicDir" -> setDestinationInExternalPublicDir(
                                Environment.DIRECTORY_DOWNLOADS,
                                filename
                            )
                        }
                    }
                    call.argument<Boolean>("allowedOverMetered")?.also {
                        setAllowedOverMetered(it)
                    }
                    call.argument<Boolean>("allowedOverRoaming")?.also {
                        setAllowedOverRoaming(it)
                    }
                    call.argument<Boolean>("requiresCharging")?.also {
                        setRequiresCharging(it)
                    }
                    call.argument<Boolean>("requiresDeviceIdle")?.also {
                        setRequiresDeviceIdle(it)
                    }
                    call.argument<String>("notificationVisibility")?.also {
                        when (it) {
                            "hidden" -> setNotificationVisibility(Request.VISIBILITY_HIDDEN)
                            "visible" -> setNotificationVisibility(Request.VISIBILITY_VISIBLE)
                            "visibleNotifyCompleted" -> setNotificationVisibility(Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
                        }
                    }
                    call.argument<String>("title")?.also {
                        setTitle(it)
                    }
                    call.argument<String>("description")?.also {
                        setDescription(it)
                    }
                }
                val downloadManager = ContextCompat.getSystemService(
                    applicationContext,
                    DownloadManager::class.java
                )!!
                val downloadId = downloadManager.enqueue(request)
                if (downloadId != -1L) {
                    result.success(downloadId)
                } else {
                    result.error(ERROR_CODE, null, null)
                }
            }

            "find" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val downloadId = call.arguments<Long>()!!
                val downloadManager = ContextCompat.getSystemService(
                    applicationContext,
                    DownloadManager::class.java
                )!!
                val query = DownloadManager.Query().apply {
                    setFilterById(downloadId)
                }
                val downloadInfo = downloadManager.query(query).use { cursor ->
                    if (cursor.moveToFirst()) {
                        val map = mutableMapOf<String, Any?>()
                        cursor.getColumnIndex(DownloadManager.COLUMN_STATUS).also {
                            map["status"] = when (cursor.getInt(it)) {
                                DownloadManager.STATUS_FAILED -> "failed"
                                DownloadManager.STATUS_PAUSED -> "paused"
                                DownloadManager.STATUS_PENDING -> "pending"
                                DownloadManager.STATUS_RUNNING -> "running"
                                DownloadManager.STATUS_SUCCESSFUL -> "successful"
                                else -> "unknown"
                            }
                        }
                        cursor.getColumnIndex(DownloadManager.COLUMN_LOCAL_URI)
                            .takeIf { it != -1 }?.also {
                                if (!cursor.isNull(it)) {
                                    map["localUri"] = cursor.getString(it)
                                }
                            }
                        cursor.getColumnIndex(DownloadManager.COLUMN_TOTAL_SIZE_BYTES)
                            .takeIf { it != -1 }?.also {
                                if (!cursor.isNull(it)) {
                                    val value = cursor.getLong(it)
                                    if (value >= 0) {
                                        map["totalSize"] = value
                                    }
                                }
                            }
                        cursor.getColumnIndex(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR)
                            .takeIf { it != -1 }?.also {
                                if (!cursor.isNull(it)) {
                                    val value = cursor.getLong(it)
                                    if (value >= 0) {
                                        map["bytesSoFar"] = value
                                    }
                                }
                            }
                        return@use map
                    }
                    return@use null
                }
                result.success(downloadInfo)
            }

            "remove" -> {
                val applicationContext = requiredFlutterPluginBinding.applicationContext
                val downloadId = call.arguments<Long>()!!
                val downloadManager = ContextCompat.getSystemService(
                    applicationContext,
                    DownloadManager::class.java
                )!!
                downloadManager.remove(downloadId)
                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

}

private const val ERROR_CODE = "DownloadUseCaseError"