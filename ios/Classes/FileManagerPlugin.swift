import Flutter

class FileManagerPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.yullg.flutter.scaffold/file_manager",
            binaryMessenger: registrar.messenger())
        let instance = FileManagerPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    private let dispatchQueue = DispatchQueue.global()
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "createDirectory":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let atStr = callArguments["at"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let at = URL(string: atStr) else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let withIntermediateDirectories = callArguments["withIntermediateDirectories"] as? Bool else {
                    throw ScaffoldPluginError.nilPointer
                }
                try createDirectory(result: result, at: at, withIntermediateDirectories: withIntermediateDirectories)
            case "copyItem":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let atStr = callArguments["at"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let at = URL(string: atStr) else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let toStr = callArguments["to"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let to = URL(string: toStr) else {
                    throw ScaffoldPluginError.nilPointer
                }
                try copyItem(result: result, at: at, to: to)
            case "moveItem":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let atStr = callArguments["at"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let at = URL(string: atStr) else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let toStr = callArguments["to"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let to = URL(string: toStr) else {
                    throw ScaffoldPluginError.nilPointer
                }
                try moveItem(result: result, at: at, to: to)
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch {
            result(FlutterError(code: "FileManagerPluginError", message: error.localizedDescription, details: nil))
        }
    }
    
    private func createDirectory(result: @escaping FlutterResult, at: URL, withIntermediateDirectories: Bool) throws {
        dispatchQueue.async {
            do {
                try FileManager.default.createDirectory(
                    at: at,
                    withIntermediateDirectories: withIntermediateDirectories
                )
                result(nil)
            } catch {
                result(FlutterError(code: "FileManagerPluginError", message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func copyItem(result: @escaping FlutterResult, at: URL, to: URL) throws {
        dispatchQueue.async {
            do {
                try FileManager.default.createDirectory(
                    at: to.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                try FileManager.default.copyItem(at: at, to: to)
                result(nil)
            } catch {
                result(FlutterError(code: "FileManagerPluginError", message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func moveItem(result: @escaping FlutterResult, at: URL, to: URL) throws {
        dispatchQueue.async {
            do {
                try FileManager.default.createDirectory(
                    at: to.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                try FileManager.default.moveItem(at: at, to: to)
                result(nil)
            } catch {
                result(FlutterError(code: "FileManagerPluginError", message: error.localizedDescription, details: nil))
            }
        }
    }
    
}
