import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';

class DatabaseFactory {
  final DatabaseSchema schema;

  const DatabaseFactory(this.schema);

  Future<Database> createDatabase() => openDatabase(
        schema.path,
        version: schema.version,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onChange,
        onDowngrade: _onChange,
        onOpen: _onOpen,
        readOnly: schema.readOnly,
        singleInstance: schema.singleInstance,
      );

  Future<Database> createReadOnlyDatabase() => openReadOnlyDatabase(
        schema.path,
        singleInstance: schema.singleInstance,
      );

  Future<void> _onConfigure(Database db) async {
    for (final sql in schema.configureSqls) {
      await db.execute(sql);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    for (final sql in schema.createSqls) {
      await db.execute(sql);
    }
  }

  Future<void> _onChange(Database db, int oldVersion, int newVersion) async {
    final sqls = schema.getChangeSqls((oldVersion: oldVersion, newVersion: newVersion));
    if (sqls != null) {
      for (final sql in sqls) {
        await db.execute(sql);
      }
    }
  }

  Future<void> _onOpen(Database db) async {
    for (final sql in schema.openSqls) {
      await db.execute(sql);
    }
  }
}
