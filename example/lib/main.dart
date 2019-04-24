/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lua/flutter_lua.dart' show Lua, LuaThread;

void main() async {
  final version = await Lua.version;
  print("Lua $version");

  final thread = await LuaThread.spawn();
  print(await thread.eval('return 6*7'));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _codeController = TextEditingController(text: "return 6*7");
  String _luaVersion = "Unknown";
  LuaThread _luaThread;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String luaVersion;
    LuaThread luaThread;

    // Platform messages may fail, so we catch platform exceptions:
    try {
      luaVersion = await Lua.version;
      luaThread = await LuaThread.spawn();
    } on PlatformException {
      luaVersion = "Failed to get platform version.";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance:
    if (!mounted) return;

    setState(() {
      _luaVersion = luaVersion;
      _luaThread = luaThread;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Lua plugin"),
        ),
        body: Builder(
          builder: (final BuildContext context) {
            return Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24, right: 24),
                children: <Widget>[
                  Center(child: Text("Lua $_luaVersion")),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _codeController,
                    maxLines: 10,
                    autofocus: true,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Your code",
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  SizedBox(height: 8),
                  RaisedButton(
                    child: Text("Evaluate", style: TextStyle(color: Colors.white)),
                    onPressed: (_luaThread != null) ? () => _evaluate(context) : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.all(12),
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _evaluate(final BuildContext context) async {
    final result = await _luaThread.eval(_codeController.text);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(result.toString(), textAlign: TextAlign.center),
      ),
    );
  }
}
