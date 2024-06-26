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
                case "startAccessingSecurityScopedResource":
                    guard let callArguments = call.arguments as? [String: Any?] else {
                        throw ScaffoldPluginError.nilPointer
                    }
                    guard let urlStr = callArguments["url"] as? String else {
                        throw ScaffoldPluginError.nilPointer
                    }
                    guard let url = URL(urlStr) else {
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
                    guard let url = URL(urlStr) else {
                        throw ScaffoldPluginError.nilPointer
                    }
                    url.stopAccessingSecurityScopedResource()
                    result(nil)
            }
        } catch {
          result(FlutterError(code: "URLPluginError", message: error.localizedDescription, details: nil))
        }
    }

}