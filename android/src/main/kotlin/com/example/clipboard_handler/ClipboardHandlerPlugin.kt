package com.example.clipboard_handler

import android.app.Activity
import android.app.Application
import android.content.ClipboardManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.core.net.toUri
import androidx.core.view.doOnLayout

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ClipboardHandlerPlugin */
class ClipboardHandlerPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler,ClipboardManager.OnPrimaryClipChangedListener,
  Application.ActivityLifecycleCallbacks {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Application
  private var messageChannel: EventChannel? = null
  private var eventSink: EventChannel.EventSink? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    context = flutterPluginBinding.applicationContext as Application
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "clipboard_handler")
    channel.setMethodCallHandler(this)

    messageChannel = EventChannel(flutterPluginBinding.binaryMessenger, "clipboard_changes_events")
    messageChannel?.setStreamHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    result.notImplemented()
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    this.eventSink = events
    val clipboardManager = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    clipboardManager.addPrimaryClipChangedListener(this)
    context.registerActivityLifecycleCallbacks(this)

  }

  override fun onCancel(arguments: Any?) {
    eventSink?.endOfStream()
    eventSink = null
    messageChannel = null
  }

  override fun onPrimaryClipChanged() {
    eventSink?.success(null);
  }


  override fun onActivityStarted(activity: Activity) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      activity.findViewById<View>(android.R.id.content)?.doOnLayout {
        onPrimaryClipChanged()
      }
    } else {
      onPrimaryClipChanged()
    }
  }

  override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) { }

  override fun onActivityResumed(activity: Activity) { }

  override fun onActivityPaused(activity: Activity) { }

  override fun onActivityStopped(activity: Activity) { }

  override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) { }

  override fun onActivityDestroyed(activity: Activity) { }
}
