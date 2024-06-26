import Flutter

public class ScaffoldPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        DocumentPickerPlugin.register(with: register)
        FileManagerPlugin.register(with: register)
        URLPlugin.register(with: register)
    }
    
}
