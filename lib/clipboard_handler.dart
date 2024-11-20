import 'package:flutter/services.dart';

import 'clipboard_handler_platform_interface.dart';

class ClipboardHandler {
  static final ClipboardHandler _singleton = ClipboardHandler._internal();

  static ClipboardHandler get instance => _singleton;

  ClipboardHandler._internal();

  static const EventChannel _eventChannel = EventChannel('test');

  static Stream<ClipboardHandler> get events {
    return _eventChannel.receiveBroadcastStream().map((e) => instance);
  }

  Future<bool?> hasURLs() {
    return ClipboardHandlerPlatform.instance.hasURLs();
  }
}
