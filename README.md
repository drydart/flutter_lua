Flutter Lua Plugin
==================

[![Project license](https://img.shields.io/badge/license-Public%20Domain-blue.svg)](https://unlicense.org)
[![Pub package](https://img.shields.io/pub/v/flutter_lua.svg)](https://pub.dartlang.org/packages/flutter_lua)
[![Dartdoc reference](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dartlang.org/documentation/flutter_lua/latest/)
[![Travis CI build status](https://img.shields.io/travis/drydart/flutter_lua/master.svg)](https://travis-ci.org/drydart/flutter_lua)
[![Liberapay patrons](http://img.shields.io/liberapay/patrons/drydart.svg?logo=liberapay)](https://liberapay.com/drydart/donate)

This is a [Flutter](https://flutter.dev) plugin that embeds
a [Lua](https://www.lua.org/) interpreter and runtime for executing dynamic
scripts from Flutter apps.

Features
--------

- Embeds a [Lua 5.2](https://www.lua.org/manual/5.2/) interpreter into your
  Flutter app.

- Executes Lua code on a background thread (*not* on the main UI thread).

- Supports executing source code snippets from strings as well as from
  source files bundled in your app's asset bundle.

Compatibility
-------------

Android and iOS both.

Examples
--------

### Checking the Lua runtime version

```dart
import 'package:flutter_lua/flutter_lua.dart' show Lua;

print(await Lua.version);
```

### Spawning a new Lua interpreter thread

```dart
import 'package:flutter_lua/flutter_lua.dart' show LuaThread;

var thread = await LuaThread.spawn();
```

### Evaluating a Lua code snippet

```dart
import 'package:flutter_lua/flutter_lua.dart' show LuaThread;

var thread = await LuaThread.spawn();

await thread.eval("return 6 * 7"); //=> 42.0
```

### Executing a bundled Lua source file

```dart
import 'package:flutter_lua/flutter_lua.dart' show LuaThread;

var thread = await LuaThread.spawn();

await thread.execAsset("scripts/myscript.lua");
```

Frequently Asked Questions
--------------------------

### How much does using this plugin increase my final app size?

About 3.8 MiB, at present.

Caveats
-------

- **Currently the only supported result datatypes from `LuaThread#eval*()`
  methods are booleans, floating-point numbers (doubles), and strings.**
  This will be extended further over the next releases.
