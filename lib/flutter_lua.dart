/* This is free and unencumbered software released into the public domain. */

/// Lua interpreter for Flutter.
library flutter_lua;

export 'src/errors.dart' show LuaError;
export 'src/thread.dart' show LuaThread;

import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:flutter/services.dart' show MethodChannel, PlatformException;

import 'src/errors.dart' show LuaError;

const MethodChannel _channel = const MethodChannel('flutter_lua');

abstract class Lua {
  /// The current Lua runtime version.
  static Future<String> get version async {
    return await _channel.invokeMethod('getVersion');
  }

  /// Evaluates a Lua code snippet, returning a result.
  static Future<dynamic> eval(final String code) async {
    try {
      return await _channel.invokeMethod('evalString', code);
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }

  /// Evaluates a bundled Lua source file, returning a result.
  static Future<dynamic> evalAsset(final String assetName) async {
    try {
      return await _channel.invokeMethod('evalAsset', assetName);
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }

  /// Evaluates a Lua source file, returning a result.
  static Future<dynamic> evalFile(final File path) async {
    try {
      final absolutePath = path.isAbsolute ? path : path.absolute;
      return await _channel.invokeMethod('evalFile', absolutePath.toString());
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }
}
