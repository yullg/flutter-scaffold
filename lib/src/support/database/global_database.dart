import 'package:sqflite/sqflite.dart';

import '../../config/scaffold_config.dart';
import '../../core/error.dart';
import 'database_factory.dart' as my;
import 'database_schema.dart';

class GlobalDatabase {
  static Database? _database;

  static Future<void> initialize({DatabaseSchema? schema}) async {
    final localSchema = schema ?? ScaffoldConfig.databaseOption?.globalDatabaseSchema;
    if (localSchema == null) {
      throw MissingConfigurationError();
    }
    _database = await my.DatabaseFactory(localSchema).createDatabase();
  }

  static Database get database => _database!;

  static bool get isOpen => database.isOpen;

  static String get path => database.path;

  static Batch batch() => database.batch();

  static Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) =>
      database.delete(table, where: where, whereArgs: whereArgs);

  static Future<void> execute(String sql, [List<Object?>? arguments]) => database.execute(sql, arguments);

  static Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) => database.insert(table, values, nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);

  static Future<List<Map<String, Object?>>> query(
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

  static Future<QueryCursor> queryCursor(
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

  static Future<int> rawDelete(String sql, [List<Object?>? arguments]) => database.rawDelete(sql, arguments);

  static Future<int> rawInsert(String sql, [List<Object?>? arguments]) => database.rawInsert(sql, arguments);

  static Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments]) =>
      database.rawQuery(sql, arguments);

  static Future<QueryCursor> rawQueryCursor(String sql, List<Object?>? arguments, {int? bufferSize}) =>
      database.rawQueryCursor(sql, arguments, bufferSize: bufferSize);

  static Future<int> rawUpdate(String sql, [List<Object?>? arguments]) => database.rawUpdate(sql, arguments);

  static Future<T> transaction<T>(Future<T> Function(Transaction txn) action, {bool? exclusive}) =>
      database.transaction(action, exclusive: exclusive);

  static Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) => database.update(table, values, where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm);

  static Future<void> destroy() async {
    await _database?.close();
    _database = null;
  }

  GlobalDatabase._();
}
