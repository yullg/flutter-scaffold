class DatabaseSchema {
  final String path;
  final int version;
  final bool? readOnly;
  final bool? singleInstance;
  final Iterable<String> Function()? configureSQLSupplier;
  final Iterable<String> Function(int version)? createSQLSupplier;
  final Iterable<String> Function(int oldVersion, int newVersion)? upgradeSQLSupplier;
  final Iterable<String> Function(int oldVersion, int newVersion)? downgradeSQLSupplier;
  final Iterable<String> Function()? openSQLSupplier;

  const DatabaseSchema({
    required this.path,
    required this.version,
    this.readOnly,
    this.singleInstance,
    this.configureSQLSupplier,
    this.createSQLSupplier,
    this.upgradeSQLSupplier,
    this.downgradeSQLSupplier,
    this.openSQLSupplier,
  });

  @override
  String toString() {
    return 'DatabaseSchema{path: $path, version: $version, readOnly: $readOnly, singleInstance: $singleInstance, configureSQLSupplier: $configureSQLSupplier, createSQLSupplier: $createSQLSupplier, upgradeSQLSupplier: $upgradeSQLSupplier, downgradeSQLSupplier: $downgradeSQLSupplier, openSQLSupplier: $openSQLSupplier}';
  }
}
