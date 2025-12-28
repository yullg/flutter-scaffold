import Flutter

class BasicPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.yullg.flutter.scaffold/basic",
            binaryMessenger: registrar.messenger())
        let instance = BasicPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "ProcessInfoIBM":
                guard let callArguments = call.arguments as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                switch callArguments {
                case "systemUptime":
                    result(ProcessInfo.processInfo.systemUptime)
                default:
                    throw ScaffoldPluginError.illegalArgument
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch {
            result(FlutterError(code: "BasicPluginError", message: error.localizedDescription, details: nil))
        }
    }
    
}
