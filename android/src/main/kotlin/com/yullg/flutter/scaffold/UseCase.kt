package com.yullg.flutter.scaffold

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

abstract class UseCase(
    protected val flutterPluginBinding: () -> FlutterPlugin.FlutterPluginBinding?,
    protected val activityPluginBinding: () -> ActivityPluginBinding?,
) {
    protected val requiredFlutterPluginBinding: FlutterPlugin.FlutterPluginBinding
        get() = flutterPluginBinding()!!

    protected val requiredActivityPluginBinding: ActivityPluginBinding
        get() = activityPluginBinding()!!

}

data class UseCaseContext(
    val call: MethodCall,
    val result: MethodChannel.Result,
) {

    private var _data: Any? = null
    private val _extras = mutableMapOf<String, Any?>()

    fun <T> getData(): T = _data as T

    fun <T> setData(data: T) {
        _data = data
    }

    fun <T> getExtra(name: String): T = _extras[name] as T

    fun <T> putExtra(name: String, value: T) {
        _extras[name] = value
    }

    fun removeExtra(name: String) {
        _extras.remove(name)
    }

}