import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'clipboard_handler_platform_interface.dart';

/// An implementation of [ClipboardHandlerPlatform] that uses method channels.
class MethodChannelClipboardHandler extends ClipboardHandlerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('clipboard_handler');

  @override
  Future<bool?> hasURLs() async {
    if (Platform.isIOS) {
      return await methodChannel.invokeMethod<bool>('hasURLs');
    } else {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      return data?.text?.isValidUrl ?? false;
    }
  }
}

extension on String {
  bool get isValidUrl {
    try {
      final uri = Uri.parse(this);
      return (uri.isAbsolute &&
          (uri.isScheme("http") || uri.isScheme('https')));
    } catch (e) {
      return false;
    }
  }
}
