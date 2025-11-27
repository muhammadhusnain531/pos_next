// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_service.dart';

// ignore_for_file: type=lint
class $CompaniesTable extends Companies
    with TableInfo<$CompaniesTable, Company> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactMeta =
      const VerificationMeta('contact');
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
      'contact', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, address, contact, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'companies';
  @override
  VerificationContext validateIntegrity(Insertable<Company> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('contact')) {
      context.handle(_contactMeta,
          contact.isAcceptableOrUnknown(data['contact']!, _contactMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Company map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Company(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      contact: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CompaniesTable createAlias(String alias) {
    return $CompaniesTable(attachedDatabase, alias);
  }
}

class Company extends DataClass implements Insertable<Company> {
  final int id;
  final String name;
  final String? address;
  final String? contact;
  final DateTime createdAt;
  const Company(
      {required this.id,
      required this.name,
      this.address,
      this.contact,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CompaniesCompanion toCompanion(bool nullToAbsent) {
    return CompaniesCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      createdAt: Value(createdAt),
    );
  }

  factory Company.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Company(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      contact: serializer.fromJson<String?>(json['contact']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'contact': serializer.toJson<String?>(contact),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Company copyWith(
          {int? id,
          String? name,
          Value<String?> address = const Value.absent(),
          Value<String?> contact = const Value.absent(),
          DateTime? createdAt}) =>
      Company(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address.present ? address.value : this.address,
        contact: contact.present ? contact.value : this.contact,
        createdAt: createdAt ?? this.createdAt,
      );
  Company copyWithCompanion(CompaniesCompanion data) {
    return Company(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      contact: data.contact.present ? data.contact.value : this.contact,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Company(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('contact: $contact, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, address, contact, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Company &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.contact == this.contact &&
          other.createdAt == this.createdAt);
}

class CompaniesCompanion extends UpdateCompanion<Company> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> contact;
  final Value<DateTime> createdAt;
  const CompaniesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.contact = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CompaniesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.contact = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Company> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? contact,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (contact != null) 'contact': contact,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CompaniesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? address,
      Value<String?>? contact,
      Value<DateTime>? createdAt}) {
    return CompaniesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompaniesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('contact: $contact, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BranchesTable extends Branches with TableInfo<$BranchesTable, Branche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BranchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _companyIdMeta =
      const VerificationMeta('companyId');
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
      'company_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES companies (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactMeta =
      const VerificationMeta('contact');
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
      'contact', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, companyId, name, address, contact, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'branches';
  @override
  VerificationContext validateIntegrity(Insertable<Branche> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_id')) {
      context.handle(_companyIdMeta,
          companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta));
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('contact')) {
      context.handle(_contactMeta,
          contact.isAcceptableOrUnknown(data['contact']!, _contactMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Branche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Branche(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      companyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}company_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      contact: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BranchesTable createAlias(String alias) {
    return $BranchesTable(attachedDatabase, alias);
  }
}

class Branche extends DataClass implements Insertable<Branche> {
  final int id;
  final int companyId;
  final String name;
  final String? address;
  final String? contact;
  final DateTime createdAt;
  const Branche(
      {required this.id,
      required this.companyId,
      required this.name,
      this.address,
      this.contact,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['company_id'] = Variable<int>(companyId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BranchesCompanion toCompanion(bool nullToAbsent) {
    return BranchesCompanion(
      id: Value(id),
      companyId: Value(companyId),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      createdAt: Value(createdAt),
    );
  }

  factory Branche.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Branche(
      id: serializer.fromJson<int>(json['id']),
      companyId: serializer.fromJson<int>(json['companyId']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      contact: serializer.fromJson<String?>(json['contact']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'companyId': serializer.toJson<int>(companyId),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'contact': serializer.toJson<String?>(contact),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Branche copyWith(
          {int? id,
          int? companyId,
          String? name,
          Value<String?> address = const Value.absent(),
          Value<String?> contact = const Value.absent(),
          DateTime? createdAt}) =>
      Branche(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        name: name ?? this.name,
        address: address.present ? address.value : this.address,
        contact: contact.present ? contact.value : this.contact,
        createdAt: createdAt ?? this.createdAt,
      );
  Branche copyWithCompanion(BranchesCompanion data) {
    return Branche(
      id: data.id.present ? data.id.value : this.id,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      contact: data.contact.present ? data.contact.value : this.contact,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Branche(')
          ..write('id: $id, ')
          ..write('companyId: $companyId, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('contact: $contact, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, companyId, name, address, contact, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Branche &&
          other.id == this.id &&
          other.companyId == this.companyId &&
          other.name == this.name &&
          other.address == this.address &&
          other.contact == this.contact &&
          other.createdAt == this.createdAt);
}

class BranchesCompanion extends UpdateCompanion<Branche> {
  final Value<int> id;
  final Value<int> companyId;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> contact;
  final Value<DateTime> createdAt;
  const BranchesCompanion({
    this.id = const Value.absent(),
    this.companyId = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.contact = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BranchesCompanion.insert({
    this.id = const Value.absent(),
    required int companyId,
    required String name,
    this.address = const Value.absent(),
    this.contact = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : companyId = Value(companyId),
        name = Value(name);
  static Insertable<Branche> custom({
    Expression<int>? id,
    Expression<int>? companyId,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? contact,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyId != null) 'company_id': companyId,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (contact != null) 'contact': contact,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BranchesCompanion copyWith(
      {Value<int>? id,
      Value<int>? companyId,
      Value<String>? name,
      Value<String?>? address,
      Value<String?>? contact,
      Value<DateTime>? createdAt}) {
    return BranchesCompanion(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BranchesCompanion(')
          ..write('id: $id, ')
          ..write('companyId: $companyId, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('contact: $contact, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _branchIdMeta =
      const VerificationMeta('branchId');
  @override
  late final GeneratedColumn<int> branchId = GeneratedColumn<int>(
      'branch_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES branches (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('In Stock'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, branchId, name, barcode, category, quantity, price, sku, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      branchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}branch_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final int branchId;
  final String name;
  final String barcode;
  final String? category;
  final int quantity;
  final double price;
  final String? sku;
  final String status;
  const Product(
      {required this.id,
      required this.branchId,
      required this.name,
      required this.barcode,
      this.category,
      required this.quantity,
      required this.price,
      this.sku,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['branch_id'] = Variable<int>(branchId);
    map['name'] = Variable<String>(name);
    map['barcode'] = Variable<String>(barcode);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      branchId: Value(branchId),
      name: Value(name),
      barcode: Value(barcode),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      quantity: Value(quantity),
      price: Value(price),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      status: Value(status),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      branchId: serializer.fromJson<int>(json['branchId']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String>(json['barcode']),
      category: serializer.fromJson<String?>(json['category']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      sku: serializer.fromJson<String?>(json['sku']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'branchId': serializer.toJson<int>(branchId),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String>(barcode),
      'category': serializer.toJson<String?>(category),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
      'sku': serializer.toJson<String?>(sku),
      'status': serializer.toJson<String>(status),
    };
  }

  Product copyWith(
          {int? id,
          int? branchId,
          String? name,
          String? barcode,
          Value<String?> category = const Value.absent(),
          int? quantity,
          double? price,
          Value<String?> sku = const Value.absent(),
          String? status}) =>
      Product(
        id: id ?? this.id,
        branchId: branchId ?? this.branchId,
        name: name ?? this.name,
        barcode: barcode ?? this.barcode,
        category: category.present ? category.value : this.category,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        sku: sku.present ? sku.value : this.sku,
        status: status ?? this.status,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      sku: data.sku.present ? data.sku.value : this.sku,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('sku: $sku, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, branchId, name, barcode, category, quantity, price, sku, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.sku == this.sku &&
          other.status == this.status);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<int> branchId;
  final Value<String> name;
  final Value<String> barcode;
  final Value<String?> category;
  final Value<int> quantity;
  final Value<double> price;
  final Value<String?> sku;
  final Value<String> status;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.sku = const Value.absent(),
    this.status = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required int branchId,
    required String name,
    required String barcode,
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    required double price,
    this.sku = const Value.absent(),
    this.status = const Value.absent(),
  })  : branchId = Value(branchId),
        name = Value(name),
        barcode = Value(barcode),
        price = Value(price);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<int>? branchId,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<String>? category,
    Expression<int>? quantity,
    Expression<double>? price,
    Expression<String>? sku,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (sku != null) 'sku': sku,
      if (status != null) 'status': status,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<int>? branchId,
      Value<String>? name,
      Value<String>? barcode,
      Value<String?>? category,
      Value<int>? quantity,
      Value<double>? price,
      Value<String?>? sku,
      Value<String>? status}) {
    return ProductsCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      sku: sku ?? this.sku,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<int>(branchId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('sku: $sku, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _branchIdMeta =
      const VerificationMeta('branchId');
  @override
  late final GeneratedColumn<int> branchId = GeneratedColumn<int>(
      'branch_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES branches (id)'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, branchId, username, password, role, name, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      branchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}branch_id']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final int? branchId;
  final String username;
  final String password;
  final String role;
  final String? name;
  final bool isActive;
  const User(
      {required this.id,
      this.branchId,
      required this.username,
      required this.password,
      required this.role,
      this.name,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<int>(branchId);
    }
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      username: Value(username),
      password: Value(password),
      role: Value(role),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isActive: Value(isActive),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      branchId: serializer.fromJson<int?>(json['branchId']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
      name: serializer.fromJson<String?>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'branchId': serializer.toJson<int?>(branchId),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
      'name': serializer.toJson<String?>(name),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  User copyWith(
          {int? id,
          Value<int?> branchId = const Value.absent(),
          String? username,
          String? password,
          String? role,
          Value<String?> name = const Value.absent(),
          bool? isActive}) =>
      User(
        id: id ?? this.id,
        branchId: branchId.present ? branchId.value : this.branchId,
        username: username ?? this.username,
        password: password ?? this.password,
        role: role ?? this.role,
        name: name.present ? name.value : this.name,
        isActive: isActive ?? this.isActive,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, branchId, username, password, role, name, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.username == this.username &&
          other.password == this.password &&
          other.role == this.role &&
          other.name == this.name &&
          other.isActive == this.isActive);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<int?> branchId;
  final Value<String> username;
  final Value<String> password;
  final Value<String> role;
  final Value<String?> name;
  final Value<bool> isActive;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    required String username,
    required String password,
    required String role,
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : username = Value(username),
        password = Value(password),
        role = Value(role);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<int>? branchId,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? role,
    Expression<String>? name,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<int?>? branchId,
      Value<String>? username,
      Value<String>? password,
      Value<String>? role,
      Value<String?>? name,
      Value<bool>? isActive}) {
    return UsersCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<int>(branchId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _branchIdMeta =
      const VerificationMeta('branchId');
  @override
  late final GeneratedColumn<int> branchId = GeneratedColumn<int>(
      'branch_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES branches (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        branchId,
        userId,
        invoiceNumber,
        totalAmount,
        discount,
        paymentMethod,
        date
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<Sale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      branchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}branch_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final int branchId;
  final int? userId;
  final String invoiceNumber;
  final double totalAmount;
  final double discount;
  final String paymentMethod;
  final DateTime date;
  const Sale(
      {required this.id,
      required this.branchId,
      this.userId,
      required this.invoiceNumber,
      required this.totalAmount,
      required this.discount,
      required this.paymentMethod,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['branch_id'] = Variable<int>(branchId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['total_amount'] = Variable<double>(totalAmount);
    map['discount'] = Variable<double>(discount);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      branchId: Value(branchId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      invoiceNumber: Value(invoiceNumber),
      totalAmount: Value(totalAmount),
      discount: Value(discount),
      paymentMethod: Value(paymentMethod),
      date: Value(date),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      branchId: serializer.fromJson<int>(json['branchId']),
      userId: serializer.fromJson<int?>(json['userId']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      discount: serializer.fromJson<double>(json['discount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'branchId': serializer.toJson<int>(branchId),
      'userId': serializer.toJson<int?>(userId),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'discount': serializer.toJson<double>(discount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  Sale copyWith(
          {int? id,
          int? branchId,
          Value<int?> userId = const Value.absent(),
          String? invoiceNumber,
          double? totalAmount,
          double? discount,
          String? paymentMethod,
          DateTime? date}) =>
      Sale(
        id: id ?? this.id,
        branchId: branchId ?? this.branchId,
        userId: userId.present ? userId.value : this.userId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        totalAmount: totalAmount ?? this.totalAmount,
        discount: discount ?? this.discount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        date: date ?? this.date,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      userId: data.userId.present ? data.userId.value : this.userId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      discount: data.discount.present ? data.discount.value : this.discount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('userId: $userId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discount: $discount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, branchId, userId, invoiceNumber,
      totalAmount, discount, paymentMethod, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.userId == this.userId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.totalAmount == this.totalAmount &&
          other.discount == this.discount &&
          other.paymentMethod == this.paymentMethod &&
          other.date == this.date);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<int> branchId;
  final Value<int?> userId;
  final Value<String> invoiceNumber;
  final Value<double> totalAmount;
  final Value<double> discount;
  final Value<String> paymentMethod;
  final Value<DateTime> date;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.userId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.discount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.date = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required int branchId,
    this.userId = const Value.absent(),
    required String invoiceNumber,
    required double totalAmount,
    this.discount = const Value.absent(),
    required String paymentMethod,
    this.date = const Value.absent(),
  })  : branchId = Value(branchId),
        invoiceNumber = Value(invoiceNumber),
        totalAmount = Value(totalAmount),
        paymentMethod = Value(paymentMethod);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<int>? branchId,
    Expression<int>? userId,
    Expression<String>? invoiceNumber,
    Expression<double>? totalAmount,
    Expression<double>? discount,
    Expression<String>? paymentMethod,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (userId != null) 'user_id': userId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (discount != null) 'discount': discount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (date != null) 'date': date,
    });
  }

  SalesCompanion copyWith(
      {Value<int>? id,
      Value<int>? branchId,
      Value<int?>? userId,
      Value<String>? invoiceNumber,
      Value<double>? totalAmount,
      Value<double>? discount,
      Value<String>? paymentMethod,
      Value<DateTime>? date}) {
    return SalesCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      userId: userId ?? this.userId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      discount: discount ?? this.discount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<int>(branchId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('userId: $userId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discount: $discount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sales (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, saleId, productId, quantity, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(Insertable<SaleItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final int id;
  final int saleId;
  final int productId;
  final int quantity;
  final double price;
  const SaleItem(
      {required this.id,
      required this.saleId,
      required this.productId,
      required this.quantity,
      required this.price});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      quantity: Value(quantity),
      price: Value(price),
    );
  }

  factory SaleItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
    };
  }

  SaleItem copyWith(
          {int? id,
          int? saleId,
          int? productId,
          int? quantity,
          double? price}) =>
      SaleItem(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
      );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, saleId, productId, quantity, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.price == this.price);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<int> productId;
  final Value<int> quantity;
  final Value<double> price;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required int productId,
    required int quantity,
    required double price,
  })  : saleId = Value(saleId),
        productId = Value(productId),
        quantity = Value(quantity),
        price = Value(price);
  static Insertable<SaleItem> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<int>? productId,
    Expression<int>? quantity,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
    });
  }

  SaleItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? saleId,
      Value<int>? productId,
      Value<int>? quantity,
      Value<double>? price}) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $BusinessDaysTable extends BusinessDays
    with TableInfo<$BusinessDaysTable, BusinessDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _branchIdMeta =
      const VerificationMeta('branchId');
  @override
  late final GeneratedColumn<int> branchId = GeneratedColumn<int>(
      'branch_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES branches (id)'));
  static const VerificationMeta _openTimeMeta =
      const VerificationMeta('openTime');
  @override
  late final GeneratedColumn<DateTime> openTime = GeneratedColumn<DateTime>(
      'open_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _closeTimeMeta =
      const VerificationMeta('closeTime');
  @override
  late final GeneratedColumn<DateTime> closeTime = GeneratedColumn<DateTime>(
      'close_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _openingBalanceMeta =
      const VerificationMeta('openingBalance');
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
      'opening_balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _closingBalanceMeta =
      const VerificationMeta('closingBalance');
  @override
  late final GeneratedColumn<double> closingBalance = GeneratedColumn<double>(
      'closing_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _totalCashSalesMeta =
      const VerificationMeta('totalCashSales');
  @override
  late final GeneratedColumn<double> totalCashSales = GeneratedColumn<double>(
      'total_cash_sales', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalCardSalesMeta =
      const VerificationMeta('totalCardSales');
  @override
  late final GeneratedColumn<double> totalCardSales = GeneratedColumn<double>(
      'total_card_sales', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalGiftCardSalesMeta =
      const VerificationMeta('totalGiftCardSales');
  @override
  late final GeneratedColumn<double> totalGiftCardSales =
      GeneratedColumn<double>('total_gift_card_sales', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _totalOtherSalesMeta =
      const VerificationMeta('totalOtherSales');
  @override
  late final GeneratedColumn<double> totalOtherSales = GeneratedColumn<double>(
      'total_other_sales', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Open'));
  static const VerificationMeta _openedByMeta =
      const VerificationMeta('openedBy');
  @override
  late final GeneratedColumn<String> openedBy = GeneratedColumn<String>(
      'opened_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _closedByMeta =
      const VerificationMeta('closedBy');
  @override
  late final GeneratedColumn<String> closedBy = GeneratedColumn<String>(
      'closed_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _discrepancyMeta =
      const VerificationMeta('discrepancy');
  @override
  late final GeneratedColumn<double> discrepancy = GeneratedColumn<double>(
      'discrepancy', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        branchId,
        openTime,
        closeTime,
        openingBalance,
        closingBalance,
        totalCashSales,
        totalCardSales,
        totalGiftCardSales,
        totalOtherSales,
        status,
        openedBy,
        closedBy,
        discrepancy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_days';
  @override
  VerificationContext validateIntegrity(Insertable<BusinessDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta));
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('open_time')) {
      context.handle(_openTimeMeta,
          openTime.isAcceptableOrUnknown(data['open_time']!, _openTimeMeta));
    }
    if (data.containsKey('close_time')) {
      context.handle(_closeTimeMeta,
          closeTime.isAcceptableOrUnknown(data['close_time']!, _closeTimeMeta));
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
          _openingBalanceMeta,
          openingBalance.isAcceptableOrUnknown(
              data['opening_balance']!, _openingBalanceMeta));
    } else if (isInserting) {
      context.missing(_openingBalanceMeta);
    }
    if (data.containsKey('closing_balance')) {
      context.handle(
          _closingBalanceMeta,
          closingBalance.isAcceptableOrUnknown(
              data['closing_balance']!, _closingBalanceMeta));
    }
    if (data.containsKey('total_cash_sales')) {
      context.handle(
          _totalCashSalesMeta,
          totalCashSales.isAcceptableOrUnknown(
              data['total_cash_sales']!, _totalCashSalesMeta));
    }
    if (data.containsKey('total_card_sales')) {
      context.handle(
          _totalCardSalesMeta,
          totalCardSales.isAcceptableOrUnknown(
              data['total_card_sales']!, _totalCardSalesMeta));
    }
    if (data.containsKey('total_gift_card_sales')) {
      context.handle(
          _totalGiftCardSalesMeta,
          totalGiftCardSales.isAcceptableOrUnknown(
              data['total_gift_card_sales']!, _totalGiftCardSalesMeta));
    }
    if (data.containsKey('total_other_sales')) {
      context.handle(
          _totalOtherSalesMeta,
          totalOtherSales.isAcceptableOrUnknown(
              data['total_other_sales']!, _totalOtherSalesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('opened_by')) {
      context.handle(_openedByMeta,
          openedBy.isAcceptableOrUnknown(data['opened_by']!, _openedByMeta));
    }
    if (data.containsKey('closed_by')) {
      context.handle(_closedByMeta,
          closedBy.isAcceptableOrUnknown(data['closed_by']!, _closedByMeta));
    }
    if (data.containsKey('discrepancy')) {
      context.handle(
          _discrepancyMeta,
          discrepancy.isAcceptableOrUnknown(
              data['discrepancy']!, _discrepancyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessDay(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      branchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}branch_id'])!,
      openTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}open_time'])!,
      closeTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}close_time']),
      openingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}opening_balance'])!,
      closingBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}closing_balance']),
      totalCashSales: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_cash_sales'])!,
      totalCardSales: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_card_sales'])!,
      totalGiftCardSales: attachedDatabase.typeMapping.read(DriftSqlType.double,
          data['${effectivePrefix}total_gift_card_sales'])!,
      totalOtherSales: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_other_sales'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      openedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}opened_by']),
      closedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}closed_by']),
      discrepancy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discrepancy']),
    );
  }

  @override
  $BusinessDaysTable createAlias(String alias) {
    return $BusinessDaysTable(attachedDatabase, alias);
  }
}

class BusinessDay extends DataClass implements Insertable<BusinessDay> {
  final int id;
  final int branchId;
  final DateTime openTime;
  final DateTime? closeTime;
  final double openingBalance;
  final double? closingBalance;
  final double totalCashSales;
  final double totalCardSales;
  final double totalGiftCardSales;
  final double totalOtherSales;
  final String status;
  final String? openedBy;
  final String? closedBy;
  final double? discrepancy;
  const BusinessDay(
      {required this.id,
      required this.branchId,
      required this.openTime,
      this.closeTime,
      required this.openingBalance,
      this.closingBalance,
      required this.totalCashSales,
      required this.totalCardSales,
      required this.totalGiftCardSales,
      required this.totalOtherSales,
      required this.status,
      this.openedBy,
      this.closedBy,
      this.discrepancy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['branch_id'] = Variable<int>(branchId);
    map['open_time'] = Variable<DateTime>(openTime);
    if (!nullToAbsent || closeTime != null) {
      map['close_time'] = Variable<DateTime>(closeTime);
    }
    map['opening_balance'] = Variable<double>(openingBalance);
    if (!nullToAbsent || closingBalance != null) {
      map['closing_balance'] = Variable<double>(closingBalance);
    }
    map['total_cash_sales'] = Variable<double>(totalCashSales);
    map['total_card_sales'] = Variable<double>(totalCardSales);
    map['total_gift_card_sales'] = Variable<double>(totalGiftCardSales);
    map['total_other_sales'] = Variable<double>(totalOtherSales);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || openedBy != null) {
      map['opened_by'] = Variable<String>(openedBy);
    }
    if (!nullToAbsent || closedBy != null) {
      map['closed_by'] = Variable<String>(closedBy);
    }
    if (!nullToAbsent || discrepancy != null) {
      map['discrepancy'] = Variable<double>(discrepancy);
    }
    return map;
  }

  BusinessDaysCompanion toCompanion(bool nullToAbsent) {
    return BusinessDaysCompanion(
      id: Value(id),
      branchId: Value(branchId),
      openTime: Value(openTime),
      closeTime: closeTime == null && nullToAbsent
          ? const Value.absent()
          : Value(closeTime),
      openingBalance: Value(openingBalance),
      closingBalance: closingBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(closingBalance),
      totalCashSales: Value(totalCashSales),
      totalCardSales: Value(totalCardSales),
      totalGiftCardSales: Value(totalGiftCardSales),
      totalOtherSales: Value(totalOtherSales),
      status: Value(status),
      openedBy: openedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(openedBy),
      closedBy: closedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(closedBy),
      discrepancy: discrepancy == null && nullToAbsent
          ? const Value.absent()
          : Value(discrepancy),
    );
  }

  factory BusinessDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessDay(
      id: serializer.fromJson<int>(json['id']),
      branchId: serializer.fromJson<int>(json['branchId']),
      openTime: serializer.fromJson<DateTime>(json['openTime']),
      closeTime: serializer.fromJson<DateTime?>(json['closeTime']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      closingBalance: serializer.fromJson<double?>(json['closingBalance']),
      totalCashSales: serializer.fromJson<double>(json['totalCashSales']),
      totalCardSales: serializer.fromJson<double>(json['totalCardSales']),
      totalGiftCardSales:
          serializer.fromJson<double>(json['totalGiftCardSales']),
      totalOtherSales: serializer.fromJson<double>(json['totalOtherSales']),
      status: serializer.fromJson<String>(json['status']),
      openedBy: serializer.fromJson<String?>(json['openedBy']),
      closedBy: serializer.fromJson<String?>(json['closedBy']),
      discrepancy: serializer.fromJson<double?>(json['discrepancy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'branchId': serializer.toJson<int>(branchId),
      'openTime': serializer.toJson<DateTime>(openTime),
      'closeTime': serializer.toJson<DateTime?>(closeTime),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'closingBalance': serializer.toJson<double?>(closingBalance),
      'totalCashSales': serializer.toJson<double>(totalCashSales),
      'totalCardSales': serializer.toJson<double>(totalCardSales),
      'totalGiftCardSales': serializer.toJson<double>(totalGiftCardSales),
      'totalOtherSales': serializer.toJson<double>(totalOtherSales),
      'status': serializer.toJson<String>(status),
      'openedBy': serializer.toJson<String?>(openedBy),
      'closedBy': serializer.toJson<String?>(closedBy),
      'discrepancy': serializer.toJson<double?>(discrepancy),
    };
  }

  BusinessDay copyWith(
          {int? id,
          int? branchId,
          DateTime? openTime,
          Value<DateTime?> closeTime = const Value.absent(),
          double? openingBalance,
          Value<double?> closingBalance = const Value.absent(),
          double? totalCashSales,
          double? totalCardSales,
          double? totalGiftCardSales,
          double? totalOtherSales,
          String? status,
          Value<String?> openedBy = const Value.absent(),
          Value<String?> closedBy = const Value.absent(),
          Value<double?> discrepancy = const Value.absent()}) =>
      BusinessDay(
        id: id ?? this.id,
        branchId: branchId ?? this.branchId,
        openTime: openTime ?? this.openTime,
        closeTime: closeTime.present ? closeTime.value : this.closeTime,
        openingBalance: openingBalance ?? this.openingBalance,
        closingBalance:
            closingBalance.present ? closingBalance.value : this.closingBalance,
        totalCashSales: totalCashSales ?? this.totalCashSales,
        totalCardSales: totalCardSales ?? this.totalCardSales,
        totalGiftCardSales: totalGiftCardSales ?? this.totalGiftCardSales,
        totalOtherSales: totalOtherSales ?? this.totalOtherSales,
        status: status ?? this.status,
        openedBy: openedBy.present ? openedBy.value : this.openedBy,
        closedBy: closedBy.present ? closedBy.value : this.closedBy,
        discrepancy: discrepancy.present ? discrepancy.value : this.discrepancy,
      );
  BusinessDay copyWithCompanion(BusinessDaysCompanion data) {
    return BusinessDay(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      openTime: data.openTime.present ? data.openTime.value : this.openTime,
      closeTime: data.closeTime.present ? data.closeTime.value : this.closeTime,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      closingBalance: data.closingBalance.present
          ? data.closingBalance.value
          : this.closingBalance,
      totalCashSales: data.totalCashSales.present
          ? data.totalCashSales.value
          : this.totalCashSales,
      totalCardSales: data.totalCardSales.present
          ? data.totalCardSales.value
          : this.totalCardSales,
      totalGiftCardSales: data.totalGiftCardSales.present
          ? data.totalGiftCardSales.value
          : this.totalGiftCardSales,
      totalOtherSales: data.totalOtherSales.present
          ? data.totalOtherSales.value
          : this.totalOtherSales,
      status: data.status.present ? data.status.value : this.status,
      openedBy: data.openedBy.present ? data.openedBy.value : this.openedBy,
      closedBy: data.closedBy.present ? data.closedBy.value : this.closedBy,
      discrepancy:
          data.discrepancy.present ? data.discrepancy.value : this.discrepancy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessDay(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('openTime: $openTime, ')
          ..write('closeTime: $closeTime, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('closingBalance: $closingBalance, ')
          ..write('totalCashSales: $totalCashSales, ')
          ..write('totalCardSales: $totalCardSales, ')
          ..write('totalGiftCardSales: $totalGiftCardSales, ')
          ..write('totalOtherSales: $totalOtherSales, ')
          ..write('status: $status, ')
          ..write('openedBy: $openedBy, ')
          ..write('closedBy: $closedBy, ')
          ..write('discrepancy: $discrepancy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      branchId,
      openTime,
      closeTime,
      openingBalance,
      closingBalance,
      totalCashSales,
      totalCardSales,
      totalGiftCardSales,
      totalOtherSales,
      status,
      openedBy,
      closedBy,
      discrepancy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessDay &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.openTime == this.openTime &&
          other.closeTime == this.closeTime &&
          other.openingBalance == this.openingBalance &&
          other.closingBalance == this.closingBalance &&
          other.totalCashSales == this.totalCashSales &&
          other.totalCardSales == this.totalCardSales &&
          other.totalGiftCardSales == this.totalGiftCardSales &&
          other.totalOtherSales == this.totalOtherSales &&
          other.status == this.status &&
          other.openedBy == this.openedBy &&
          other.closedBy == this.closedBy &&
          other.discrepancy == this.discrepancy);
}

class BusinessDaysCompanion extends UpdateCompanion<BusinessDay> {
  final Value<int> id;
  final Value<int> branchId;
  final Value<DateTime> openTime;
  final Value<DateTime?> closeTime;
  final Value<double> openingBalance;
  final Value<double?> closingBalance;
  final Value<double> totalCashSales;
  final Value<double> totalCardSales;
  final Value<double> totalGiftCardSales;
  final Value<double> totalOtherSales;
  final Value<String> status;
  final Value<String?> openedBy;
  final Value<String?> closedBy;
  final Value<double?> discrepancy;
  const BusinessDaysCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.openTime = const Value.absent(),
    this.closeTime = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.closingBalance = const Value.absent(),
    this.totalCashSales = const Value.absent(),
    this.totalCardSales = const Value.absent(),
    this.totalGiftCardSales = const Value.absent(),
    this.totalOtherSales = const Value.absent(),
    this.status = const Value.absent(),
    this.openedBy = const Value.absent(),
    this.closedBy = const Value.absent(),
    this.discrepancy = const Value.absent(),
  });
  BusinessDaysCompanion.insert({
    this.id = const Value.absent(),
    required int branchId,
    this.openTime = const Value.absent(),
    this.closeTime = const Value.absent(),
    required double openingBalance,
    this.closingBalance = const Value.absent(),
    this.totalCashSales = const Value.absent(),
    this.totalCardSales = const Value.absent(),
    this.totalGiftCardSales = const Value.absent(),
    this.totalOtherSales = const Value.absent(),
    this.status = const Value.absent(),
    this.openedBy = const Value.absent(),
    this.closedBy = const Value.absent(),
    this.discrepancy = const Value.absent(),
  })  : branchId = Value(branchId),
        openingBalance = Value(openingBalance);
  static Insertable<BusinessDay> custom({
    Expression<int>? id,
    Expression<int>? branchId,
    Expression<DateTime>? openTime,
    Expression<DateTime>? closeTime,
    Expression<double>? openingBalance,
    Expression<double>? closingBalance,
    Expression<double>? totalCashSales,
    Expression<double>? totalCardSales,
    Expression<double>? totalGiftCardSales,
    Expression<double>? totalOtherSales,
    Expression<String>? status,
    Expression<String>? openedBy,
    Expression<String>? closedBy,
    Expression<double>? discrepancy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (openTime != null) 'open_time': openTime,
      if (closeTime != null) 'close_time': closeTime,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (closingBalance != null) 'closing_balance': closingBalance,
      if (totalCashSales != null) 'total_cash_sales': totalCashSales,
      if (totalCardSales != null) 'total_card_sales': totalCardSales,
      if (totalGiftCardSales != null)
        'total_gift_card_sales': totalGiftCardSales,
      if (totalOtherSales != null) 'total_other_sales': totalOtherSales,
      if (status != null) 'status': status,
      if (openedBy != null) 'opened_by': openedBy,
      if (closedBy != null) 'closed_by': closedBy,
      if (discrepancy != null) 'discrepancy': discrepancy,
    });
  }

  BusinessDaysCompanion copyWith(
      {Value<int>? id,
      Value<int>? branchId,
      Value<DateTime>? openTime,
      Value<DateTime?>? closeTime,
      Value<double>? openingBalance,
      Value<double?>? closingBalance,
      Value<double>? totalCashSales,
      Value<double>? totalCardSales,
      Value<double>? totalGiftCardSales,
      Value<double>? totalOtherSales,
      Value<String>? status,
      Value<String?>? openedBy,
      Value<String?>? closedBy,
      Value<double?>? discrepancy}) {
    return BusinessDaysCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      openingBalance: openingBalance ?? this.openingBalance,
      closingBalance: closingBalance ?? this.closingBalance,
      totalCashSales: totalCashSales ?? this.totalCashSales,
      totalCardSales: totalCardSales ?? this.totalCardSales,
      totalGiftCardSales: totalGiftCardSales ?? this.totalGiftCardSales,
      totalOtherSales: totalOtherSales ?? this.totalOtherSales,
      status: status ?? this.status,
      openedBy: openedBy ?? this.openedBy,
      closedBy: closedBy ?? this.closedBy,
      discrepancy: discrepancy ?? this.discrepancy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<int>(branchId.value);
    }
    if (openTime.present) {
      map['open_time'] = Variable<DateTime>(openTime.value);
    }
    if (closeTime.present) {
      map['close_time'] = Variable<DateTime>(closeTime.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (closingBalance.present) {
      map['closing_balance'] = Variable<double>(closingBalance.value);
    }
    if (totalCashSales.present) {
      map['total_cash_sales'] = Variable<double>(totalCashSales.value);
    }
    if (totalCardSales.present) {
      map['total_card_sales'] = Variable<double>(totalCardSales.value);
    }
    if (totalGiftCardSales.present) {
      map['total_gift_card_sales'] = Variable<double>(totalGiftCardSales.value);
    }
    if (totalOtherSales.present) {
      map['total_other_sales'] = Variable<double>(totalOtherSales.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (openedBy.present) {
      map['opened_by'] = Variable<String>(openedBy.value);
    }
    if (closedBy.present) {
      map['closed_by'] = Variable<String>(closedBy.value);
    }
    if (discrepancy.present) {
      map['discrepancy'] = Variable<double>(discrepancy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessDaysCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('openTime: $openTime, ')
          ..write('closeTime: $closeTime, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('closingBalance: $closingBalance, ')
          ..write('totalCashSales: $totalCashSales, ')
          ..write('totalCardSales: $totalCardSales, ')
          ..write('totalGiftCardSales: $totalGiftCardSales, ')
          ..write('totalOtherSales: $totalOtherSales, ')
          ..write('status: $status, ')
          ..write('openedBy: $openedBy, ')
          ..write('closedBy: $closedBy, ')
          ..write('discrepancy: $discrepancy')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CompaniesTable companies = $CompaniesTable(this);
  late final $BranchesTable branches = $BranchesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $BusinessDaysTable businessDays = $BusinessDaysTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [companies, branches, products, users, sales, saleItems, businessDays];
}

typedef $$CompaniesTableCreateCompanionBuilder = CompaniesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> address,
  Value<String?> contact,
  Value<DateTime> createdAt,
});
typedef $$CompaniesTableUpdateCompanionBuilder = CompaniesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> address,
  Value<String?> contact,
  Value<DateTime> createdAt,
});

final class $$CompaniesTableReferences
    extends BaseReferences<_$AppDatabase, $CompaniesTable, Company> {
  $$CompaniesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BranchesTable, List<Branche>> _branchesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.branches,
          aliasName:
              $_aliasNameGenerator(db.companies.id, db.branches.companyId));

  $$BranchesTableProcessedTableManager get branchesRefs {
    final manager = $$BranchesTableTableManager($_db, $_db.branches)
        .filter((f) => f.companyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_branchesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> branchesRefs(
      Expression<bool> Function($$BranchesTableFilterComposer f) f) {
    final $$BranchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.companyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableFilterComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> branchesRefs<T extends Object>(
      Expression<T> Function($$BranchesTableAnnotationComposer a) f) {
    final $$BranchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.companyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableAnnotationComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CompaniesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CompaniesTable,
    Company,
    $$CompaniesTableFilterComposer,
    $$CompaniesTableOrderingComposer,
    $$CompaniesTableAnnotationComposer,
    $$CompaniesTableCreateCompanionBuilder,
    $$CompaniesTableUpdateCompanionBuilder,
    (Company, $$CompaniesTableReferences),
    Company,
    PrefetchHooks Function({bool branchesRefs})> {
  $$CompaniesTableTableManager(_$AppDatabase db, $CompaniesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompaniesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> contact = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CompaniesCompanion(
            id: id,
            name: name,
            address: address,
            contact: contact,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> address = const Value.absent(),
            Value<String?> contact = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CompaniesCompanion.insert(
            id: id,
            name: name,
            address: address,
            contact: contact,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CompaniesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({branchesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (branchesRefs) db.branches],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (branchesRefs)
                    await $_getPrefetchedData<Company, $CompaniesTable,
                            Branche>(
                        currentTable: table,
                        referencedTable:
                            $$CompaniesTableReferences._branchesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CompaniesTableReferences(db, table, p0)
                                .branchesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.companyId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CompaniesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CompaniesTable,
    Company,
    $$CompaniesTableFilterComposer,
    $$CompaniesTableOrderingComposer,
    $$CompaniesTableAnnotationComposer,
    $$CompaniesTableCreateCompanionBuilder,
    $$CompaniesTableUpdateCompanionBuilder,
    (Company, $$CompaniesTableReferences),
    Company,
    PrefetchHooks Function({bool branchesRefs})>;
typedef $$BranchesTableCreateCompanionBuilder = BranchesCompanion Function({
  Value<int> id,
  required int companyId,
  required String name,
  Value<String?> address,
  Value<String?> contact,
  Value<DateTime> createdAt,
});
typedef $$BranchesTableUpdateCompanionBuilder = BranchesCompanion Function({
  Value<int> id,
  Value<int> companyId,
  Value<String> name,
  Value<String?> address,
  Value<String?> contact,
  Value<DateTime> createdAt,
});

final class $$BranchesTableReferences
    extends BaseReferences<_$AppDatabase, $BranchesTable, Branche> {
  $$BranchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias(
          $_aliasNameGenerator(db.branches.companyId, db.companies.id));

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<int>('company_id')!;

    final manager = $$CompaniesTableTableManager($_db, $_db.companies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.products,
          aliasName:
              $_aliasNameGenerator(db.branches.id, db.products.branchId));

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.branchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UsersTable, List<User>> _usersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.users,
          aliasName: $_aliasNameGenerator(db.branches.id, db.users.branchId));

  $$UsersTableProcessedTableManager get usersRefs {
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.branchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_usersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sales,
          aliasName: $_aliasNameGenerator(db.branches.id, db.sales.branchId));

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.branchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BusinessDaysTable, List<BusinessDay>>
      _businessDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.businessDays,
          aliasName:
              $_aliasNameGenerator(db.branches.id, db.businessDays.branchId));

  $$BusinessDaysTableProcessedTableManager get businessDaysRefs {
    final manager = $$BusinessDaysTableTableManager($_db, $_db.businessDays)
        .filter((f) => f.branchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_businessDaysRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BranchesTableFilterComposer
    extends Composer<_$AppDatabase, $BranchesTable> {
  $$BranchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.companyId,
        referencedTable: $db.companies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CompaniesTableFilterComposer(
              $db: $db,
              $table: $db.companies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> productsRefs(
      Expression<bool> Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.branchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> usersRefs(
      Expression<bool> Function($$UsersTableFilterComposer f) f) {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.branchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> salesRefs(
      Expression<bool> Function($$SalesTableFilterComposer f) f) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.branchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> businessDaysRefs(
      Expression<bool> Function($$BusinessDaysTableFilterComposer f) f) {
    final $$BusinessDaysTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.businessDays,
        getReferencedColumn: (t) => t.branchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BusinessDaysTableFilterComposer(
              $db: $db,
              $table: $db.businessDays,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BranchesTableOrderingComposer
    extends Composer<_$AppDatabase, $BranchesTable> {
  $$BranchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.companyId,
        referencedTable: $db.companies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CompaniesTableOrderingComposer(
              $db: $db,
              $table: $db.companies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BranchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BranchesTable> {
  $$BranchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.companyId,
        referencedTable: $db.companies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CompaniesTableAnnotationComposer(
              $db: $db,
              $table: $db.companies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> productsRefs<T extends Object>(
      Expression<T> Function($$ProductsTableAnnotationComposer a) f) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.branchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> usersRefs<T extends Object>(
      Expression<T> Function($$UsersTableAnnotationComposer a) f) {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.branchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> salesRefs<T extends Object>(
      Expression<T> Function($$SalesTableAnnotationComposer a) f) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.branchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> businessDaysRefs<T extends Object>(
      Expression<T> Function($$BusinessDaysTableAnnotationComposer a) f) {
    final $$BusinessDaysTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.businessDays,
        getReferencedColumn: (t) => t.branchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BusinessDaysTableAnnotationComposer(
              $db: $db,
              $table: $db.businessDays,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BranchesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BranchesTable,
    Branche,
    $$BranchesTableFilterComposer,
    $$BranchesTableOrderingComposer,
    $$BranchesTableAnnotationComposer,
    $$BranchesTableCreateCompanionBuilder,
    $$BranchesTableUpdateCompanionBuilder,
    (Branche, $$BranchesTableReferences),
    Branche,
    PrefetchHooks Function(
        {bool companyId,
        bool productsRefs,
        bool usersRefs,
        bool salesRefs,
        bool businessDaysRefs})> {
  $$BranchesTableTableManager(_$AppDatabase db, $BranchesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BranchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BranchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BranchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> companyId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> contact = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BranchesCompanion(
            id: id,
            companyId: companyId,
            name: name,
            address: address,
            contact: contact,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int companyId,
            required String name,
            Value<String?> address = const Value.absent(),
            Value<String?> contact = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BranchesCompanion.insert(
            id: id,
            companyId: companyId,
            name: name,
            address: address,
            contact: contact,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BranchesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {companyId = false,
              productsRefs = false,
              usersRefs = false,
              salesRefs = false,
              businessDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productsRefs) db.products,
                if (usersRefs) db.users,
                if (salesRefs) db.sales,
                if (businessDaysRefs) db.businessDays
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (companyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.companyId,
                    referencedTable:
                        $$BranchesTableReferences._companyIdTable(db),
                    referencedColumn:
                        $$BranchesTableReferences._companyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<Branche, $BranchesTable, Product>(
                        currentTable: table,
                        referencedTable:
                            $$BranchesTableReferences._productsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BranchesTableReferences(db, table, p0)
                                .productsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.branchId == item.id),
                        typedResults: items),
                  if (usersRefs)
                    await $_getPrefetchedData<Branche, $BranchesTable, User>(
                        currentTable: table,
                        referencedTable:
                            $$BranchesTableReferences._usersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BranchesTableReferences(db, table, p0).usersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.branchId == item.id),
                        typedResults: items),
                  if (salesRefs)
                    await $_getPrefetchedData<Branche, $BranchesTable, Sale>(
                        currentTable: table,
                        referencedTable:
                            $$BranchesTableReferences._salesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BranchesTableReferences(db, table, p0).salesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.branchId == item.id),
                        typedResults: items),
                  if (businessDaysRefs)
                    await $_getPrefetchedData<Branche, $BranchesTable,
                            BusinessDay>(
                        currentTable: table,
                        referencedTable: $$BranchesTableReferences
                            ._businessDaysRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BranchesTableReferences(db, table, p0)
                                .businessDaysRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.branchId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BranchesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BranchesTable,
    Branche,
    $$BranchesTableFilterComposer,
    $$BranchesTableOrderingComposer,
    $$BranchesTableAnnotationComposer,
    $$BranchesTableCreateCompanionBuilder,
    $$BranchesTableUpdateCompanionBuilder,
    (Branche, $$BranchesTableReferences),
    Branche,
    PrefetchHooks Function(
        {bool companyId,
        bool productsRefs,
        bool usersRefs,
        bool salesRefs,
        bool businessDaysRefs})>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required int branchId,
  required String name,
  required String barcode,
  Value<String?> category,
  Value<int> quantity,
  required double price,
  Value<String?> sku,
  Value<String> status,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<int> branchId,
  Value<String> name,
  Value<String> barcode,
  Value<String?> category,
  Value<int> quantity,
  Value<double> price,
  Value<String?> sku,
  Value<String> status,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BranchesTable _branchIdTable(_$AppDatabase db) => db.branches
      .createAlias($_aliasNameGenerator(db.products.branchId, db.branches.id));

  $$BranchesTableProcessedTableManager get branchId {
    final $_column = $_itemColumn<int>('branch_id')!;

    final manager = $$BranchesTableTableManager($_db, $_db.branches)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_branchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
      _saleItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.saleItems,
              aliasName:
                  $_aliasNameGenerator(db.products.id, db.saleItems.productId));

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager($_db, $_db.saleItems)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$BranchesTableFilterComposer get branchId {
    final $$BranchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableFilterComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> saleItemsRefs(
      Expression<bool> Function($$SaleItemsTableFilterComposer f) f) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableFilterComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$BranchesTableOrderingComposer get branchId {
    final $$BranchesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableOrderingComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$BranchesTableAnnotationComposer get branchId {
    final $$BranchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableAnnotationComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> saleItemsRefs<T extends Object>(
      Expression<T> Function($$SaleItemsTableAnnotationComposer a) f) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function({bool branchId, bool saleItemsRefs})> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> branchId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> barcode = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String?> sku = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            branchId: branchId,
            name: name,
            barcode: barcode,
            category: category,
            quantity: quantity,
            price: price,
            sku: sku,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int branchId,
            required String name,
            required String barcode,
            Value<String?> category = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            required double price,
            Value<String?> sku = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            branchId: branchId,
            name: name,
            barcode: barcode,
            category: category,
            quantity: quantity,
            price: price,
            sku: sku,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({branchId = false, saleItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (saleItemsRefs) db.saleItems],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (branchId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.branchId,
                    referencedTable:
                        $$ProductsTableReferences._branchIdTable(db),
                    referencedColumn:
                        $$ProductsTableReferences._branchIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saleItemsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            SaleItem>(
                        currentTable: table,
                        referencedTable:
                            $$ProductsTableReferences._saleItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .saleItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function({bool branchId, bool saleItemsRefs})>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<int?> branchId,
  required String username,
  required String password,
  required String role,
  Value<String?> name,
  Value<bool> isActive,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<int?> branchId,
  Value<String> username,
  Value<String> password,
  Value<String> role,
  Value<String?> name,
  Value<bool> isActive,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BranchesTable _branchIdTable(_$AppDatabase db) => db.branches
      .createAlias($_aliasNameGenerator(db.users.branchId, db.branches.id));

  $$BranchesTableProcessedTableManager? get branchId {
    final $_column = $_itemColumn<int>('branch_id');
    if ($_column == null) return null;
    final manager = $$BranchesTableTableManager($_db, $_db.branches)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_branchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sales,
          aliasName: $_aliasNameGenerator(db.users.id, db.sales.userId));

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$BranchesTableFilterComposer get branchId {
    final $$BranchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableFilterComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> salesRefs(
      Expression<bool> Function($$SalesTableFilterComposer f) f) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$BranchesTableOrderingComposer get branchId {
    final $$BranchesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableOrderingComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$BranchesTableAnnotationComposer get branchId {
    final $$BranchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableAnnotationComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> salesRefs<T extends Object>(
      Expression<T> Function($$SalesTableAnnotationComposer a) f) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool branchId, bool salesRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> branchId = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            branchId: branchId,
            username: username,
            password: password,
            role: role,
            name: name,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> branchId = const Value.absent(),
            required String username,
            required String password,
            required String role,
            Value<String?> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            branchId: branchId,
            username: username,
            password: password,
            role: role,
            name: name,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({branchId = false, salesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (salesRefs) db.sales],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (branchId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.branchId,
                    referencedTable: $$UsersTableReferences._branchIdTable(db),
                    referencedColumn:
                        $$UsersTableReferences._branchIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (salesRefs)
                    await $_getPrefetchedData<User, $UsersTable, Sale>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._salesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).salesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool branchId, bool salesRefs})>;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  required int branchId,
  Value<int?> userId,
  required String invoiceNumber,
  required double totalAmount,
  Value<double> discount,
  required String paymentMethod,
  Value<DateTime> date,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  Value<int> branchId,
  Value<int?> userId,
  Value<String> invoiceNumber,
  Value<double> totalAmount,
  Value<double> discount,
  Value<String> paymentMethod,
  Value<DateTime> date,
});

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BranchesTable _branchIdTable(_$AppDatabase db) => db.branches
      .createAlias($_aliasNameGenerator(db.sales.branchId, db.branches.id));

  $$BranchesTableProcessedTableManager get branchId {
    final $_column = $_itemColumn<int>('branch_id')!;

    final manager = $$BranchesTableTableManager($_db, $_db.branches)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_branchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias($_aliasNameGenerator(db.sales.userId, db.users.id));

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
      _saleItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.saleItems,
          aliasName: $_aliasNameGenerator(db.sales.id, db.saleItems.saleId));

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager($_db, $_db.saleItems)
        .filter((f) => f.saleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  $$BranchesTableFilterComposer get branchId {
    final $$BranchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableFilterComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> saleItemsRefs(
      Expression<bool> Function($$SaleItemsTableFilterComposer f) f) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableFilterComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  $$BranchesTableOrderingComposer get branchId {
    final $$BranchesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableOrderingComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$BranchesTableAnnotationComposer get branchId {
    final $$BranchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableAnnotationComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> saleItemsRefs<T extends Object>(
      Expression<T> Function($$SaleItemsTableAnnotationComposer a) f) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, $$SalesTableReferences),
    Sale,
    PrefetchHooks Function({bool branchId, bool userId, bool saleItemsRefs})> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> branchId = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String> invoiceNumber = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            branchId: branchId,
            userId: userId,
            invoiceNumber: invoiceNumber,
            totalAmount: totalAmount,
            discount: discount,
            paymentMethod: paymentMethod,
            date: date,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int branchId,
            Value<int?> userId = const Value.absent(),
            required String invoiceNumber,
            required double totalAmount,
            Value<double> discount = const Value.absent(),
            required String paymentMethod,
            Value<DateTime> date = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            branchId: branchId,
            userId: userId,
            invoiceNumber: invoiceNumber,
            totalAmount: totalAmount,
            discount: discount,
            paymentMethod: paymentMethod,
            date: date,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SalesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {branchId = false, userId = false, saleItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (saleItemsRefs) db.saleItems],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (branchId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.branchId,
                    referencedTable: $$SalesTableReferences._branchIdTable(db),
                    referencedColumn:
                        $$SalesTableReferences._branchIdTable(db).id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$SalesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$SalesTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saleItemsRefs)
                    await $_getPrefetchedData<Sale, $SalesTable, SaleItem>(
                        currentTable: table,
                        referencedTable:
                            $$SalesTableReferences._saleItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SalesTableReferences(db, table, p0).saleItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.saleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, $$SalesTableReferences),
    Sale,
    PrefetchHooks Function({bool branchId, bool userId, bool saleItemsRefs})>;
typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  Value<int> id,
  required int saleId,
  required int productId,
  required int quantity,
  required double price,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<int> id,
  Value<int> saleId,
  Value<int> productId,
  Value<int> quantity,
  Value<double> price,
});

final class $$SaleItemsTableReferences
    extends BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem> {
  $$SaleItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) => db.sales
      .createAlias($_aliasNameGenerator(db.saleItems.saleId, db.sales.id));

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<int>('sale_id')!;

    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.saleItems.productId, db.products.id));

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableOrderingComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaleItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, $$SaleItemsTableReferences),
    SaleItem,
    PrefetchHooks Function({bool saleId, bool productId})> {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saleId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
          }) =>
              SaleItemsCompanion(
            id: id,
            saleId: saleId,
            productId: productId,
            quantity: quantity,
            price: price,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saleId,
            required int productId,
            required int quantity,
            required double price,
          }) =>
              SaleItemsCompanion.insert(
            id: id,
            saleId: saleId,
            productId: productId,
            quantity: quantity,
            price: price,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SaleItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({saleId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (saleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saleId,
                    referencedTable:
                        $$SaleItemsTableReferences._saleIdTable(db),
                    referencedColumn:
                        $$SaleItemsTableReferences._saleIdTable(db).id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$SaleItemsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$SaleItemsTableReferences._productIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SaleItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, $$SaleItemsTableReferences),
    SaleItem,
    PrefetchHooks Function({bool saleId, bool productId})>;
typedef $$BusinessDaysTableCreateCompanionBuilder = BusinessDaysCompanion
    Function({
  Value<int> id,
  required int branchId,
  Value<DateTime> openTime,
  Value<DateTime?> closeTime,
  required double openingBalance,
  Value<double?> closingBalance,
  Value<double> totalCashSales,
  Value<double> totalCardSales,
  Value<double> totalGiftCardSales,
  Value<double> totalOtherSales,
  Value<String> status,
  Value<String?> openedBy,
  Value<String?> closedBy,
  Value<double?> discrepancy,
});
typedef $$BusinessDaysTableUpdateCompanionBuilder = BusinessDaysCompanion
    Function({
  Value<int> id,
  Value<int> branchId,
  Value<DateTime> openTime,
  Value<DateTime?> closeTime,
  Value<double> openingBalance,
  Value<double?> closingBalance,
  Value<double> totalCashSales,
  Value<double> totalCardSales,
  Value<double> totalGiftCardSales,
  Value<double> totalOtherSales,
  Value<String> status,
  Value<String?> openedBy,
  Value<String?> closedBy,
  Value<double?> discrepancy,
});

final class $$BusinessDaysTableReferences
    extends BaseReferences<_$AppDatabase, $BusinessDaysTable, BusinessDay> {
  $$BusinessDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BranchesTable _branchIdTable(_$AppDatabase db) =>
      db.branches.createAlias(
          $_aliasNameGenerator(db.businessDays.branchId, db.branches.id));

  $$BranchesTableProcessedTableManager get branchId {
    final $_column = $_itemColumn<int>('branch_id')!;

    final manager = $$BranchesTableTableManager($_db, $_db.branches)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_branchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BusinessDaysTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessDaysTable> {
  $$BusinessDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openTime => $composableBuilder(
      column: $table.openTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closeTime => $composableBuilder(
      column: $table.closeTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get closingBalance => $composableBuilder(
      column: $table.closingBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCashSales => $composableBuilder(
      column: $table.totalCashSales,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCardSales => $composableBuilder(
      column: $table.totalCardSales,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalGiftCardSales => $composableBuilder(
      column: $table.totalGiftCardSales,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalOtherSales => $composableBuilder(
      column: $table.totalOtherSales,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get openedBy => $composableBuilder(
      column: $table.openedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closedBy => $composableBuilder(
      column: $table.closedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discrepancy => $composableBuilder(
      column: $table.discrepancy, builder: (column) => ColumnFilters(column));

  $$BranchesTableFilterComposer get branchId {
    final $$BranchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableFilterComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BusinessDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessDaysTable> {
  $$BusinessDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openTime => $composableBuilder(
      column: $table.openTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closeTime => $composableBuilder(
      column: $table.closeTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get closingBalance => $composableBuilder(
      column: $table.closingBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCashSales => $composableBuilder(
      column: $table.totalCashSales,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCardSales => $composableBuilder(
      column: $table.totalCardSales,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalGiftCardSales => $composableBuilder(
      column: $table.totalGiftCardSales,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalOtherSales => $composableBuilder(
      column: $table.totalOtherSales,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get openedBy => $composableBuilder(
      column: $table.openedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closedBy => $composableBuilder(
      column: $table.closedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discrepancy => $composableBuilder(
      column: $table.discrepancy, builder: (column) => ColumnOrderings(column));

  $$BranchesTableOrderingComposer get branchId {
    final $$BranchesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableOrderingComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BusinessDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessDaysTable> {
  $$BusinessDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get openTime =>
      $composableBuilder(column: $table.openTime, builder: (column) => column);

  GeneratedColumn<DateTime> get closeTime =>
      $composableBuilder(column: $table.closeTime, builder: (column) => column);

  GeneratedColumn<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance, builder: (column) => column);

  GeneratedColumn<double> get closingBalance => $composableBuilder(
      column: $table.closingBalance, builder: (column) => column);

  GeneratedColumn<double> get totalCashSales => $composableBuilder(
      column: $table.totalCashSales, builder: (column) => column);

  GeneratedColumn<double> get totalCardSales => $composableBuilder(
      column: $table.totalCardSales, builder: (column) => column);

  GeneratedColumn<double> get totalGiftCardSales => $composableBuilder(
      column: $table.totalGiftCardSales, builder: (column) => column);

  GeneratedColumn<double> get totalOtherSales => $composableBuilder(
      column: $table.totalOtherSales, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get openedBy =>
      $composableBuilder(column: $table.openedBy, builder: (column) => column);

  GeneratedColumn<String> get closedBy =>
      $composableBuilder(column: $table.closedBy, builder: (column) => column);

  GeneratedColumn<double> get discrepancy => $composableBuilder(
      column: $table.discrepancy, builder: (column) => column);

  $$BranchesTableAnnotationComposer get branchId {
    final $$BranchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.branchId,
        referencedTable: $db.branches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BranchesTableAnnotationComposer(
              $db: $db,
              $table: $db.branches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BusinessDaysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BusinessDaysTable,
    BusinessDay,
    $$BusinessDaysTableFilterComposer,
    $$BusinessDaysTableOrderingComposer,
    $$BusinessDaysTableAnnotationComposer,
    $$BusinessDaysTableCreateCompanionBuilder,
    $$BusinessDaysTableUpdateCompanionBuilder,
    (BusinessDay, $$BusinessDaysTableReferences),
    BusinessDay,
    PrefetchHooks Function({bool branchId})> {
  $$BusinessDaysTableTableManager(_$AppDatabase db, $BusinessDaysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> branchId = const Value.absent(),
            Value<DateTime> openTime = const Value.absent(),
            Value<DateTime?> closeTime = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<double?> closingBalance = const Value.absent(),
            Value<double> totalCashSales = const Value.absent(),
            Value<double> totalCardSales = const Value.absent(),
            Value<double> totalGiftCardSales = const Value.absent(),
            Value<double> totalOtherSales = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> openedBy = const Value.absent(),
            Value<String?> closedBy = const Value.absent(),
            Value<double?> discrepancy = const Value.absent(),
          }) =>
              BusinessDaysCompanion(
            id: id,
            branchId: branchId,
            openTime: openTime,
            closeTime: closeTime,
            openingBalance: openingBalance,
            closingBalance: closingBalance,
            totalCashSales: totalCashSales,
            totalCardSales: totalCardSales,
            totalGiftCardSales: totalGiftCardSales,
            totalOtherSales: totalOtherSales,
            status: status,
            openedBy: openedBy,
            closedBy: closedBy,
            discrepancy: discrepancy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int branchId,
            Value<DateTime> openTime = const Value.absent(),
            Value<DateTime?> closeTime = const Value.absent(),
            required double openingBalance,
            Value<double?> closingBalance = const Value.absent(),
            Value<double> totalCashSales = const Value.absent(),
            Value<double> totalCardSales = const Value.absent(),
            Value<double> totalGiftCardSales = const Value.absent(),
            Value<double> totalOtherSales = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> openedBy = const Value.absent(),
            Value<String?> closedBy = const Value.absent(),
            Value<double?> discrepancy = const Value.absent(),
          }) =>
              BusinessDaysCompanion.insert(
            id: id,
            branchId: branchId,
            openTime: openTime,
            closeTime: closeTime,
            openingBalance: openingBalance,
            closingBalance: closingBalance,
            totalCashSales: totalCashSales,
            totalCardSales: totalCardSales,
            totalGiftCardSales: totalGiftCardSales,
            totalOtherSales: totalOtherSales,
            status: status,
            openedBy: openedBy,
            closedBy: closedBy,
            discrepancy: discrepancy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BusinessDaysTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({branchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (branchId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.branchId,
                    referencedTable:
                        $$BusinessDaysTableReferences._branchIdTable(db),
                    referencedColumn:
                        $$BusinessDaysTableReferences._branchIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BusinessDaysTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BusinessDaysTable,
    BusinessDay,
    $$BusinessDaysTableFilterComposer,
    $$BusinessDaysTableOrderingComposer,
    $$BusinessDaysTableAnnotationComposer,
    $$BusinessDaysTableCreateCompanionBuilder,
    $$BusinessDaysTableUpdateCompanionBuilder,
    (BusinessDay, $$BusinessDaysTableReferences),
    BusinessDay,
    PrefetchHooks Function({bool branchId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CompaniesTableTableManager get companies =>
      $$CompaniesTableTableManager(_db, _db.companies);
  $$BranchesTableTableManager get branches =>
      $$BranchesTableTableManager(_db, _db.branches);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$BusinessDaysTableTableManager get businessDays =>
      $$BusinessDaysTableTableManager(_db, _db.businessDays);
}
