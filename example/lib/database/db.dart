import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:flutter_auth/offline_cache/interface.dart';

part 'db.g.dart';

// Define tables
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get systemId => text().nullable()();
  IntColumn get sysId => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
}

class Category extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get systemId => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
}

class SubCat extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cacheId => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
}

// Database class
@DriftDatabase(tables: [Todos, Category, SubCat])
class AppDatabase extends _$AppDatabase implements OfflineCacheTable {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        dprint("Creating all &&&&&*********&&&&&");

        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        dprint("Updating dnb &&&&&*********&&&&&");
        // await m.drop(category);
        // await  m.createTable(category);
        await m.addColumn(category, category.systemId);
      },
    );
  }

  // CRUD operations
  Future<int> addTodo(TodosCompanion entry) => into(todos).insert(entry);
  Future<List<Todo>> getAllTodos() => select(todos).get();

  // Future<int> updateTodoEntry(Todo entry) => update(todos).replace(entry);
  Future<int> deleteTodoEntry(Todo entry) => delete(todos).delete(entry);

  Function? _getInsertFunction(String tableName) {
    switch (tableName) {
      case 'category':
        return insertCategory;
      default:
        return null;
    }
  }

  Future<int> insertCategory(Map<String, dynamic> item) async {
    var systemId = item["id"];
    final companion =
        _createCompanion("category", item) as Insertable<CategoryData>;
    final query = select(category)
      ..where((tbl) => tbl.systemId.equals(systemId));
    final result = await query.get();
    if (result.isNotEmpty) {
      return 1;
    } else {
      if (companion != null) {
        return await into(category).insert(companion);
      }
    }
    return 0;
  }

  // Method to insert items into the correct table dynamically
  Future<void> insertItem(String tableName, Map<String, dynamic> item) async {
    //  dprint("hello maind.....");
    final table = _getTableByName(tableName);
    if (table != null) {
      Function? insertFunction = _getInsertFunction(tableName);
      if (insertFunction != null) {
        var res = await insertFunction(item);
        // dprint("Database operation $res",);
      }
    } else {
      throw Exception('Table not found in _getTableByName');
    }
  }

  Map<String, TableInfo> _tables() {
    return {
      'todos': todos,
      'category': category,
    };
  }

  TableInfo? _getTableByName(String tableName) {
    return _tables()?[tableName];
  }

  Insertable? _createCompanion(String tableName, Map<String, dynamic> item) {
    return _companions[tableName]?.call(item);
  }

  final Map<String, Insertable Function(Map<String, dynamic>)> _companions = {
    'todos': (item) => TodosCompanion(
          sysId: Value(item['id']),
          name: Value(item['name']),
          description: Value(item['description']),
        ),
    'category': (item) => CategoryCompanion(
          systemId: Value(item['id']),
          name: Value(item['name']),
          description: Value(item['description']),
        ),
  };

  @override
  String systemIdColumn = "systemId";
}
