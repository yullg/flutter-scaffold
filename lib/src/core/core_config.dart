/// 核心配置（只读版本）。
abstract class CoreConfig {
  int get globalCacheManagerStalePeriod;

  int get globalCacheManagerMaxNrOfCacheObjects;
}

/// 核心配置（读写版本）。
class MutableCoreConfig implements CoreConfig {
  @override
  int get globalCacheManagerStalePeriod => 30;

  @override
  int get globalCacheManagerMaxNrOfCacheObjects => 99999;
}
