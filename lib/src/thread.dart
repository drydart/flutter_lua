/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:flutter/services.dart' show MethodChannel;

const MethodChannel _global = const MethodChannel('flutter_lua');

/// A Lua thread.
class LuaThread {
  final int id;
  final MethodChannel _thread;

  LuaThread._(this.id)
    : _thread = MethodChannel('flutter_lua/#$id');

  /// Spawns a new Lua thread.
  static Future<LuaThread> spawn() async {
    final int id = await _global.invokeMethod('spawnThread');
    return LuaThread._(id);
  }

  /// Evaluates some Lua code on this thread.
  Future<dynamic> eval(final String code) async {
    return await _thread.invokeMethod('evalString', code);
  }

  /// Evaluates a Lua file on this thread.
  Future<dynamic> evalFile(final File path) async {
    final absolutePath = path.isAbsolute ? path : path.absolute;
    return await _thread.invokeMethod('evalFile', absolutePath.toString());
  }
}
