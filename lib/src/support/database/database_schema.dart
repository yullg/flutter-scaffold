class DatabaseSchema {
  final String path;
  final int version;
  final bool? readOnly;
  final bool? singleInstance;
  final Iterable<String> configureSqls;
  final Iterable<String> createSqls;
  final Map<({int oldVersion, int newVersion}), Iterable<String>> _changeSqls;
  final Iterable<String> openSqls;

  const DatabaseSchema({
    required this.path,
    required this.version,
    this.readOnly,
    this.singleInstance,
    this.configureSqls = const Iterable.empty(),
    this.createSqls = const Iterable.empty(),
    Map<({int oldVersion, int newVersion}), Iterable<String>> changeSqls = const {},
    this.openSqls = const Iterable.empty(),
  }) : _changeSqls = changeSqls;

  DatabaseSchema.fromMap(Map<String, dynamic> map)
      : this(
          path: map["path"],
          version: map["version"],
          readOnly: map["readOnly"],
          singleInstance: map["singleInstance"],
          configureSqls: _parseConfigureSqls(map["configureSqls"]),
          createSqls: _parseCreateSqls(map["createSqls"]),
          changeSqls: _parseChangeSqls(map["changeSqls"]),
          openSqls: _parseOpenSqls(map["openSqls"]),
        );

  Iterable<String>? getChangeSqls(({int oldVersion, int newVersion}) version) => _changeSqls[version];

  @override
  String toString() {
    return 'DatabaseSchema{path: $path, version: $version, readOnly: $readOnly, singleInstance: $singleInstance, configureSqls: $configureSqls, createSqls: $createSqls, _changeSqls: $_changeSqls, openSqls: $openSqls}';
  }
}

Iterable<String> _parseConfigureSqls(dynamic jsonList) {
  return [...?jsonList];
}

Iterable<String> _parseCreateSqls(dynamic jsonList) {
  return [...?jsonList];
}

Map<({int oldVersion, int newVersion}), Iterable<String>> _parseChangeSqls(dynamic jsonList) {
  final result = <({int oldVersion, int newVersion}), Iterable<String>>{};
  if (jsonList != null) {
    for (final jsonMap in jsonList) {
      final ({int oldVersion, int newVersion}) key = (
        oldVersion: jsonMap["oldVersion"],
        newVersion: jsonMap["newVersion"],
      );
      final Iterable<String> value = [...?jsonMap["sqls"]];
      result[key] = value;
    }
  }
  return result;
}

Iterable<String> _parseOpenSqls(dynamic jsonList) {
  return [...?jsonList];
}
