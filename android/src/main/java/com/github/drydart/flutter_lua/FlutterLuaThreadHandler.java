/* This is free and unencumbered software released into the public domain. */

package com.github.drydart.flutter_lua;

import com.github.drydart.flutter_lua_vm.Flutter_lua_vm;
import com.github.drydart.flutter_lua_vm.State;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.io.IOException;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;
import java.util.function.BiConsumer;
import java.util.function.Supplier;

/** FlutterLuaThreadHandler */
@SuppressWarnings("unchecked")
final class FlutterLuaThreadHandler extends FlutterMethodCallHandler {
  private static final String TAG = "FlutterLuaThreadHandler";
  public static final String CHANNEL_PREFIX = FlutterLuaPlugin.CHANNEL;

  private final MethodChannel channel;
  private final ExecutorService executor;
  private final State state;

  FlutterLuaThreadHandler(final Registrar registrar,
                          final long threadID) {
    super(registrar);
    final String channelName = String.format("%s/#%d", CHANNEL_PREFIX, threadID);
    this.channel = new MethodChannel(registrar.messenger(), channelName);
    this.executor = Executors.newSingleThreadScheduledExecutor();
    this.state = Flutter_lua_vm.newState();
    channel.setMethodCallHandler(this);
  }

  static private class ResultCompleter implements BiConsumer<Object, Throwable> {
    final Result result;

    ResultCompleter(final Result result) {
      this.result = result;
    }

    @Override
    public void accept(final Object value,
                       final Throwable error) {
      if (error != null) {
        //error.printStackTrace(); // DEBUG
        final Throwable cause = getRootCause(error);
        this.result.error("LuaError", cause.getMessage(), null);
      }
      else {
        this.result.success(value);
      }
    }

    private Throwable getRootCause(final Throwable throwable) {
      final Throwable cause = throwable.getCause();
      return (cause != null) ? getRootCause(cause) : throwable;
    }
  }

  @Override
  public void onMethodCall(final MethodCall call,
                           final Result result) {
    assert(call != null);
    assert(result != null);

    assert(call.method != null);
    switch (call.method) {

      case "evalString": {
        final State state = this.state;
        final String code = (String)call.arguments;
        CompletableFuture
          .supplyAsync(new Supplier() {
            @Override
            public Object get() {
              try {
                state.execString(code);
                return FlutterLuaPlugin.popResult(state);
              }
              catch (final Exception error) {
                throw new RuntimeException(error);
              }
            }
          }, this.executor)
          .whenComplete(new ResultCompleter(result));
        break;
      }

      case "evalAsset": {
        final State state = this.state;
        final String assetName = (String)call.arguments;
        final String code;
        try {
          code = readAssetText(assetName);
        }
        catch (final IOException error) {
          result.error("IOException", error.getMessage(), error.toString());
          return;
        }
        CompletableFuture
          .supplyAsync(new Supplier() {
            @Override
            public Object get() {
              try {
                state.execString(code);
                return FlutterLuaPlugin.popResult(state);
              }
              catch (final Exception error) {
                throw new RuntimeException(error);
              }
            }
          }, this.executor)
          .whenComplete(new ResultCompleter(result));
        break;
      }

      case "evalFile": {
        final State state = this.state;
        final String path = (String)call.arguments;
        CompletableFuture
          .supplyAsync(new Supplier() {
            @Override
            public Object get() {
              try {
                state.doFile(path);
                return FlutterLuaPlugin.popResult(state);
              }
              catch (final Exception error) {
                throw new RuntimeException(error);
              }
            }
          }, this.executor)
          .whenComplete(new ResultCompleter(result));
        break;
      }

      default: {
        result.notImplemented();
      }
    }
  }
}
