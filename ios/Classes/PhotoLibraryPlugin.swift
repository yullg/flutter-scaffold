import Flutter
import Photos

class PhotoLibraryPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.yullg.flutter.scaffold/photo_library",
            binaryMessenger: registrar.messenger())
        let instance = PhotoLibraryPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "saveImage":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let file = callArguments["file"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                let fileUrl = URL(fileURLWithPath: file)
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileUrl)
                } completionHandler: { success, error in
                    if success {
                        result(nil)
                    } else {
                        result(FlutterError(code: "PhotoLibraryPluginError", message: error?.localizedDescription, details: nil))
                    }
                }
            case "saveVideo":
                guard let callArguments = call.arguments as? [String: Any?] else {
                    throw ScaffoldPluginError.nilPointer
                }
                guard let file = callArguments["file"] as? String else {
                    throw ScaffoldPluginError.nilPointer
                }
                let fileUrl = URL(fileURLWithPath: file)
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl)
                } completionHandler: { success, error in
                    if success {
                        result(nil)
                    } else {
                        result(FlutterError(code: "PhotoLibraryPluginError", message: error?.localizedDescription, details: nil))
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch {
            result(FlutterError(code: "PhotoLibraryPluginError", message: error.localizedDescription, details: nil))
        }
    }

}
