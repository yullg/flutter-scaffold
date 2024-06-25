package com.yullg.flutter.scaffold

import android.content.Intent
import android.net.Uri
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

private const val REQUEST_CODE_CREATE_DOCUMENT = 7001001
private const val REQUEST_CODE_OPEN_DOCUMENT = 7001002
private const val REQUEST_CODE_OPEN_DOCUMENT_TREE = 7001003
private const val REQUEST_CODE_OPEN_MULTIPLE_DOCUMENTS = 7001004

class ActivityResultContractsUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/activity_result_contracts"
), PluginRegistry.ActivityResultListener {

    // createDocument
    private var createDocumentContract: ActivityResultContracts.CreateDocument? = null
    private var createDocumentResult: MethodChannel.Result? = null

    // openDocument
    private var openDocumentContract: ActivityResultContracts.OpenDocument? = null
    private var openDocumentResult: MethodChannel.Result? = null

    // openDocumentTree
    private var openDocumentTreeContract: ActivityResultContracts.OpenDocumentTree? = null
    private var openDocumentTreeResult: MethodChannel.Result? = null

    // openMultipleDocuments
    private var openMultipleDocumentsContract: ActivityResultContracts.OpenMultipleDocuments? = null
    private var openMultipleDocumentsResult: MethodChannel.Result? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "createDocument" -> {
                val contract = ActivityResultContracts.CreateDocument(
                    call.argument<String>("mimeType")!!
                )
                val intent = contract.createIntent(
                    requiredActivityPluginBinding.activity,
                    call.argument<String>("name")!!,
                )
                requiredActivityPluginBinding.activity.startActivityForResult(
                    intent,
                    REQUEST_CODE_CREATE_DOCUMENT,
                )
                createDocumentContract = contract
                createDocumentResult = result
            }

            "openDocument" -> {
                val mimeTypes = call.argument<List<String>>("mimeTypes")!!.toTypedArray()
                val contract = ActivityResultContracts.OpenDocument()
                val intent =
                    contract.createIntent(requiredActivityPluginBinding.activity, mimeTypes)
                requiredActivityPluginBinding.activity.startActivityForResult(
                    intent,
                    REQUEST_CODE_OPEN_DOCUMENT,
                )
                openDocumentContract = contract
                openDocumentResult = result
            }

            "openDocumentTree" -> {
                val initialLocation = call.argument<String>("initialLocation")?.let {
                    Uri.parse(it)
                }
                val contract = ActivityResultContracts.OpenDocumentTree()
                val intent =
                    contract.createIntent(requiredActivityPluginBinding.activity, initialLocation)
                requiredActivityPluginBinding.activity.startActivityForResult(
                    intent,
                    REQUEST_CODE_OPEN_DOCUMENT_TREE,
                )
                openDocumentTreeContract = contract
                openDocumentTreeResult = result
            }

            "openMultipleDocuments" -> {
                val mimeTypes = call.argument<List<String>>("mimeTypes")!!.toTypedArray()
                val contract = ActivityResultContracts.OpenMultipleDocuments()
                val intent =
                    contract.createIntent(requiredActivityPluginBinding.activity, mimeTypes)
                requiredActivityPluginBinding.activity.startActivityForResult(
                    intent,
                    REQUEST_CODE_OPEN_MULTIPLE_DOCUMENTS,
                )
                openMultipleDocumentsContract = contract
                openMultipleDocumentsResult = result
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        super.onAttachedToActivity(binding)
        binding.addActivityResultListener(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        super.onReattachedToActivityForConfigChanges(binding)
        binding.addActivityResultListener(this)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (REQUEST_CODE_CREATE_DOCUMENT == requestCode) {
            createDocumentContract?.let { contract ->
                createDocumentResult?.let { result ->
                    try {
                        val uri = contract.parseResult(resultCode, data)
                        result.success(uri?.toString())
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }
            createDocumentContract = null
            createDocumentResult = null
            return true
        } else if (REQUEST_CODE_OPEN_DOCUMENT == requestCode) {
            openDocumentContract?.let { contract ->
                openDocumentResult?.let { result ->
                    try {
                        val uri = contract.parseResult(resultCode, data)
                        result.success(uri?.toString())
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }
            openDocumentContract = null
            openDocumentResult = null
            return true
        } else if (REQUEST_CODE_OPEN_DOCUMENT_TREE == requestCode) {
            openDocumentTreeContract?.let { contract ->
                openDocumentTreeResult?.let { result ->
                    try {
                        val uri = contract.parseResult(resultCode, data)
                        result.success(uri?.toString())
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }
            openDocumentTreeContract = null
            openDocumentTreeResult = null
            return true
        } else if (REQUEST_CODE_OPEN_MULTIPLE_DOCUMENTS == requestCode) {
            openMultipleDocumentsContract?.let { contract ->
                openMultipleDocumentsResult?.let { result ->
                    try {
                        val uris = contract.parseResult(resultCode, data)
                        result.success(uris.map { it.toString() })
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }
            openMultipleDocumentsContract = null
            openMultipleDocumentsResult = null
            return true
        } else {
            return false
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityPluginBinding?.removeActivityResultListener(this)
        super.onDetachedFromActivityForConfigChanges()
    }

    override fun onDetachedFromActivity() {
        activityPluginBinding?.removeActivityResultListener(this)
        super.onDetachedFromActivity()
    }
}

private const val ERROR_CODE = "ActivityResultContractsUseCaseError"