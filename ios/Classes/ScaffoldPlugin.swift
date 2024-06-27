import Flutter

public class ScaffoldPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        DocumentPickerPlugin.register(with: registrar)
        FileManagerPlugin.register(with: registrar)
        URLPlugin.register(with: registrar)
    }
    
}
