import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'clipboard_handler_method_channel.dart';

abstract class ClipboardHandlerPlatform extends PlatformInterface {
  /// Constructs a ClipboardHandlerPlatform.
  ClipboardHandlerPlatform() : super(token: _token);

  static final Object _token = Object();

  static ClipboardHandlerPlatform _instance = MethodChannelClipboardHandler();

  /// The default instance of [ClipboardHandlerPlatform] to use.
  ///
  /// Defaults to [MethodChannelClipboardHandler].
  static ClipboardHandlerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ClipboardHandlerPlatform] when
  /// they register themselves.
  static set instance(ClipboardHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> hasURLs() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
