/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:flutter/services.dart' show MethodChannel, PlatformException;

import 'errors.dart' show LuaError;

const MethodChannel _global = const MethodChannel('flutter_lua');

/// A Lua thread.
class LuaThread {
  final int id;
  final MethodChannel _thread;

  LuaThread._(this.id) : _thread = MethodChannel('flutter_lua/#$id');

  /// Spawns a new Lua interpreter thread.
  static Future<LuaThread> spawn() async {
    try {
      final int id = await _global.invokeMethod('spawnThread');
      return LuaThread._(id);
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }

  /// Evaluates a Lua code snippet, returning a result.
  Future<dynamic> eval(final String code) async {
    try {
      return await _thread.invokeMethod('evalString', code);
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }

  /// Evaluates a bundled Lua source file, returning a result.
  Future<dynamic> evalAsset(final String assetName) async {
    try {
      return await _thread.invokeMethod('evalAsset', assetName);
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }

  /// Evaluates a Lua source file, returning a result.
  Future<dynamic> evalFile(final File path) async {
    try {
      final absolutePath = path.isAbsolute ? path : path.absolute;
      return await _thread.invokeMethod('evalFile', absolutePath.toString());
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }

  /// Executes a Lua code snippet, for its side effects.
  Future<void> exec(final String code) async {
    try {
      await _thread.invokeMethod('evalString', code);
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }

  /// Executes a bundled Lua source file, for its side effects.
  Future<void> execAsset(final String assetName) async {
    try {
      await _thread.invokeMethod('evalAsset', assetName);
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }

  /// Executes a Lua source file, for its side effects.
  Future<void> execFile(final File path) async {
    try {
      final absolutePath = path.isAbsolute ? path : path.absolute;
      await _thread.invokeMethod('evalFile', absolutePath.toString());
    } on PlatformException catch (error) {
      throw LuaError.from(error);
    }
  }
}
