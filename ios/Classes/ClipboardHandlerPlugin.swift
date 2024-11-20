import Flutter
import UIKit

public class ClipboardHandlerPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clipboard_handler", binaryMessenger: registrar.messenger())

    let instance = ClipboardHandlerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "hasURLs":
        result(UIPasteboard.general.hasURLs)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
  
  

}
