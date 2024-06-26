class Utils{
    
    static func rootViewController() throws -> UIViewController  {
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    if #available(iOS 15.0, *) {
                        if let result = windowScene.keyWindow?.rootViewController {
                            return result
                        }
                    } else {
                        if let result = windowScene.windows.first(where: {$0.isKeyWindow})?.rootViewController {
                            return result
                        }
                    }
                }
            }
            throw ScaffoldPluginError.nilPointer
        } else {
            guard let result = UIApplication.shared.keyWindow?.rootViewController else {
                throw ScaffoldPluginError.nilPointer
            }
            return result
        }
    }
    
}
