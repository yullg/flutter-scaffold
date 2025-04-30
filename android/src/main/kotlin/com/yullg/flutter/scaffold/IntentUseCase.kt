package com.yullg.flutter.scaffold

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.MediaStore
import androidx.activity.result.contract.ActivityResultContracts
import com.yullg.flutter.scaffold.core.BaseUseCase
import com.yullg.flutter.scaffold.core.RequestCode
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

object IntentUseCase : BaseUseCase(
    methodChannelName = "com.yullg.flutter.scaffold/intent"
), PluginRegistry.ActivityResultListener {

    // actionPick
    private var actionPickResult: MethodChannel.Result? = null

    // takePicture
    private var takePictureContract: ActivityResultContracts.TakePicture? = null
    private var takePictureResult: MethodChannel.Result? = null

    // captureVideo
    private var captureVideoContract: ActivityResultContracts.CaptureVideo? = null
    private var captureVideoResult: MethodChannel.Result? = null

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


    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        super.onAttachedToActivity(binding)
        binding.addActivityResultListener(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        super.onReattachedToActivityForConfigChanges(binding)
        binding.addActivityResultListener(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "actionPick" -> {
                val activity = requiredActivityPluginBinding.activity
                val type = call.argument<Int>("type")!!
                val forcingChooser = call.argument<Boolean>("forcingChooser")!!
                val chooserTitle = call.argument<String>("chooserTitle")
                val intent = when (type) {
                    1 -> Intent(
                        Intent.ACTION_PICK,
                        MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
                    )

                    2 -> Intent(
                        Intent.ACTION_PICK,
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                    )

                    3 -> Intent(
                        Intent.ACTION_PICK,
                        MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                    )

                    else -> throw IllegalArgumentException()
                }
                if (intent.resolveActivity(activity.packageManager) != null) {
                    if (forcingChooser) {
                        activity.startActivityForResult(
                            Intent.createChooser(intent, chooserTitle),
                            RequestCode.INTENT_ACTION_PICK.code
                        )
                    } else {
                        activity.startActivityForResult(intent, RequestCode.INTENT_ACTION_PICK.code)
                    }
                    actionPickResult = result
                } else {
                    result.success(null)
                }
            }

            "takePicture" -> {
                val activity = requiredActivityPluginBinding.activity
                val outputContentUri = Uri.parse(call.argument<String>("outputContentUri")!!)
                val forcingChooser = call.argument<Boolean>("forcingChooser")!!
                val chooserTitle = call.argument<String>("chooserTitle")
                val contract = ActivityResultContracts.TakePicture()
                val intent = contract.createIntent(activity, outputContentUri)
                if (intent.resolveActivity(activity.packageManager) != null) {
                    if (forcingChooser) {
                        activity.startActivityForResult(
                            Intent.createChooser(intent, chooserTitle),
                            RequestCode.INTENT_TAKE_PICTURE.code
                        )
                    } else {
                        activity.startActivityForResult(
                            intent,
                            RequestCode.INTENT_TAKE_PICTURE.code
                        )
                    }
                    takePictureContract = contract
                    takePictureResult = result
                } else {
                    result.success(false)
                }
            }

            "captureVideo" -> {
                val activity = requiredActivityPluginBinding.activity
                val outputContentUri = Uri.parse(call.argument<String>("outputContentUri")!!)
                val forcingChooser = call.argument<Boolean>("forcingChooser")!!
                val chooserTitle = call.argument<String>("chooserTitle")
                val contract = ActivityResultContracts.CaptureVideo()
                val intent = contract.createIntent(activity, outputContentUri)
                if (intent.resolveActivity(activity.packageManager) != null) {
                    if (forcingChooser) {
                        activity.startActivityForResult(
                            Intent.createChooser(intent, chooserTitle),
                            RequestCode.INTENT_CAPTURE_VIDEO.code
                        )
                    } else {
                        activity.startActivityForResult(
                            intent,
                            RequestCode.INTENT_CAPTURE_VIDEO.code
                        )
                    }
                    captureVideoContract = contract
                    captureVideoResult = result
                } else {
                    result.success(false)
                }
            }

            "createDocument" -> {
                val activity = requiredActivityPluginBinding.activity
                val mimeType = call.argument<String>("mimeType")!!
                val name = call.argument<String>("name")!!
                val contract = ActivityResultContracts.CreateDocument(mimeType)
                val intent = contract.createIntent(activity, name)
                activity.startActivityForResult(
                    intent,
                    RequestCode.INTENT_CREATE_DOCUMENT.code,
                )
                createDocumentContract = contract
                createDocumentResult = result
            }

            "openDocument" -> {
                val activity = requiredActivityPluginBinding.activity
                val mimeTypes = call.argument<List<String>>("mimeTypes")!!.toTypedArray()
                val contract = ActivityResultContracts.OpenDocument()
                val intent = contract.createIntent(activity, mimeTypes)
                activity.startActivityForResult(
                    intent,
                    RequestCode.INTENT_OPEN_DOCUMENT.code,
                )
                openDocumentContract = contract
                openDocumentResult = result
            }

            "openDocumentTree" -> {
                val activity = requiredActivityPluginBinding.activity
                val initialLocation = call.argument<String>("initialLocation")?.let {
                    Uri.parse(it)
                }
                val contract = ActivityResultContracts.OpenDocumentTree()
                val intent = contract.createIntent(activity, initialLocation)
                activity.startActivityForResult(
                    intent,
                    RequestCode.INTENT_OPEN_DOCUMENT_TREE.code,
                )
                openDocumentTreeContract = contract
                openDocumentTreeResult = result
            }

            "openMultipleDocuments" -> {
                val activity = requiredActivityPluginBinding.activity
                val mimeTypes = call.argument<List<String>>("mimeTypes")!!.toTypedArray()
                val contract = ActivityResultContracts.OpenMultipleDocuments()
                val intent = contract.createIntent(activity, mimeTypes)
                activity.startActivityForResult(
                    intent,
                    RequestCode.INTENT_OPEN_MULTIPLE_DOCUMENTS.code,
                )
                openMultipleDocumentsContract = contract
                openMultipleDocumentsResult = result
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (RequestCode.INTENT_ACTION_PICK.code == requestCode) {
            actionPickResult?.also {
                if (Activity.RESULT_OK == resultCode) {
                    it.success(data?.data?.toString())
                } else {
                    it.success(null)
                }
            }
            actionPickResult = null;
            return true
        } else if (RequestCode.INTENT_TAKE_PICTURE.code == requestCode) {
            takePictureContract?.let { contract ->
                takePictureResult?.let { result ->
                    try {
                        result.success(contract.parseResult(resultCode, data))
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }
            takePictureContract = null
            takePictureResult = null
            return true
        } else if (RequestCode.INTENT_CAPTURE_VIDEO.code == requestCode) {
            captureVideoContract?.let { contract ->
                captureVideoResult?.let { result ->
                    try {
                        result.success(contract.parseResult(resultCode, data))
                    } catch (e: Throwable) {
                        result.error(ERROR_CODE, e.message, null)
                    }
                }
            }
            captureVideoContract = null
            captureVideoResult = null
            return true
        } else if (RequestCode.INTENT_CREATE_DOCUMENT.code == requestCode) {
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