class Utils{
    
    static func rootViewController() -> UIViewController?{
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    if #available(iOS 15.0, *) {
                        return windowScene.keyWindow?.rootViewController
                    } else {
                        return windowScene.windows.first(where: {$0.isKeyWindow})?.rootViewController
                    }
                }
            }
            return nil
        } else {
            return UIApplication.shared.keyWindow?.rootViewController
        }
    }
    
}
