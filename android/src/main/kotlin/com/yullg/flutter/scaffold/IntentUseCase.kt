package com.yullg.flutter.scaffold

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.MediaStore
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class IntentUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/intent"
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

    // actionPick
    private var actionPickResult: MethodChannel.Result? = null

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
                    RequestCode.INTENT_CREATE_DOCUMENT.code,
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
                    RequestCode.INTENT_OPEN_DOCUMENT.code,
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
                    RequestCode.INTENT_OPEN_DOCUMENT_TREE.code,
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
                    RequestCode.INTENT_OPEN_MULTIPLE_DOCUMENTS.code,
                )
                openMultipleDocumentsContract = contract
                openMultipleDocumentsResult = result
            }

            "actionPick" -> {
                val activity = requiredActivityPluginBinding.activity
                val type = call.argument<String>("type")
                val intent = when (type) {
                    "audio" -> Intent(
                        Intent.ACTION_PICK,
                        MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
                    )

                    "image" -> Intent(
                        Intent.ACTION_PICK,
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                    )

                    "video" -> Intent(
                        Intent.ACTION_PICK,
                        MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                    )

                    else -> Intent(Intent.ACTION_PICK)
                }
                activity.startActivityForResult(intent, RequestCode.INTENT_ACTION_PICK.code)
                actionPickResult = result
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
        if (RequestCode.INTENT_CREATE_DOCUMENT.code == requestCode) {
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
        } else if (RequestCode.INTENT_OPEN_DOCUMENT.code == requestCode) {
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
        } else if (RequestCode.INTENT_OPEN_DOCUMENT_TREE.code == requestCode) {
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
        } else if (RequestCode.INTENT_OPEN_MULTIPLE_DOCUMENTS.code == requestCode) {
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
        } else if (RequestCode.INTENT_ACTION_PICK.code == requestCode) {
            actionPickResult?.also {
                if (Activity.RESULT_OK == resultCode) {
                    it.success(data?.data?.toString())
                } else {
                    it.success(null)
                }
            }
            actionPickResult = null;
            return true;
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

private const val ERROR_CODE = "IntentUseCaseError"