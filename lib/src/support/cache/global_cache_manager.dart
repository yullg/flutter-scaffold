import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../scaffold_constants.dart';

class GlobalCacheManager extends CacheManager with ImageCacheManager {
  static const kStalePeriod = Duration(days: 30);
  static const kMaxNrOfCacheObjects = 99999;

  static GlobalCacheManager? _instance;

  factory GlobalCacheManager() {
    return _instance ??= GlobalCacheManager._();
  }

  GlobalCacheManager._()
      : super(Config(
          ScaffoldConstants.kCacheManagerKeyGlobal,
          stalePeriod: stalePeriod,
          maxNrOfCacheObjects: maxNrOfCacheObjects,
        ));

  static Duration? _stalePeriod;
  static int? _maxNrOfCacheObjects;

  static void initialize({
    Duration? stalePeriod,
    int? maxNrOfCacheObjects,
  }) {
    _stalePeriod = stalePeriod;
    _maxNrOfCacheObjects = maxNrOfCacheObjects;
    _instance = null;
  }

  static Duration get stalePeriod => _stalePeriod ?? kStalePeriod;

  static int get maxNrOfCacheObjects => _maxNrOfCacheObjects ?? kMaxNrOfCacheObjects;

  static void destroy() {
    _stalePeriod = null;
    _maxNrOfCacheObjects = null;
    _instance = null;
  }
}
