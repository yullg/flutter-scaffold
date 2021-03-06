import 'app/client_configuration_manager.dart';
import 'app/client_message_manager.dart';
import 'app/client_version_manager.dart';
import 'app/database_manager.dart';
import 'app/security_manager.dart';
import 'core/scaffold_logger.dart';
import 'scaffold_config.dart';

class ScaffoldModule {
  static ScaffoldConfig? _config;

  static ScaffoldConfig get config => _config!;

  static Future<void> initialize(ScaffoldConfig config) async {
    try {
      _config = config;
      await DatabaseManager.initialize();
      await SecurityManager.initialize();
      await ClientVersionManager.initialize();
      await ClientConfigurationManager.initialize();
      await ClientMessageManager.initialize();
    } catch (e, s) {
      ScaffoldLogger.fatal("ScaffoldModule initialize error", e, s);
      rethrow;
    }
  }

  static Future<void> destroy() async {
    try {
      await ClientMessageManager.destroy();
      await ClientConfigurationManager.destroy();
      await ClientVersionManager.destroy();
      await SecurityManager.destroy();
      await DatabaseManager.destroy();
      _config = null;
    } catch (e, s) {
      ScaffoldLogger.fatal("ScaffoldModule destroy error", e, s);
      rethrow;
    }
  }

  ScaffoldModule._();
}
