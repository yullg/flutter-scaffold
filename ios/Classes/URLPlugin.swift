import Flutter

class URLPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.yullg.flutter.scaffold/url",
            binaryMessenger: registrar.messenger())
        let instance = URLPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "createFileURL":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let fileURLWithPath = callArguments["fileURLWithPath"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                let isDirectory = callArguments["isDirectory"] as? Bool
                let relativeTo: URL? = if let relativeToStr = callArguments["relativeTo"] as? String {
                    URL(string: relativeToStr)
                } else {
                    nil
                }
                let fileURL = if let isDirectory {
                    URL(fileURLWithPath: fileURLWithPath, isDirectory: isDirectory, relativeTo: relativeTo)
                } else {
                    URL(fileURLWithPath: fileURLWithPath, relativeTo: relativeTo)
                }
                result(fileURL.absoluteString)
            case "startAccessingSecurityScopedResource":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let urlStr = callArguments["url"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let url = URL(string: urlStr) else {
                    throw ScaffoldPluginError.nilPointer
                }
                result(url.startAccessingSecurityScopedResource())
            case "stopAccessingSecurityScopedResource":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let urlStr = callArguments["url"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let url = URL(string: urlStr) else {
                    throw ScaffoldPluginError.nilPointer
                }
                url.stopAccessingSecurityScopedResource()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch {
            result(FlutterError(code: "URLPluginError", message: error.localizedDescription, details: nil))
        }
    }
    
}
