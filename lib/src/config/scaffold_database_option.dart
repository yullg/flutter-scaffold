import '../support/database/database_schema.dart';

class ScaffoldDatabaseOption {
  final DatabaseSchema? globalDatabaseSchema;

  const ScaffoldDatabaseOption({
    this.globalDatabaseSchema,
  });

  @override
  String toString() {
    return 'ScaffoldDatabaseOption{globalDatabaseSchema: $globalDatabaseSchema}';
  }
}
