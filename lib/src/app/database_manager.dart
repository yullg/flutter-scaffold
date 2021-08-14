import 'package:base/base.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../core/asset_encrypter.dart';
import '../scaffold_module.dart';

class DatabaseManager {
  static Database? _database;

  static Future<void> initialize() async {
    _database = await openDatabase(
      ScaffoldModule.config.database_name,
      version: ScaffoldModule.config.database_version,
      onCreate: (db, version) async {
        String sqls = await AssetEncrypter.decrypt(await rootBundle.loadString("assets/sql/database.sql"));
        for (String sql in sqls.split(";")) {
          if (StringHelper.hasText(sql)) {
            await db.execute(sql);
          }
        }
      },
    );
  }

  static Database get database => _database!;

  static Future<void> destroy() async {
    try {
      await _database?.close();
    } finally {
      _database = null;
    }
  }
}
