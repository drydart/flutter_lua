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

      case "evalString":
        let state = Flutter_lua_vmState()!
        do {
          try state.execString((call.arguments as! String))
          result(popResult(state))
        }
        catch {
          result(FlutterError(code: "Exception", message: "", details: "")) // TODO: improve error handling
        }

      case "evalAsset":
        result(FlutterMethodNotImplemented) // TODO: implement this

      case "evalFile":
        result(FlutterMethodNotImplemented) // TODO: implement this

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
  let state: Flutter_lua_vmState

  init(registrar: FlutterPluginRegistrar, threadID: Int) {
    self.registrar = registrar
    self.threadID = threadID
    self.state = Flutter_lua_vmState()!
    super.init()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "evalString":
        do {
          try self.state.execString((call.arguments as! String))
          result(popResult(self.state))
        }
        catch {
          result(FlutterError(code: "Exception", message: "", details: "")) // TODO: improve error handling
        }

      case "evalAsset":
        result(FlutterMethodNotImplemented) // TODO: implement this

      case "evalFile":
        result(FlutterMethodNotImplemented) // TODO: implement this

      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

private func popResult(_ state: Flutter_lua_vmState) -> NSObject {
  if (!state.hasResult()) {
    return NSNull()
  }
  switch (state.resultType()) {
    case 0:  // lua.TypeNil
      return NSNull()
    case 1:  // lua.TypeBoolean
      return NSNumber(value: state.boolValue())
    case 2:  // lua.TypeLightUserData
      return NSNull() // TODO
    case 3:  // lua.TypeNumber
      return NSNumber(value: state.doubleValue()) // TODO: support integers
    case 4:  // lua.TypeString
      return NSString(string: state.stringValue())
    case 5:  // lua.TypeTable
      return NSNull() // TODO: NSArray or NSDictionary
    case 6:  // lua.TypeFunction
      return NSNull() // TODO
    case 7:  // lua.TypeUserData
      return NSNull() // TODO
    case 8:  // lua.TypeThread
      return NSNull() // TODO
    case 9, -1:  // lua.TypeCount, lua.TypeNone
      return NSNull() // TODO
    default:
      //assert(false) // unreachable
      return NSNull() // unreachable
  }
}
