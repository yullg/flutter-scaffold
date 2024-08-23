import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../config/scaffold_cache_option.dart';
import '../config/scaffold_config.dart';

class GlobalCacheManager extends CacheManager with ImageCacheManager {
  static GlobalCacheManager? _instance;

  factory GlobalCacheManager() {
    return _instance ??= GlobalCacheManager._();
  }

  GlobalCacheManager._()
      : super(Config(
          ScaffoldConfig.kCacheManagerKeyGlobal,
          stalePeriod: ScaffoldConfig.cacheOption?.stalePeriod ?? ScaffoldCacheOption.kStalePeriod,
          maxNrOfCacheObjects: ScaffoldConfig.cacheOption?.maxNrOfCacheObjects ?? ScaffoldCacheOption.kMaxNrOfCacheObjects,
        ));
}
