import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cm;

import '../scaffold_constants.dart';
import '../scaffold_module.dart';

class GlobalCacheManager extends cm.CacheManager with cm.ImageCacheManager {
  static GlobalCacheManager? _instance;

  factory GlobalCacheManager() {
    return _instance ??= GlobalCacheManager._();
  }

  GlobalCacheManager._()
      : super(cm.Config(
          ScaffoldConstants.kCacheManagerKeyGlobal,
          stalePeriod: Duration(days: ScaffoldModule.config.globalCacheManagerStalePeriod),
          maxNrOfCacheObjects: ScaffoldModule.config.globalCacheManagerMaxNrOfCacheObjects,
        ));
}
