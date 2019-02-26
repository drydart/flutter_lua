/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:flutter/services.dart' show MethodChannel;

abstract class Lua {
  static const MethodChannel _channel = const MethodChannel('flutter_lua');

  static Future<String> get version async {
    return await _channel.invokeMethod('getVersion');
  }

  static Future<void> doFile(final File path) async {
    final absolutePath = path.isAbsolute ? path : path.absolute;
    return await _channel.invokeMethod('doFile', absolutePath.toString());
  }

  static Future<void> doString(final String code) async {
    return await _channel.invokeMethod('doString', code);
  }
}
