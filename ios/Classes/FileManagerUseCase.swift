import Flutter

class FileManagerUseCase {
    
    private let dispatchQueue = DispatchQueue.global()
    
    func copy(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        let callArguments = call.arguments as! [String: Any?]
        let atUrl = URL(string: callArguments["atUrl"] as! String)!
        let toUrl = URL(string: callArguments["toUrl"] as! String)!
        let isSecurityScoped = callArguments["isSecurityScoped"] as! Bool
        dispatchQueue.async {
            do {
                if isSecurityScoped {
                    _ = atUrl.startAccessingSecurityScopedResource()
                }
                defer {
                    if isSecurityScoped {
                        atUrl.stopAccessingSecurityScopedResource()
                    }
                }
                try FileManager.default.copyItem(at: atUrl, to: toUrl)
                result(nil)
            } catch {
                result(FlutterError(code: "FileManagerUseCaseError", message: "FileManagerUseCase.copy() > failed", details: error.localizedDescription))
            }
        }
    }
    
    func move(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        let callArguments = call.arguments as! [String: Any?]
        let atUrl = URL(string: callArguments["atUrl"] as! String)!
        let toUrl = URL(string: callArguments["toUrl"] as! String)!
        let isSecurityScoped = callArguments["isSecurityScoped"] as! Bool
        dispatchQueue.async {
            do {
                if isSecurityScoped {
                    _ = atUrl.startAccessingSecurityScopedResource()
                }
                defer {
                    if isSecurityScoped {
                        atUrl.stopAccessingSecurityScopedResource()
                    }
                }
                try FileManager.default.moveItem(at: atUrl, to: toUrl)
                result(nil)
            } catch {
                result(FlutterError(code: "FileManagerUseCaseError", message: "FileManagerUseCase.move() > failed", details: error.localizedDescription))
            }
        }
    }
    
}
