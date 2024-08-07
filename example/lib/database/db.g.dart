// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _systemIdMeta =
      const VerificationMeta('systemId');
  @override
  late final GeneratedColumn<String> systemId = GeneratedColumn<String>(
      'system_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sysIdMeta = const VerificationMeta('sysId');
  @override
  late final GeneratedColumn<int> sysId = GeneratedColumn<int>(
      'sys_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, systemId, sysId, name, description, image];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(Insertable<Todo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('system_id')) {
      context.handle(_systemIdMeta,
          systemId.isAcceptableOrUnknown(data['system_id']!, _systemIdMeta));
    }
    if (data.containsKey('sys_id')) {
      context.handle(
          _sysIdMeta, sysId.isAcceptableOrUnknown(data['sys_id']!, _sysIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      systemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_id']),
      sysId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sys_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
  final int id;
  final String? systemId;
  final int? sysId;
  final String name;
  final String? description;
  final String? image;
  const Todo(
      {required this.id,
      this.systemId,
      this.sysId,
      required this.name,
      this.description,
      this.image});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || systemId != null) {
      map['system_id'] = Variable<String>(systemId);
    }
    if (!nullToAbsent || sysId != null) {
      map['sys_id'] = Variable<int>(sysId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      systemId: systemId == null && nullToAbsent
          ? const Value.absent()
          : Value(systemId),
      sysId:
          sysId == null && nullToAbsent ? const Value.absent() : Value(sysId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      systemId: serializer.fromJson<String?>(json['systemId']),
      sysId: serializer.fromJson<int?>(json['sysId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'systemId': serializer.toJson<String?>(systemId),
      'sysId': serializer.toJson<int?>(sysId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String?>(image),
    };
  }

  Todo copyWith(
          {int? id,
          Value<String?> systemId = const Value.absent(),
          Value<int?> sysId = const Value.absent(),
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> image = const Value.absent()}) =>
      Todo(
        id: id ?? this.id,
        systemId: systemId.present ? systemId.value : this.systemId,
        sysId: sysId.present ? sysId.value : this.sysId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        image: image.present ? image.value : this.image,
      );
  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('systemId: $systemId, ')
          ..write('sysId: $sysId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, systemId, sysId, name, description, image);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.systemId == this.systemId &&
          other.sysId == this.sysId &&
          other.name == this.name &&
          other.description == this.description &&
          other.image == this.image);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<String?> systemId;
  final Value<int?> sysId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> image;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.systemId = const Value.absent(),
    this.sysId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    this.systemId = const Value.absent(),
    this.sysId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? systemId,
    Expression<int>? sysId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? image,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (systemId != null) 'system_id': systemId,
      if (sysId != null) 'sys_id': sysId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
    });
  }

  TodosCompanion copyWith(
      {Value<int>? id,
      Value<String?>? systemId,
      Value<int?>? sysId,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? image}) {
    return TodosCompanion(
      id: id ?? this.id,
      systemId: systemId ?? this.systemId,
      sysId: sysId ?? this.sysId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (systemId.present) {
      map['system_id'] = Variable<String>(systemId.value);
    }
    if (sysId.present) {
      map['sys_id'] = Variable<int>(sysId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('systemId: $systemId, ')
          ..write('sysId: $sysId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }
}

class $CategoryTable extends Category
    with TableInfo<$CategoryTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _systemIdMeta =
      const VerificationMeta('systemId');
  @override
  late final GeneratedColumn<int> systemId = GeneratedColumn<int>(
      'system_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, systemId, name, description, image];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('system_id')) {
      context.handle(_systemIdMeta,
          systemId.isAcceptableOrUnknown(data['system_id']!, _systemIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      systemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}system_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
    );
  }

  @override
  $CategoryTable createAlias(String alias) {
    return $CategoryTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  final int id;
  final int? systemId;
  final String name;
  final String? description;
  final String? image;
  const CategoryData(
      {required this.id,
      this.systemId,
      required this.name,
      this.description,
      this.image});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || systemId != null) {
      map['system_id'] = Variable<int>(systemId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: Value(id),
      systemId: systemId == null && nullToAbsent
          ? const Value.absent()
          : Value(systemId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
    );
  }

  factory CategoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      systemId: serializer.fromJson<int?>(json['systemId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'systemId': serializer.toJson<int?>(systemId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String?>(image),
    };
  }

  CategoryData copyWith(
          {int? id,
          Value<int?> systemId = const Value.absent(),
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> image = const Value.absent()}) =>
      CategoryData(
        id: id ?? this.id,
        systemId: systemId.present ? systemId.value : this.systemId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        image: image.present ? image.value : this.image,
      );
  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('systemId: $systemId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, systemId, name, description, image);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.systemId == this.systemId &&
          other.name == this.name &&
          other.description == this.description &&
          other.image == this.image);
}

class CategoryCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<int?> systemId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> image;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.systemId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  });
  CategoryCompanion.insert({
    this.id = const Value.absent(),
    this.systemId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoryData> custom({
    Expression<int>? id,
    Expression<int>? systemId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? image,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (systemId != null) 'system_id': systemId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
    });
  }

  CategoryCompanion copyWith(
      {Value<int>? id,
      Value<int?>? systemId,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? image}) {
    return CategoryCompanion(
      id: id ?? this.id,
      systemId: systemId ?? this.systemId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (systemId.present) {
      map['system_id'] = Variable<int>(systemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('systemId: $systemId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }
}

class $SubCatTable extends SubCat with TableInfo<$SubCatTable, SubCatData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubCatTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cacheIdMeta =
      const VerificationMeta('cacheId');
  @override
  late final GeneratedColumn<String> cacheId = GeneratedColumn<String>(
      'cache_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, cacheId, name, description, image];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sub_cat';
  @override
  VerificationContext validateIntegrity(Insertable<SubCatData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cache_id')) {
      context.handle(_cacheIdMeta,
          cacheId.isAcceptableOrUnknown(data['cache_id']!, _cacheIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubCatData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubCatData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cacheId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cache_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
    );
  }

  @override
  $SubCatTable createAlias(String alias) {
    return $SubCatTable(attachedDatabase, alias);
  }
}

class SubCatData extends DataClass implements Insertable<SubCatData> {
  final int id;
  final String? cacheId;
  final String name;
  final String? description;
  final String? image;
  const SubCatData(
      {required this.id,
      this.cacheId,
      required this.name,
      this.description,
      this.image});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || cacheId != null) {
      map['cache_id'] = Variable<String>(cacheId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    return map;
  }

  SubCatCompanion toCompanion(bool nullToAbsent) {
    return SubCatCompanion(
      id: Value(id),
      cacheId: cacheId == null && nullToAbsent
          ? const Value.absent()
          : Value(cacheId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
    );
  }

  factory SubCatData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubCatData(
      id: serializer.fromJson<int>(json['id']),
      cacheId: serializer.fromJson<String?>(json['cacheId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cacheId': serializer.toJson<String?>(cacheId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String?>(image),
    };
  }

  SubCatData copyWith(
          {int? id,
          Value<String?> cacheId = const Value.absent(),
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> image = const Value.absent()}) =>
      SubCatData(
        id: id ?? this.id,
        cacheId: cacheId.present ? cacheId.value : this.cacheId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        image: image.present ? image.value : this.image,
      );
  @override
  String toString() {
    return (StringBuffer('SubCatData(')
          ..write('id: $id, ')
          ..write('cacheId: $cacheId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cacheId, name, description, image);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubCatData &&
          other.id == this.id &&
          other.cacheId == this.cacheId &&
          other.name == this.name &&
          other.description == this.description &&
          other.image == this.image);
}

class SubCatCompanion extends UpdateCompanion<SubCatData> {
  final Value<int> id;
  final Value<String?> cacheId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> image;
  const SubCatCompanion({
    this.id = const Value.absent(),
    this.cacheId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  });
  SubCatCompanion.insert({
    this.id = const Value.absent(),
    this.cacheId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.image = const Value.absent(),
  }) : name = Value(name);
  static Insertable<SubCatData> custom({
    Expression<int>? id,
    Expression<String>? cacheId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? image,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cacheId != null) 'cache_id': cacheId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
    });
  }

  SubCatCompanion copyWith(
      {Value<int>? id,
      Value<String?>? cacheId,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? image}) {
    return SubCatCompanion(
      id: id ?? this.id,
      cacheId: cacheId ?? this.cacheId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cacheId.present) {
      map['cache_id'] = Variable<String>(cacheId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubCatCompanion(')
          ..write('id: $id, ')
          ..write('cacheId: $cacheId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $TodosTable todos = $TodosTable(this);
  late final $CategoryTable category = $CategoryTable(this);
  late final $SubCatTable subCat = $SubCatTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todos, category, subCat];
}
