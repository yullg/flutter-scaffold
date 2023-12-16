package com.yullg.flutter.scaffold

import android.app.Activity
import android.content.Intent
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.plugin.common.MethodChannel

object StorageAccessFrameworkUseCase {

    private const val REQUEST_CODE_OPEN_DOCUMENT = 28256

    private val resultMap = mutableMapOf<Int, MethodChannel.Result>()

    fun openDocument(activity: Activity, result: MethodChannel.Result, input: List<String>) {
        activity.startActivityForResult(
            ActivityResultContracts.OpenDocument().createIntent(activity, input.toTypedArray()),
            REQUEST_CODE_OPEN_DOCUMENT
        )
        resultMap[REQUEST_CODE_OPEN_DOCUMENT] = result
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (REQUEST_CODE_OPEN_DOCUMENT == requestCode) {
            resultMap.remove(REQUEST_CODE_OPEN_DOCUMENT)?.apply {
                val uri = ActivityResultContracts.OpenDocument().parseResult(resultCode, data)
                success(uri?.toString())
            }
        }
        return false
    }

}