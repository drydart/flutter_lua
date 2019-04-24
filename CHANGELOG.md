Changelog
---------

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.1] - 2019-04-24
### Changed
- Improved the example app

## [0.3.0] - 2019-03-14
### Added
- Added initial iOS platform support (#1)
- `Lua.eval()` static method
- `Lua.evalAsset()` static method
- `Lua.evalFile()` static method
### Removed
- `Lua.doString()` method (use `Lua.eval()`)
- `Lua.doFile()` method (use `Lua.evalFile()`)

## [0.2.0] - 2019-03-10
### Added
- `LuaError` exception class
### Changed
- Implemented `PlatformException` wrapping

## [0.1.0] - 2019-02-27
### Added
- `Lua.version` static getter
- `LuaThread#eval()` method
- `LuaThread#evalAsset()` method
- `LuaThread#evalFile()` method
- `LuaThread#exec()` method
- `LuaThread#execAsset()` method
- `LuaThread#execFile()` method

[0.3.1]:  https://github.com/drydart/flutter_lua/compare/0.3.0...0.3.1
[0.3.0]:  https://github.com/drydart/flutter_lua/compare/0.2.0...0.3.0
[0.2.0]:  https://github.com/drydart/flutter_lua/compare/0.1.0...0.2.0
[0.1.0]:  https://github.com/drydart/flutter_lua/compare/0.0.0...0.1.0
