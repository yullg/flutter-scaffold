import Flutter
import UniformTypeIdentifiers

class DocumentPickerUseCase: NSObject, UIDocumentPickerDelegate {
    
    private var flutterMethodCall: FlutterMethodCall?
    private var flutterResult: FlutterResult?
    
    func importDocument(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        flutterMethodCall = call
        flutterResult = result
        
        let callArguments = call.arguments as! [String: Any?]
        let allowedUTIs = callArguments["allowedUTIs"] as! [String]
        let asCopy = callArguments["asCopy"] as! Bool
        let allowsMultipleSelection = callArguments["allowsMultipleSelection"] as! Bool
        let documentPickerVC = if #available(iOS 14.0, *) {
            UIDocumentPickerViewController(
                forOpeningContentTypes: allowedUTIs.map { UTType($0)! },
                asCopy: asCopy
            )
        } else {
            UIDocumentPickerViewController(documentTypes: allowedUTIs, in: asCopy ? .import : .open)
        }
        documentPickerVC.delegate = self
        documentPickerVC.allowsMultipleSelection = allowsMultipleSelection
        Utils.rootViewController()!.present(documentPickerVC, animated: true)
    }
    
    func exportDocument(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        flutterMethodCall = call
        flutterResult = result
        
        let callArguments = call.arguments as! [String: Any?]
        let urls = (callArguments["urls"] as! [String]).map {
            URL(string: $0)!
        }
        let asCopy = callArguments["asCopy"] as! Bool
        let documentPickerVC = if #available(iOS 14.0, *) {
            UIDocumentPickerViewController(forExporting: urls, asCopy: asCopy)
        } else {
            UIDocumentPickerViewController(urls: urls, in: asCopy ? .exportToService : .moveToService)
        }
        documentPickerVC.delegate = self
        Utils.rootViewController()!.present(documentPickerVC, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        flutterResult?(urls.map{ $0.absoluteString })
        reset()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        flutterResult?(Array<String>())
        reset()
    }
    
    private func reset() {
        flutterMethodCall = nil
        flutterResult = nil
    }
    
}
