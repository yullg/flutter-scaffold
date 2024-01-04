package com.yullg.flutter.scaffold

import android.content.Intent
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

private const val REQUEST_CODE_CREATE_DOCUMENT = 7001001
private const val REQUEST_CODE_OPEN_DOCUMENT = 7001002
private const val REQUEST_CODE_OPEN_MULTIPLE_DOCUMENTS = 7001003

private const val ERROR_CODE = "ActivityResultContractsUseCaseError"

class ActivityResultContractsUseCase(
    flutterPluginBinding: () -> FlutterPlugin.FlutterPluginBinding?,
    activityPluginBinding: () -> ActivityPluginBinding?,
) : UseCase(flutterPluginBinding, activityPluginBinding) {

    private val useCaseContexts = mutableMapOf<Int, UseCaseContext>()

    fun matches(requestCode: Int): Boolean =
        REQUEST_CODE_CREATE_DOCUMENT == requestCode
                || REQUEST_CODE_OPEN_DOCUMENT == requestCode
                || REQUEST_CODE_OPEN_MULTIPLE_DOCUMENTS == requestCode

    fun createDocument(useCaseContext: UseCaseContext) {
        val contract = ActivityResultContracts.CreateDocument(
            useCaseContext.call.argument<String>("mimeType")!!
        )
        val intent = contract.createIntent(
            requiredActivityPluginBinding.activity,
            useCaseContext.call.argument<String>("name")!!,
        )
        requiredActivityPluginBinding.activity.startActivityForResult(
            intent,
            REQUEST_CODE_CREATE_DOCUMENT,
        )
        useCaseContext.setData(contract)
        useCaseContexts[REQUEST_CODE_CREATE_DOCUMENT] = useCaseContext
    }

    fun openDocument(useCaseContext: UseCaseContext) {
        val allowsMultipleSelection =
            useCaseContext.call.argument<Boolean>("allowsMultipleSelection")!!
        val mimeTypes = useCaseContext.call.argument<List<String>>("mimeTypes")!!.toTypedArray()
        if (allowsMultipleSelection) {
            val contract = ActivityResultContracts.OpenMultipleDocuments()
            val intent = contract.createIntent(requiredActivityPluginBinding.activity, mimeTypes)
            requiredActivityPluginBinding.activity.startActivityForResult(
                intent,
                REQUEST_CODE_OPEN_MULTIPLE_DOCUMENTS,
            )
            useCaseContext.setData(contract)
            useCaseContexts[REQUEST_CODE_OPEN_MULTIPLE_DOCUMENTS] = useCaseContext
        } else {
            val contract = ActivityResultContracts.OpenDocument()
            val intent = contract.createIntent(requiredActivityPluginBinding.activity, mimeTypes)
            requiredActivityPluginBinding.activity.startActivityForResult(
                intent,
                REQUEST_CODE_OPEN_DOCUMENT,
            )
            useCaseContext.setData(contract)
            useCaseContexts[REQUEST_CODE_OPEN_DOCUMENT] = useCaseContext
        }
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (REQUEST_CODE_CREATE_DOCUMENT == requestCode) {
            useCaseContexts.remove(REQUEST_CODE_CREATE_DOCUMENT)?.let { useCaseContext ->
                try {
                    val uri = useCaseContext.getData<ActivityResultContracts.CreateDocument>()
                        .parseResult(resultCode, data)
                    useCaseContext.result.success(uri?.toString())
                } catch (e: Throwable) {
                    useCaseContext.result.error(ERROR_CODE, e.message, null)
                }
            }
        } else if (REQUEST_CODE_OPEN_DOCUMENT == requestCode) {
            useCaseContexts.remove(REQUEST_CODE_OPEN_DOCUMENT)?.let { useCaseContext ->
                try {
                    val uri = useCaseContext.getData<ActivityResultContracts.OpenDocument>()
                        .parseResult(resultCode, data)
                    if (uri != null) {
                        useCaseContext.result.success(listOf(uri.toString()))
                    } else {
                        useCaseContext.result.success(emptyList<String>())
                    }
                } catch (e: Throwable) {
                    useCaseContext.result.error(ERROR_CODE, e.message, null)
                }
            }
        } else if (REQUEST_CODE_OPEN_MULTIPLE_DOCUMENTS == requestCode) {
            useCaseContexts.remove(REQUEST_CODE_OPEN_MULTIPLE_DOCUMENTS)?.let { useCaseContext ->
                try {
                    val uris =
                        useCaseContext.getData<ActivityResultContracts.OpenMultipleDocuments>()
                            .parseResult(resultCode, data)
                    useCaseContext.result.success(uris.map { it.toString() })
                } catch (e: Throwable) {
                    useCaseContext.result.error(ERROR_CODE, e.message, null)
                }
            }
        }
        return true
    }

}