import 'package:drift/drift.dart' as drift;

abstract class OfflineCacheTable {
Future<void> insertItem(String tableName, Map<String, dynamic> item);
drift.TableInfo? _getTableByName(String tableName);
drift.Insertable? _createCompanion(String tableName, Map<String, dynamic> item);
String systemIdColumn="systemId";

}