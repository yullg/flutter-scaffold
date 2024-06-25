package com.yullg.flutter.scaffold

import androidx.annotation.CallSuper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

abstract class BaseUseCase(
    private val eventChannelName: String? = null,
    private val methodChannelName: String? = null,
) : FlutterPlugin, ActivityAware, EventChannel.StreamHandler, MethodChannel.MethodCallHandler {

    protected var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null
        private set
    protected var activityPluginBinding: ActivityPluginBinding? = null
        private set

    protected val requiredFlutterPluginBinding: FlutterPlugin.FlutterPluginBinding
        get() = flutterPluginBinding!!
    protected val requiredActivityPluginBinding: ActivityPluginBinding
        get() = activityPluginBinding!!

    private var eventChannel: EventChannel? = null
    private var methodChannel: MethodChannel? = null

    @CallSuper
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding = binding
        eventChannelName?.let {
            eventChannel = EventChannel(binding.binaryMessenger, it).apply {
                setStreamHandler(this@BaseUseCase)
            }
        }
        methodChannelName?.let {
            methodChannel = MethodChannel(binding.binaryMessenger, it).apply {
                setMethodCallHandler(this@BaseUseCase)
            }
        }
    }

    @CallSuper
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
    }

    @CallSuper
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    }

    override fun onCancel(arguments: Any?) {
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        result.notImplemented()
    }

    @CallSuper
    override fun onDetachedFromActivityForConfigChanges() {
        activityPluginBinding = null
    }

    @CallSuper
    override fun onDetachedFromActivity() {
        activityPluginBinding = null
    }

    @CallSuper
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        flutterPluginBinding = null
    }

}