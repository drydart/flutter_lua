/* This is free and unencumbered software released into the public domain. */

package com.github.drydart.flutter_lua;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterLuaPlugin */
public class FlutterLuaPlugin extends FlutterMethodCallHandler {
  private static final String TAG = "FlutterLuaPlugin";
  public static final String CHANNEL = "flutter_lua";

  private long threadID;

  FlutterLuaPlugin(final Registrar registrar) {
    super(registrar);
  }

  /** Plugin registration. */
  public static void registerWith(final Registrar registrar) {
    assert(registrar != null);

    (new MethodChannel(registrar.messenger(), CHANNEL))
      .setMethodCallHandler(new FlutterLuaPlugin(registrar));
  }

  @Override
  public void onMethodCall(final MethodCall call, final Result result) {
    assert(call != null);
    assert(result != null);

    assert(call.method != null);
    switch (call.method) {

      case "getVersion": {
        result.success(Flutter_lua_vm.version());
        break;
      }

      case "spawnThread": {
        this.threadID++;
        new FlutterLuaThreadHandler(this.registrar, this.threadID);
        result.success(this.threadID);
        break;
      }

      case "doFile": { // @experimental
        try {
          final State state = new State();
          state.doFile((String)call.arguments);
          result.success(null);
        }
        catch (final Exception error) {
          result.error("Exception", error.getMessage(), error.toString());
        }
        break;
      }

      case "doString": { // @experimental
        try {
          final State state = new State();
          state.doString((String)call.arguments);
          result.success(null);
        }
        catch (final Exception error) {
          result.error("Exception", error.getMessage(), error.toString());
        }
        break;
      }

      default: {
        result.notImplemented();
      }
    }
  }
}
