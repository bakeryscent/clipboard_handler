import Flutter
import UIKit

public class ClipboardHandlerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {


  private var eventSink: FlutterEventSink?

  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clipboard_handler", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "clipboard_changes_events", binaryMessenger: registrar.messenger())

    let instance = ClipboardHandlerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(instance)

  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "hasURLs":
        result(UIPasteboard.general.hasURLs)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events

    let notificationCenter = NotificationCenter.default
    // Check for changes in the pasteboard (works only on app's context)
    notificationCenter.addObserver(
        self,
        selector: #selector(onClipboardChange),
        name: UIPasteboard.changedNotification,
        object: nil)
    // Check the paste board after a foreground event as the paste board
    // content may have changed while the app was in the background.
    notificationCenter.addObserver(
        self,
        selector: #selector(onClipboardChange),
        name: UIApplication.willEnterForegroundNotification,
        object: nil)

    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    let notificationCenter = NotificationCenter.default
    notificationCenter.removeObserver(
        self,
        name: UIPasteboard.changedNotification,
        object: nil
    )
    notificationCenter.removeObserver(
        self,
        name: UIApplication.willEnterForegroundNotification,
        object: nil
    )
    return nil
  }
  
  @objc func onClipboardChange() {
    eventSink?(nil)
  }
  

}
