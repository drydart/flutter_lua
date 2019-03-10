/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/services.dart' show PlatformException;

import 'dart:io';

/// A Lua VM error.
class LuaError implements IOException {
  final String message;

  const LuaError(this.message);

  LuaError.from(final PlatformException exception)
      : message = exception.message;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write("LuaError");
    if (message.isNotEmpty) {
      buffer..write(": ")..write(message);
    }
    return buffer.toString();
  }
}
