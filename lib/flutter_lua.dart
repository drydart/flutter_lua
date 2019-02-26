/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/services.dart';

class FlutterLua {
  static const MethodChannel _channel = const MethodChannel('flutter_lua');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
