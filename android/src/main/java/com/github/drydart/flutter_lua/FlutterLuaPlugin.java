/* This is free and unencumbered software released into the public domain. */

package com.github.drydart.flutter_lua;

import com.github.drydart.flutter_lua_vm.Flutter_lua_vm;
import com.github.drydart.flutter_lua_vm.State;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.io.IOException;

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

      case "evalString": {
        final State state = new State();
        try {
          state.execString((String)call.arguments);
          result.success(popResult(state));
        }
        catch (final Exception error) {
          result.error("Exception", error.getMessage(), error.toString());
        }
        break;
      }

      case "evalAsset": {
        final State state = new State();
        final String assetName = (String)call.arguments;
        final String code;
        try {
          code = readAssetText(assetName);
        }
        catch (final IOException error) {
          result.error("IOException", error.getMessage(), error.toString());
          break;
        }
        try {
          state.execString(code);
          result.success(popResult(state));
        }
        catch (final Exception error) {
          result.error("Exception", error.getMessage(), error.toString());
        }
        break;
      }

      case "evalFile": {
        final State state = new State();
        try {
          state.execFile((String)call.arguments);
          result.success(popResult(state));
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

  static Object popResult(final State state) {
    if (!state.hasResult()) return null;
    switch ((int)state.resultType()) {
      case 0:  // lua.TypeNil
        return null;
      case 1:  // lua.TypeBoolean
        return state.boolValue();
      case 2:  // lua.TypeLightUserData
        return null; // TODO
      case 3:  // lua.TypeNumber
        return state.doubleValue(); // TODO: support integers
      case 4:  // lua.TypeString
        return state.stringValue();
      case 5:  // lua.TypeTable
        return null; // TODO
      case 6:  // lua.TypeFunction
        return null; // TODO
      case 7:  // lua.TypeUserData
        return null; // TODO
      case 8:  // lua.TypeThread
        return null; // TODO
      case 9:  // lua.TypeCount
      case -1: // lua.TypeNone
      default:
        assert(false); // unreachable
        return null; // unreachable
    }
  }
}
