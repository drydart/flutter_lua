/* This is free and unencumbered software released into the public domain. */

/// Lua interpreter for Flutter.
library flutter_lua;

export 'src/errors.dart';
export 'src/thread.dart' show LuaThread;

import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:flutter/services.dart' show MethodChannel;
import 'package:meta/meta.dart' show experimental;

const MethodChannel _channel = const MethodChannel('flutter_lua');

abstract class Lua {
  /// The Lua runtime version.
  static Future<String> get version async {
    return await _channel.invokeMethod('getVersion');
  }

  @experimental
  static Future<void> doFile(final File path) async {
    final absolutePath = path.isAbsolute ? path : path.absolute;
    return await _channel.invokeMethod('doFile', absolutePath.toString());
  }

  @experimental
  static Future<void> doString(final String code) async {
    return await _channel.invokeMethod('doString', code);
  }
}
