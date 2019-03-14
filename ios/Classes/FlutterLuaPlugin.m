/* This is free and unencumbered software released into the public domain. */

#import "FlutterLuaPlugin.h"
#import <flutter_lua/flutter_lua-Swift.h>

@implementation FlutterLuaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLuaPlugin registerWithRegistrar:registrar];
}
@end
