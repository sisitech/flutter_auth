# Offline Cache with Drift - Implementation Guide

## 1. Database Setup

Create your database class implementing `OfflineCacheTable`:

```dart
import 'package:drift/drift.dart';
import 'package:flutter_auth/offline_cache/interface.dart';

@DriftDatabase(tables: [Category, Todos])
class AppDatabase extends _$AppDatabase implements OfflineCacheTable {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  String systemIdColumn = "systemId";  // Field name from your API
}
```

## 2. Implement Required Methods

### Map table names to TableInfo
```dart
Map<String, TableInfo> _tables() {
  return {
    'category': category,
    'todos': todos,
  };
}

TableInfo? _getTableByName(String tableName) {
  return _tables()[tableName];
}
```

### Create companions from API JSON
```dart
final Map<String, Insertable Function(Map<String, dynamic>)> _companions = {
  'category': (item) => CategoryCompanion(
    systemId: Value(item['id']),
    name: Value(item['name']),
    description: Value(item['description']),
  ),
  'todos': (item) => TodosCompanion(
    sysId: Value(item['id']),
    name: Value(item['name']),
  ),
};

Insertable? _createCompanion(String tableName, Map<String, dynamic> item) {
  return _companions[tableName]?.call(item);
}
```

### Insert function with duplicate check
```dart
Future<int> insertCategory(Map<String, dynamic> item) async {
  var systemId = item["id"];
  final companion = _createCompanion("category", item) as Insertable<CategoryData>;

  final query = select(category)..where((tbl) => tbl.systemId.equals(systemId));
  final result = await query.get();

  if (result.isNotEmpty) {
    return 1;  // Already exists
  } else {
    return await into(category).insert(companion);
  }
}
```

### Main insertItem method
```dart
Function? _getInsertFunction(String tableName) {
  switch (tableName) {
    case 'category':
      return insertCategory;
    case 'todos':
      return insertTodos;
    default:
      return null;
  }
}

Future<void> insertItem(String tableName, Map<String, dynamic> item) async {
  final table = _getTableByName(tableName);
  if (table != null) {
    Function? insertFunction = _getInsertFunction(tableName);
    if (insertFunction != null) {
      await insertFunction(item);
    }
  } else {
    throw Exception('Table not found: $tableName');
  }
}
```

## 3. Initialize in main()

```dart
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_auth/offline_cache/offline_cache_controller.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'myapp.sqlite'));
    return NativeDatabase(file);
  });
}

void main() async {
  final database = AppDatabase(_openConnection());

  Get.put(OfflineCacheSyncController(
    database: database,
    offlineCacheItems: [
      OfflineCacheItem(
        tableName: 'category',
        pageSize: 300,
        nickName: 'Categories',
        path: "api/v1/categories"
      ),
      OfflineCacheItem(
        tableName: 'todos',
        pageSize: 100,
        nickName: 'Todo Items',
        path: "api/v1/todos"
      ),
    ],
  ));

  runApp(MyApp());
}
```

## 4. Trigger Sync

```dart
final controller = Get.find<OfflineCacheSyncController>();
await controller.updateCache();
```

## 5. Display Sync Progress (Optional)

```dart
import 'package:flutter_auth/offline_cache/offline_cache_widget.dart';

// In your widget tree:
OfflineCacheListWidget()
```

## Key Points

- Each table needs a `systemId` column to track API IDs
- `tableName` in `OfflineCacheItem` must match keys in `_tables()` map
- `path` is the API endpoint that returns paginated results
- Controller auto-handles pagination via `next` field in API response
- Duplicate checking prevents re-inserting existing records
