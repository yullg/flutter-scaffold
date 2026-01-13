import 'package:scaffold/scaffold_sugar.dart';
import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';

class DatabaseFactory {
  final DatabaseSchema schema;

  const DatabaseFactory(this.schema);

  Future<Database> createDatabase() => openDatabase(
    schema.path,
    version: schema.version,
    onConfigure: schema.configureSQLSupplier?.let((it) => (db) => _executeSqls(db, it())),
    onCreate: schema.createSQLSupplier?.let((it) => (db, version) => _executeSqls(db, it(version))),
    onUpgrade: schema.upgradeSQLSupplier?.let(
      (it) => (db, oldVersion, newVersion) => _executeSqls(db, it(oldVersion, newVersion)),
    ),
    onDowngrade: schema.downgradeSQLSupplier?.let(
      (it) => (db, oldVersion, newVersion) => _executeSqls(db, it(oldVersion, newVersion)),
    ),
    onOpen: schema.openSQLSupplier?.let((it) => (db) => _executeSqls(db, it())),
    readOnly: schema.readOnly,
    singleInstance: schema.singleInstance,
  );

  Future<Database> createReadOnlyDatabase() => openReadOnlyDatabase(schema.path, singleInstance: schema.singleInstance);

  Future<void> _executeSqls(Database db, Iterable<String> sqls) async {
    for (final sql in sqls) {
      await db.execute(sql);
    }
  }
}
