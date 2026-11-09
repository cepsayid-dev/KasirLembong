// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_expense_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalExpenseItemCollection on Isar {
  IsarCollection<LocalExpenseItem> get localExpenseItems => this.collection();
}

const LocalExpenseItemSchema = CollectionSchema(
  name: r'LocalExpenseItem',
  id: 4359760047100324404,
  properties: {
    r'isSynced': PropertySchema(
      id: 0,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'menuId': PropertySchema(
      id: 1,
      name: r'menuId',
      type: IsarType.long,
    ),
    r'menuName': PropertySchema(
      id: 2,
      name: r'menuName',
      type: IsarType.string,
    ),
    r'noteId': PropertySchema(
      id: 3,
      name: r'noteId',
      type: IsarType.long,
    ),
    r'price': PropertySchema(
      id: 4,
      name: r'price',
      type: IsarType.double,
    ),
    r'qty': PropertySchema(
      id: 5,
      name: r'qty',
      type: IsarType.long,
    ),
    r'stockStatus': PropertySchema(
      id: 6,
      name: r'stockStatus',
      type: IsarType.string,
    ),
    r'trackingMode': PropertySchema(
      id: 7,
      name: r'trackingMode',
      type: IsarType.string,
    )
  },
  estimateSize: _localExpenseItemEstimateSize,
  serialize: _localExpenseItemSerialize,
  deserialize: _localExpenseItemDeserialize,
  deserializeProp: _localExpenseItemDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _localExpenseItemGetId,
  getLinks: _localExpenseItemGetLinks,
  attach: _localExpenseItemAttach,
  version: '3.1.0+1',
);

int _localExpenseItemEstimateSize(
  LocalExpenseItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.menuName.length * 3;
  {
    final value = object.stockStatus;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.trackingMode.length * 3;
  return bytesCount;
}

void _localExpenseItemSerialize(
  LocalExpenseItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isSynced);
  writer.writeLong(offsets[1], object.menuId);
  writer.writeString(offsets[2], object.menuName);
  writer.writeLong(offsets[3], object.noteId);
  writer.writeDouble(offsets[4], object.price);
  writer.writeLong(offsets[5], object.qty);
  writer.writeString(offsets[6], object.stockStatus);
  writer.writeString(offsets[7], object.trackingMode);
}

LocalExpenseItem _localExpenseItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalExpenseItem();
  object.id = id;
  object.isSynced = reader.readBool(offsets[0]);
  object.menuId = reader.readLong(offsets[1]);
  object.menuName = reader.readString(offsets[2]);
  object.noteId = reader.readLong(offsets[3]);
  object.price = reader.readDouble(offsets[4]);
  object.qty = reader.readLong(offsets[5]);
  object.stockStatus = reader.readStringOrNull(offsets[6]);
  object.trackingMode = reader.readString(offsets[7]);
  return object;
}

P _localExpenseItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localExpenseItemGetId(LocalExpenseItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localExpenseItemGetLinks(LocalExpenseItem object) {
  return [];
}

void _localExpenseItemAttach(
    IsarCollection<dynamic> col, Id id, LocalExpenseItem object) {
  object.id = id;
}

extension LocalExpenseItemQueryWhereSort
    on QueryBuilder<LocalExpenseItem, LocalExpenseItem, QWhere> {
  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalExpenseItemQueryWhere
    on QueryBuilder<LocalExpenseItem, LocalExpenseItem, QWhereClause> {
  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterWhereClause> idBetween(
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
}

extension LocalExpenseItemQueryFilter
    on QueryBuilder<LocalExpenseItem, LocalExpenseItem, QFilterCondition> {
  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      menuIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menuId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      menuIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'menuId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      menuIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'menuId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      menuIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'menuId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      menuNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'menuName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      menuNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'menuName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      menuNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menuName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      menuNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'menuName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      noteIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      noteIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      noteIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      noteIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      qtyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qty',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      qtyLessThan(
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      qtyBetween(
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

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stockStatus',
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stockStatus',
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stockStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stockStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stockStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stockStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stockStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stockStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stockStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stockStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stockStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      stockStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stockStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackingMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackingMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackingMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackingMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trackingMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trackingMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackingMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackingMode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackingMode',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterFilterCondition>
      trackingModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackingMode',
        value: '',
      ));
    });
  }
}

extension LocalExpenseItemQueryObject
    on QueryBuilder<LocalExpenseItem, LocalExpenseItem, QFilterCondition> {}

extension LocalExpenseItemQueryLinks
    on QueryBuilder<LocalExpenseItem, LocalExpenseItem, QFilterCondition> {}

extension LocalExpenseItemQuerySortBy
    on QueryBuilder<LocalExpenseItem, LocalExpenseItem, QSortBy> {
  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByMenuId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuId', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByMenuIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuId', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByMenuName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuName', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByMenuNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuName', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy> sortByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByStockStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByStockStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByTrackingMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingMode', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      sortByTrackingModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingMode', Sort.desc);
    });
  }
}

extension LocalExpenseItemQuerySortThenBy
    on QueryBuilder<LocalExpenseItem, LocalExpenseItem, QSortThenBy> {
  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByMenuId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuId', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByMenuIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuId', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByMenuName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuName', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByMenuNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menuName', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy> thenByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByStockStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByStockStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByTrackingMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingMode', Sort.asc);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QAfterSortBy>
      thenByTrackingModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingMode', Sort.desc);
    });
  }
}

extension LocalExpenseItemQueryWhereDistinct
    on QueryBuilder<LocalExpenseItem, LocalExpenseItem, QDistinct> {
  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QDistinct>
      distinctByMenuId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'menuId');
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QDistinct>
      distinctByMenuName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'menuName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QDistinct>
      distinctByNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteId');
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QDistinct>
      distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QDistinct> distinctByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qty');
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QDistinct>
      distinctByStockStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stockStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalExpenseItem, LocalExpenseItem, QDistinct>
      distinctByTrackingMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackingMode', caseSensitive: caseSensitive);
    });
  }
}

extension LocalExpenseItemQueryProperty
    on QueryBuilder<LocalExpenseItem, LocalExpenseItem, QQueryProperty> {
  QueryBuilder<LocalExpenseItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalExpenseItem, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<LocalExpenseItem, int, QQueryOperations> menuIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'menuId');
    });
  }

  QueryBuilder<LocalExpenseItem, String, QQueryOperations> menuNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'menuName');
    });
  }

  QueryBuilder<LocalExpenseItem, int, QQueryOperations> noteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteId');
    });
  }

  QueryBuilder<LocalExpenseItem, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<LocalExpenseItem, int, QQueryOperations> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qty');
    });
  }

  QueryBuilder<LocalExpenseItem, String?, QQueryOperations>
      stockStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stockStatus');
    });
  }

  QueryBuilder<LocalExpenseItem, String, QQueryOperations>
      trackingModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackingMode');
    });
  }
}
