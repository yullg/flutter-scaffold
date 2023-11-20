/// 核心配置（只读版本）。
abstract interface class CoreConfig {
  int get globalCacheManagerStalePeriod;

  int get globalCacheManagerMaxNrOfCacheObjects;
}

/// 核心配置（读写版本）。
class MutableCoreConfig implements CoreConfig {
  @override
  int globalCacheManagerStalePeriod = 30;

  @override
  int globalCacheManagerMaxNrOfCacheObjects = 99999;
}
