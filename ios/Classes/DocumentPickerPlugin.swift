import Flutter
import UniformTypeIdentifiers

class DocumentPickerPlugin: NSObject, FlutterPlugin, UIDocumentPickerDelegate {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.yullg.flutter.scaffold/document_picker",
            binaryMessenger: registrar.messenger())
        let instance = DocumentPickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    private var flutterResult: FlutterResult?
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "import":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let documentTypes = callArguments["forOpeningContentTypes"] as? [String] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let asCopy = callArguments["asCopy"] as? Bool else {
                    throw ScaffoldPluginError.nilPointer
                }
                let documentPickerVC = if #available(iOS 14.0, *) {
                    UIDocumentPickerViewController(
                        forOpeningContentTypes: try documentTypes.map {
                            guard let result = UTType($0) else {
                                throw ScaffoldPluginError.nilPointer
                            }
                            return result
                        },
                        asCopy: asCopy
                    )
                } else {
                    UIDocumentPickerViewController(documentTypes: documentTypes, in: asCopy ? .import : .open)
                }
                documentPickerVC.delegate = self
                if let directoryURLStr = callArguments["directoryURL"] as? String {
                    if let directoryURL = URL(string: directoryURLStr) {
                        documentPickerVC.directoryURL = directoryURL
                    }
                }
                if let allowsMultipleSelection = callArguments["allowsMultipleSelection"] as? Bool {
                    documentPickerVC.allowsMultipleSelection = allowsMultipleSelection
                }
                if let shouldShowFileExtensions = callArguments["shouldShowFileExtensions"] as? Bool {
                    documentPickerVC.shouldShowFileExtensions = shouldShowFileExtensions
                }
                try Utils.rootViewController().present(documentPickerVC, animated: true)
                flutterResult = result
            case "export":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let forExporting = (callArguments["forExporting"] as? [String])?.map {
                    URL(string: $0) ?? throw ScaffoldPluginError.nilPointer
                } else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let asCopy = callArguments["asCopy"] as? Bool else {
                    throw ScaffoldPluginError.nilPointer
                }
                let documentPickerVC = if #available(iOS 14.0, *) {
                    UIDocumentPickerViewController(forExporting: forExporting, asCopy: asCopy)
                } else {
                    UIDocumentPickerViewController(urls: forExporting, in: asCopy ? .exportToService : .moveToService)
                }
                documentPickerVC.delegate = self
                if let directoryURLStr = callArguments["directoryURL"] as? String {
                    if let directoryURL = URL(directoryURLStr) {
                        documentPickerVC.directoryURL = directoryURL
                    }
                }
                if let shouldShowFileExtensions = callArguments["shouldShowFileExtensions"] as? Bool {
                    documentPickerVC.shouldShowFileExtensions = shouldShowFileExtensions
                }
                Utils.rootViewController().present(documentPickerVC, animated: true)
                flutterResult = result
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch {
            result(FlutterError(code: "DocumentPickerPluginError", message: error.localizedDescription, details: nil))
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        flutterResult?(urls.map{ $0.absoluteString })
        reset()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        flutterResult?([String]())
        reset()
    }
    
    private func reset() {
        flutterResult = nil
    }
    
}
