import Flutter

class BasicPlugin: NSObject, FlutterPlugin {

    private let regex = try! NSRegularExpression(pattern: "^(.+?)(\\.(.+))?$")

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.yullg.flutter.scaffold/basic",
            binaryMessenger: registrar.messenger())
        let instance = BasicPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            let method = call.method
            let methodRang = NSRange(method.startIndex..., in: method)
            guard let methodMatch = regex.firstMatch(in: method, range: methodRang) else {
                throw ScaffoldPluginError.illegalArgument
            }
            switch group(1, in: methodMatch, of: method) {
            case "ProcessInfoIBM":
                switch group(3, in: methodMatch, of: method) {
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

    private static func group(_ index: Int, in match: NSTextCheckingResult, of string: String) -> String? {
        let range = match.range(at: index)
        guard range.location != NSNotFound, let swiftRange = Range(range, in: string) else {
            return nil
        }
        return String(string[swiftRange])
    }
    
}
