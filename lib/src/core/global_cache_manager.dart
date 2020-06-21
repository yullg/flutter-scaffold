import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cm;

import '../scaffold_config.dart';
import '../scaffold_constants.dart';

class GlobalCacheManager extends cm.CacheManager with cm.ImageCacheManager {
  static GlobalCacheManager? _instance;

  factory GlobalCacheManager() {
    return _instance ??= GlobalCacheManager._();
  }

  GlobalCacheManager._()
      : super(cm.Config(
          ScaffoldConstants.CACHE_MANAGER_KEY_GLOBAL,
          stalePeriod:
              Duration(days: ScaffoldConfig.core.globalCacheManagerStalePeriod),
          maxNrOfCacheObjects:
              ScaffoldConfig.core.globalCacheManagerMaxNrOfCacheObjects,
        ));
}
