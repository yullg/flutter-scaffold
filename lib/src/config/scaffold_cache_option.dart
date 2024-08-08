class ScaffoldCacheOption {
  static const kStalePeriod = Duration(days: 30);
  static const kMaxNrOfCacheObjects = 99999;

  final Duration? stalePeriod;
  final int? maxNrOfCacheObjects;

  const ScaffoldCacheOption({
    this.stalePeriod,
    this.maxNrOfCacheObjects,
  });

  @override
  String toString() {
    return 'ScaffoldCacheOption{stalePeriod: $stalePeriod, maxNrOfCacheObjects: $maxNrOfCacheObjects}';
  }
}
