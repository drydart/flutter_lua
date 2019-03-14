/* This is free and unencumbered software released into the public domain. */

import Flutter
import Flutter_lua_vm
import UIKit

var _threadID: Int = 0

public class SwiftFlutterLuaPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_lua", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterLuaPlugin(registrar: registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  let registrar: FlutterPluginRegistrar

  init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
    super.init()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "getVersion":
        result(Flutter_lua_vmVersion())

      case "spawnThread":
        _threadID += 1
        FlutterLuaThreadHandler.register(with: registrar)
        result(_threadID)

      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

private class FlutterLuaThreadHandler: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_lua/#\(_threadID)", binaryMessenger: registrar.messenger())
    let instance = FlutterLuaThreadHandler(registrar: registrar, threadID: _threadID)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  let registrar: FlutterPluginRegistrar
  let threadID: Int

  init(registrar: FlutterPluginRegistrar, threadID: Int) {
    self.registrar = registrar
    self.threadID = threadID
    super.init()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "evalString":
        result(FlutterMethodNotImplemented) // TODO

      case "evalAsset":
        result(FlutterMethodNotImplemented) // TODO

      case "evalFile":
        result(FlutterMethodNotImplemented) // TODO

      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
