// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_bill_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalBillItemCollection on Isar {
  IsarCollection<LocalBillItem> get localBillItems => this.collection();
}

const LocalBillItemSchema = CollectionSchema(
  name: r'LocalBillItem',
  id: 8932102531256286807,
  properties: {
    r'billUuid': PropertySchema(
      id: 0,
      name: r'billUuid',
      type: IsarType.string,
    ),
    r'isCancelled': PropertySchema(
      id: 1,
      name: r'isCancelled',
      type: IsarType.bool,
    ),
    r'isDelivered': PropertySchema(
      id: 2,
      name: r'isDelivered',
      type: IsarType.bool,
    ),
    r'isPaid': PropertySchema(
      id: 3,
      name: r'isPaid',
      type: IsarType.bool,
    ),
    r'isSynced': PropertySchema(
      id: 4,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'menuItemId': PropertySchema(
      id: 5,
      name: r'menuItemId',
      type: IsarType.long,
    ),
    r'menuName': PropertySchema(
      id: 6,
      name: r'menuName',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 7,
      name: r'notes',
      type: IsarType.string,
    ),
    r'price': PropertySchema(
      id: 8,
      name: r'price',
      type: IsarType.double,
    ),
    r'qty': PropertySchema(
      id: 9,
      name: r'qty',
      type: IsarType.long,
    ),
    r'uuid': PropertySchema(
      id: 10,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _localBillItemEstimateSize,
  serialize: _localBillItemSerialize,
  deserialize: _localBillItemDeserialize,
  deserializeProp: _localBillItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'billUuid': IndexSchema(
      id: -2460401199818585442,
      name: r'billUuid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'billUuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localBillItemGetId,
  getLinks: _localBillItemGetLinks,
  attach: _localBillItemAttach,
  version: '3.1.0+1',
);

int _localBillItemEstimateSize(
  LocalBillItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.billUuid.length * 3;
  bytesCount += 3 + object.menuName.length * 3;
  bytesCount += 3 + object.notes.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _localBillItemSerialize(
  LocalBillItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.billUuid);
  writer.writeBool(offsets[1], object.isCancelled);
  writer.writeBool(offsets[2], object.isDelivered);
  writer.writeBool(offsets[3], object.isPaid);
  writer.writeBool(offsets[4], object.isSynced);
  writer.writeLong(offsets[5], object.menuItemId);
  writer.writeString(offsets[6], object.menuName);
  writer.writeString(offsets[7], object.notes);
  writer.writeDouble(offsets[8], object.price);
  writer.writeLong(offsets[9], object.qty);
  writer.writeString(offsets[10], object.uuid);
}

LocalBillItem _localBillItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalBillItem();
  object.billUuid = reader.readString(offsets[0]);
  object.id = id;
  object.isCancelled = reader.readBool(offsets[1]);
  object.isDelivered = reader.readBool(offsets[2]);
  object.isPaid = reader.readBool(offsets[3]);
  object.isSynced = reader.readBool(offsets[4]);
  object.menuItemId = reader.readLong(offsets[5]);
  object.menuName = reader.readString(offsets[6]);
  object.notes = reader.readString(offsets[7]);
  object.price = reader.readDouble(offsets[8]);
  object.qty = reader.readLong(offsets[9]);
  object.uuid = reader.readString(offsets[10]);
  return object;
}

P _localBillItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localBillItemGetId(LocalBillItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localBillItemGetLinks(LocalBillItem object) {
  return [];
}

void _localBillItemAttach(
    IsarCollection<dynamic> col, Id id, LocalBillItem object) {
  object.id = id;
}

extension LocalBillItemByIndex on IsarCollection<LocalBillItem> {
  Future<LocalBillItem?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  LocalBillItem? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<LocalBillItem?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<LocalBillItem?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(LocalBillItem object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(LocalBillItem object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<LocalBillItem> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<LocalBillItem> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension LocalBillItemQueryWhereSort
    on QueryBuilder<LocalBillItem, LocalBillItem, QWhere> {
  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalBillItemQueryWhere
    on QueryBuilder<LocalBillItem, LocalBillItem, QWhereClause> {
  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhereClause> uuidNotEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhereClause> billUuidEqualTo(
      String billUuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'billUuid',
        value: [billUuid],
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterWhereClause>
      billUuidNotEqualTo(String billUuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'billUuid',
              lower: [],
              upper: [billUuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'billUuid',
              lower: [billUuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'billUuid',
              lower: [billUuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'billUuid',
              lower: [],
              upper: [billUuid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalBillItemQueryFilter
    on QueryBuilder<LocalBillItem, LocalBillItem, QFilterCondition> {
  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'billUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'billUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'billUuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'billUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'billUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'billUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'billUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      billUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'billUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      isCancelledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCancelled',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      isDeliveredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDelivered',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      isPaidEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaid',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuItemIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menuItemId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuItemIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'menuItemId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuItemIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'menuItemId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuItemIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'menuItemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menuName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'menuName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'menuName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'menuName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'menuName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'menuName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'menuName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'menuName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menuName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      menuNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'menuName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition> qtyEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qty',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      qtyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qty',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition> qtyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qty',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition> qtyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension LocalBillItemQueryObject
    on QueryBuilder<LocalBillItem, LocalBillItem, QFilterCondition> {}

extension LocalBillItemQueryLinks
    on QueryBuilder<LocalBillItem, LocalBillItem, QFilterCondition> {}

extension LocalBillItemQuerySortBy
    on QueryBuilder<LocalBillItem, LocalBillItem, QSortBy> {
  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByBillUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billUuid', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      sortByBillUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billUuid', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      sortByIsCancelledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByIsDelivered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDelivered', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      sortByIsDeliveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDelivered', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByMenuItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuItemId', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      sortByMenuItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuItemId', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByMenuName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuName', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      sortByMenuNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuName', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension LocalBillItemQuerySortThenBy
    on QueryBuilder<LocalBillItem, LocalBillItem, QSortThenBy> {
  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByBillUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billUuid', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      thenByBillUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billUuid', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      thenByIsCancelledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByIsDelivered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDelivered', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      thenByIsDeliveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDelivered', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByMenuItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuItemId', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      thenByMenuItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuItemId', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByMenuName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuName', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy>
      thenByMenuNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuName', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension LocalBillItemQueryWhereDistinct
    on QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> {
  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> distinctByBillUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'billUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct>
      distinctByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCancelled');
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct>
      distinctByIsDelivered() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDelivered');
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> distinctByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaid');
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> distinctByMenuItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'menuItemId');
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> distinctByMenuName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'menuName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> distinctByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qty');
    });
  }

  QueryBuilder<LocalBillItem, LocalBillItem, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension LocalBillItemQueryProperty
    on QueryBuilder<LocalBillItem, LocalBillItem, QQueryProperty> {
  QueryBuilder<LocalBillItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalBillItem, String, QQueryOperations> billUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'billUuid');
    });
  }

  QueryBuilder<LocalBillItem, bool, QQueryOperations> isCancelledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCancelled');
    });
  }

  QueryBuilder<LocalBillItem, bool, QQueryOperations> isDeliveredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDelivered');
    });
  }

  QueryBuilder<LocalBillItem, bool, QQueryOperations> isPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaid');
    });
  }

  QueryBuilder<LocalBillItem, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<LocalBillItem, int, QQueryOperations> menuItemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'menuItemId');
    });
  }

  QueryBuilder<LocalBillItem, String, QQueryOperations> menuNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'menuName');
    });
  }

  QueryBuilder<LocalBillItem, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<LocalBillItem, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<LocalBillItem, int, QQueryOperations> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qty');
    });
  }

  QueryBuilder<LocalBillItem, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
