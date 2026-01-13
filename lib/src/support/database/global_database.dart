import 'package:sqflite/sqflite.dart';

import '../../config/scaffold_config.dart';
import '../../core/error.dart';
import 'database_factory.dart' as my;

class GlobalDatabase {
  static GlobalDatabase? _instance;

  factory GlobalDatabase() {
    return _instance ??= GlobalDatabase._();
  }

  GlobalDatabase._();

  Database? _database;

  Future<void> initialize() async {
    final schema = ScaffoldConfig.databaseOption?.globalDatabaseSchema;
    if (schema == null) {
      throw MissingConfigurationError();
    }
    _database = await my.DatabaseFactory(schema).createDatabase();
  }

  Database get database => _database!;

  bool get isOpen => database.isOpen;

  String get path => database.path;

  Batch batch() => database.batch();

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) =>
      database.delete(table, where: where, whereArgs: whereArgs);

  Future<void> execute(String sql, [List<Object?>? arguments]) => database.execute(sql, arguments);

  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) => database.insert(table, values, nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);

  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) => database.query(
    table,
    distinct: distinct,
    columns: columns,
    where: where,
    whereArgs: whereArgs,
    groupBy: groupBy,
    having: having,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
  );

  Future<QueryCursor> queryCursor(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
    int? bufferSize,
  }) => database.queryCursor(
    table,
    distinct: distinct,
    columns: columns,
    where: where,
    whereArgs: whereArgs,
    groupBy: groupBy,
    having: having,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    bufferSize: bufferSize,
  );

  Future<int> rawDelete(String sql, [List<Object?>? arguments]) => database.rawDelete(sql, arguments);

  Future<int> rawInsert(String sql, [List<Object?>? arguments]) => database.rawInsert(sql, arguments);

  Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments]) =>
      database.rawQuery(sql, arguments);

  Future<QueryCursor> rawQueryCursor(String sql, List<Object?>? arguments, {int? bufferSize}) =>
      database.rawQueryCursor(sql, arguments, bufferSize: bufferSize);

  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) => database.rawUpdate(sql, arguments);

  Future<T> readTransaction<T>(Future<T> Function(Transaction txn) action) => database.readTransaction(action);

  Future<T> transaction<T>(Future<T> Function(Transaction txn) action, {bool? exclusive}) =>
      database.transaction(action, exclusive: exclusive);

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) => database.update(table, values, where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm);

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
