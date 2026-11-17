// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_shift.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalShiftCollection on Isar {
  IsarCollection<LocalShift> get localShifts => this.collection();
}

const LocalShiftSchema = CollectionSchema(
  name: r'LocalShift',
  id: -4896530524672925750,
  properties: {
    r'actualCash': PropertySchema(
      id: 0,
      name: r'actualCash',
      type: IsarType.double,
    ),
    r'cashierSlot': PropertySchema(
      id: 1,
      name: r'cashierSlot',
      type: IsarType.string,
    ),
    r'closedAt': PropertySchema(
      id: 2,
      name: r'closedAt',
      type: IsarType.dateTime,
    ),
    r'discrepancy': PropertySchema(
      id: 3,
      name: r'discrepancy',
      type: IsarType.double,
    ),
    r'employeeId': PropertySchema(
      id: 4,
      name: r'employeeId',
      type: IsarType.long,
    ),
    r'employeeName': PropertySchema(
      id: 5,
      name: r'employeeName',
      type: IsarType.string,
    ),
    r'expectedCash': PropertySchema(
      id: 6,
      name: r'expectedCash',
      type: IsarType.double,
    ),
    r'isSynced': PropertySchema(
      id: 7,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'openedAt': PropertySchema(
      id: 8,
      name: r'openedAt',
      type: IsarType.dateTime,
    ),
    r'openingCash': PropertySchema(
      id: 9,
      name: r'openingCash',
      type: IsarType.double,
    ),
    r'status': PropertySchema(
      id: 10,
      name: r'status',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 11,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _localShiftEstimateSize,
  serialize: _localShiftSerialize,
  deserialize: _localShiftDeserialize,
  deserializeProp: _localShiftDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localShiftGetId,
  getLinks: _localShiftGetLinks,
  attach: _localShiftAttach,
  version: '3.1.0+1',
);

int _localShiftEstimateSize(
  LocalShift object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cashierSlot.length * 3;
  bytesCount += 3 + object.employeeName.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _localShiftSerialize(
  LocalShift object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.actualCash);
  writer.writeString(offsets[1], object.cashierSlot);
  writer.writeDateTime(offsets[2], object.closedAt);
  writer.writeDouble(offsets[3], object.discrepancy);
  writer.writeLong(offsets[4], object.employeeId);
  writer.writeString(offsets[5], object.employeeName);
  writer.writeDouble(offsets[6], object.expectedCash);
  writer.writeBool(offsets[7], object.isSynced);
  writer.writeDateTime(offsets[8], object.openedAt);
  writer.writeDouble(offsets[9], object.openingCash);
  writer.writeString(offsets[10], object.status);
  writer.writeString(offsets[11], object.uuid);
}

LocalShift _localShiftDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalShift();
  object.actualCash = reader.readDouble(offsets[0]);
  object.cashierSlot = reader.readString(offsets[1]);
  object.closedAt = reader.readDateTimeOrNull(offsets[2]);
  object.discrepancy = reader.readDouble(offsets[3]);
  object.employeeId = reader.readLong(offsets[4]);
  object.employeeName = reader.readString(offsets[5]);
  object.expectedCash = reader.readDouble(offsets[6]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[7]);
  object.openedAt = reader.readDateTime(offsets[8]);
  object.openingCash = reader.readDouble(offsets[9]);
  object.status = reader.readString(offsets[10]);
  object.uuid = reader.readString(offsets[11]);
  return object;
}

P _localShiftDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localShiftGetId(LocalShift object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localShiftGetLinks(LocalShift object) {
  return [];
}

void _localShiftAttach(IsarCollection<dynamic> col, Id id, LocalShift object) {
  object.id = id;
}

extension LocalShiftByIndex on IsarCollection<LocalShift> {
  Future<LocalShift?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  LocalShift? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<LocalShift?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<LocalShift?> getAllByUuidSync(List<String> uuidValues) {
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

  Future<Id> putByUuid(LocalShift object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(LocalShift object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<LocalShift> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<LocalShift> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension LocalShiftQueryWhereSort
    on QueryBuilder<LocalShift, LocalShift, QWhere> {
  QueryBuilder<LocalShift, LocalShift, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalShiftQueryWhere
    on QueryBuilder<LocalShift, LocalShift, QWhereClause> {
  QueryBuilder<LocalShift, LocalShift, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<LocalShift, LocalShift, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterWhereClause> idBetween(
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

  QueryBuilder<LocalShift, LocalShift, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterWhereClause> uuidNotEqualTo(
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
}

extension LocalShiftQueryFilter
    on QueryBuilder<LocalShift, LocalShift, QFilterCondition> {
  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> actualCashEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualCash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      actualCashGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualCash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      actualCashLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualCash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> actualCashBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualCash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashierSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cashierSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cashierSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cashierSlot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cashierSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cashierSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cashierSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cashierSlot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashierSlot',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      cashierSlotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cashierSlot',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> closedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'closedAt',
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      closedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'closedAt',
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> closedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'closedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      closedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'closedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> closedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'closedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> closedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'closedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      discrepancyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discrepancy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      discrepancyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discrepancy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      discrepancyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discrepancy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      discrepancyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discrepancy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> employeeIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'employeeId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'employeeId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'employeeId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> employeeIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'employeeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'employeeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'employeeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'employeeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'employeeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'employeeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'employeeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'employeeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'employeeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'employeeName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      employeeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'employeeName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      expectedCashEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedCash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      expectedCashGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expectedCash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      expectedCashLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expectedCash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      expectedCashBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expectedCash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> isSyncedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> openedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      openedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> openedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> openedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      openingCashEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openingCash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      openingCashGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openingCash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      openingCashLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openingCash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      openingCashBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openingCash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> statusContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidStartsWith(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidMatches(
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

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension LocalShiftQueryObject
    on QueryBuilder<LocalShift, LocalShift, QFilterCondition> {}

extension LocalShiftQueryLinks
    on QueryBuilder<LocalShift, LocalShift, QFilterCondition> {}

extension LocalShiftQuerySortBy
    on QueryBuilder<LocalShift, LocalShift, QSortBy> {
  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByActualCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualCash', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByActualCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualCash', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByCashierSlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierSlot', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByCashierSlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierSlot', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByDiscrepancy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discrepancy', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByDiscrepancyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discrepancy', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByExpectedCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCash', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByExpectedCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCash', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByOpeningCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingCash', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByOpeningCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingCash', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension LocalShiftQuerySortThenBy
    on QueryBuilder<LocalShift, LocalShift, QSortThenBy> {
  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByActualCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualCash', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByActualCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualCash', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByCashierSlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierSlot', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByCashierSlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierSlot', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByDiscrepancy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discrepancy', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByDiscrepancyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discrepancy', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByEmployeeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeId', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByEmployeeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByEmployeeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employeeName', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByExpectedCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCash', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByExpectedCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCash', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByOpenedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByOpeningCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingCash', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByOpeningCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingCash', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension LocalShiftQueryWhereDistinct
    on QueryBuilder<LocalShift, LocalShift, QDistinct> {
  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByActualCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualCash');
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByCashierSlot(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierSlot', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closedAt');
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByDiscrepancy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discrepancy');
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByEmployeeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeId');
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByEmployeeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employeeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByExpectedCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedCash');
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByOpenedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openedAt');
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByOpeningCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openingCash');
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalShift, LocalShift, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension LocalShiftQueryProperty
    on QueryBuilder<LocalShift, LocalShift, QQueryProperty> {
  QueryBuilder<LocalShift, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalShift, double, QQueryOperations> actualCashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualCash');
    });
  }

  QueryBuilder<LocalShift, String, QQueryOperations> cashierSlotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierSlot');
    });
  }

  QueryBuilder<LocalShift, DateTime?, QQueryOperations> closedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closedAt');
    });
  }

  QueryBuilder<LocalShift, double, QQueryOperations> discrepancyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discrepancy');
    });
  }

  QueryBuilder<LocalShift, int, QQueryOperations> employeeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeId');
    });
  }

  QueryBuilder<LocalShift, String, QQueryOperations> employeeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employeeName');
    });
  }

  QueryBuilder<LocalShift, double, QQueryOperations> expectedCashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedCash');
    });
  }

  QueryBuilder<LocalShift, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<LocalShift, DateTime, QQueryOperations> openedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openedAt');
    });
  }

  QueryBuilder<LocalShift, double, QQueryOperations> openingCashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openingCash');
    });
  }

  QueryBuilder<LocalShift, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<LocalShift, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
