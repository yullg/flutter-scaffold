import Flutter

public class ScaffoldPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.yullg.flutter.scaffold/default",
            binaryMessenger: registrar.messenger()
        )
        let instance = ScaffoldPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private let documentPickerUseCase = DocumentPickerUseCase()
    private let fileManagerUseCase = FileManagerUseCase()
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "dpImportDocument":
                try documentPickerUseCase.importDocument(call: call, result: result)
            case "dpExportDocument":
                try documentPickerUseCase.exportDocument(call: call, result: result)
            case "fmCopy":
                try fileManagerUseCase.copy(call: call, result: result)
            case "fmMove":
                try fileManagerUseCase.move(call: call, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch {
            result(FlutterError(code: "ScaffoldPluginError", message: "ScaffoldPlugin.handle() > failed", details: error.localizedDescription))
        }
    }
    
}
