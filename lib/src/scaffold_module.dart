import 'app/client_configuration_manager.dart';
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
      await ClientConfigurationManager.initialize();
    } catch (e, s) {
      ScaffoldLogger.fatal("ScaffoldModule initialize error", e, s);
      rethrow;
    }
  }

  static Future<void> destroy() async {
    try {
      await ClientConfigurationManager.destroy();
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
