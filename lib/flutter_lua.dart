/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/services.dart';

abstract class Lua {
  static const MethodChannel _channel = const MethodChannel('flutter_lua');

  static Future<String> get version async {
    return await _channel.invokeMethod('getVersion');
  }

  static Future<void> doString(final String code) async {
    return await _channel.invokeMethod('doString', code);
  }
}
