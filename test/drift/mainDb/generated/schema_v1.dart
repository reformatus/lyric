// dart format width=80
import 'dart:typed_data' as i2;
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Banks extends Table with TableInfo<Banks, BanksData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Banks(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<i2.Uint8List> logo = GeneratedColumn<i2.Uint8List>(
    'logo',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<i2.Uint8List> tinyLogo =
      GeneratedColumn<i2.Uint8List>(
        'tiny_logo',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> legal = GeneratedColumn<String>(
    'legal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> parallelUpdateJobs = GeneratedColumn<int>(
    'parallel_update_jobs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> amountOfSongsInRequest = GeneratedColumn<int>(
    'amount_of_songs_in_request',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<bool> noCms = GeneratedColumn<bool>(
    'no_cms',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("no_cms" IN (0, 1))',
    ),
  );
  late final GeneratedColumn<String> songFields = GeneratedColumn<String>(
    'song_fields',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
  );
  late final GeneratedColumn<bool> isOfflineMode = GeneratedColumn<bool>(
    'is_offline_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_offline_mode" IN (0, 1))',
    ),
  );
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    logo,
    tinyLogo,
    name,
    description,
    legal,
    baseUrl,
    parallelUpdateJobs,
    amountOfSongsInRequest,
    noCms,
    songFields,
    isEnabled,
    isOfflineMode,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'banks';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BanksData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BanksData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      logo: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}logo'],
      ),
      tinyLogo: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}tiny_logo'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      legal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legal'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      parallelUpdateJobs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parallel_update_jobs'],
      )!,
      amountOfSongsInRequest: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_of_songs_in_request'],
      )!,
      noCms: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}no_cms'],
      )!,
      songFields: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_fields'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      isOfflineMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_offline_mode'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
    );
  }

  @override
  Banks createAlias(String alias) {
    return Banks(attachedDatabase, alias);
  }
}

class BanksData extends DataClass implements Insertable<BanksData> {
  final int id;
  final String uuid;
  final i2.Uint8List? logo;
  final i2.Uint8List? tinyLogo;
  final String name;
  final String description;
  final String legal;
  final String baseUrl;
  final int parallelUpdateJobs;
  final int amountOfSongsInRequest;
  final bool noCms;
  final String songFields;
  final bool isEnabled;
  final bool isOfflineMode;
  final DateTime? lastUpdated;
  const BanksData({
    required this.id,
    required this.uuid,
    this.logo,
    this.tinyLogo,
    required this.name,
    required this.description,
    required this.legal,
    required this.baseUrl,
    required this.parallelUpdateJobs,
    required this.amountOfSongsInRequest,
    required this.noCms,
    required this.songFields,
    required this.isEnabled,
    required this.isOfflineMode,
    this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || logo != null) {
      map['logo'] = Variable<i2.Uint8List>(logo);
    }
    if (!nullToAbsent || tinyLogo != null) {
      map['tiny_logo'] = Variable<i2.Uint8List>(tinyLogo);
    }
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['legal'] = Variable<String>(legal);
    map['base_url'] = Variable<String>(baseUrl);
    map['parallel_update_jobs'] = Variable<int>(parallelUpdateJobs);
    map['amount_of_songs_in_request'] = Variable<int>(amountOfSongsInRequest);
    map['no_cms'] = Variable<bool>(noCms);
    map['song_fields'] = Variable<String>(songFields);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['is_offline_mode'] = Variable<bool>(isOfflineMode);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  BanksCompanion toCompanion(bool nullToAbsent) {
    return BanksCompanion(
      id: Value(id),
      uuid: Value(uuid),
      logo: logo == null && nullToAbsent ? const Value.absent() : Value(logo),
      tinyLogo: tinyLogo == null && nullToAbsent
          ? const Value.absent()
          : Value(tinyLogo),
      name: Value(name),
      description: Value(description),
      legal: Value(legal),
      baseUrl: Value(baseUrl),
      parallelUpdateJobs: Value(parallelUpdateJobs),
      amountOfSongsInRequest: Value(amountOfSongsInRequest),
      noCms: Value(noCms),
      songFields: Value(songFields),
      isEnabled: Value(isEnabled),
      isOfflineMode: Value(isOfflineMode),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory BanksData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BanksData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      logo: serializer.fromJson<i2.Uint8List?>(json['logo']),
      tinyLogo: serializer.fromJson<i2.Uint8List?>(json['tinyLogo']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      legal: serializer.fromJson<String>(json['legal']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      parallelUpdateJobs: serializer.fromJson<int>(json['parallelUpdateJobs']),
      amountOfSongsInRequest: serializer.fromJson<int>(
        json['amountOfSongsInRequest'],
      ),
      noCms: serializer.fromJson<bool>(json['noCms']),
      songFields: serializer.fromJson<String>(json['songFields']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      isOfflineMode: serializer.fromJson<bool>(json['isOfflineMode']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'logo': serializer.toJson<i2.Uint8List?>(logo),
      'tinyLogo': serializer.toJson<i2.Uint8List?>(tinyLogo),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'legal': serializer.toJson<String>(legal),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'parallelUpdateJobs': serializer.toJson<int>(parallelUpdateJobs),
      'amountOfSongsInRequest': serializer.toJson<int>(amountOfSongsInRequest),
      'noCms': serializer.toJson<bool>(noCms),
      'songFields': serializer.toJson<String>(songFields),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'isOfflineMode': serializer.toJson<bool>(isOfflineMode),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  BanksData copyWith({
    int? id,
    String? uuid,
    Value<i2.Uint8List?> logo = const Value.absent(),
    Value<i2.Uint8List?> tinyLogo = const Value.absent(),
    String? name,
    String? description,
    String? legal,
    String? baseUrl,
    int? parallelUpdateJobs,
    int? amountOfSongsInRequest,
    bool? noCms,
    String? songFields,
    bool? isEnabled,
    bool? isOfflineMode,
    Value<DateTime?> lastUpdated = const Value.absent(),
  }) => BanksData(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    logo: logo.present ? logo.value : this.logo,
    tinyLogo: tinyLogo.present ? tinyLogo.value : this.tinyLogo,
    name: name ?? this.name,
    description: description ?? this.description,
    legal: legal ?? this.legal,
    baseUrl: baseUrl ?? this.baseUrl,
    parallelUpdateJobs: parallelUpdateJobs ?? this.parallelUpdateJobs,
    amountOfSongsInRequest:
        amountOfSongsInRequest ?? this.amountOfSongsInRequest,
    noCms: noCms ?? this.noCms,
    songFields: songFields ?? this.songFields,
    isEnabled: isEnabled ?? this.isEnabled,
    isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
  );
  BanksData copyWithCompanion(BanksCompanion data) {
    return BanksData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      logo: data.logo.present ? data.logo.value : this.logo,
      tinyLogo: data.tinyLogo.present ? data.tinyLogo.value : this.tinyLogo,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      legal: data.legal.present ? data.legal.value : this.legal,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      parallelUpdateJobs: data.parallelUpdateJobs.present
          ? data.parallelUpdateJobs.value
          : this.parallelUpdateJobs,
      amountOfSongsInRequest: data.amountOfSongsInRequest.present
          ? data.amountOfSongsInRequest.value
          : this.amountOfSongsInRequest,
      noCms: data.noCms.present ? data.noCms.value : this.noCms,
      songFields: data.songFields.present
          ? data.songFields.value
          : this.songFields,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      isOfflineMode: data.isOfflineMode.present
          ? data.isOfflineMode.value
          : this.isOfflineMode,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BanksData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('logo: $logo, ')
          ..write('tinyLogo: $tinyLogo, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('legal: $legal, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('parallelUpdateJobs: $parallelUpdateJobs, ')
          ..write('amountOfSongsInRequest: $amountOfSongsInRequest, ')
          ..write('noCms: $noCms, ')
          ..write('songFields: $songFields, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isOfflineMode: $isOfflineMode, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    $driftBlobEquality.hash(logo),
    $driftBlobEquality.hash(tinyLogo),
    name,
    description,
    legal,
    baseUrl,
    parallelUpdateJobs,
    amountOfSongsInRequest,
    noCms,
    songFields,
    isEnabled,
    isOfflineMode,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BanksData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          $driftBlobEquality.equals(other.logo, this.logo) &&
          $driftBlobEquality.equals(other.tinyLogo, this.tinyLogo) &&
          other.name == this.name &&
          other.description == this.description &&
          other.legal == this.legal &&
          other.baseUrl == this.baseUrl &&
          other.parallelUpdateJobs == this.parallelUpdateJobs &&
          other.amountOfSongsInRequest == this.amountOfSongsInRequest &&
          other.noCms == this.noCms &&
          other.songFields == this.songFields &&
          other.isEnabled == this.isEnabled &&
          other.isOfflineMode == this.isOfflineMode &&
          other.lastUpdated == this.lastUpdated);
}

class BanksCompanion extends UpdateCompanion<BanksData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<i2.Uint8List?> logo;
  final Value<i2.Uint8List?> tinyLogo;
  final Value<String> name;
  final Value<String> description;
  final Value<String> legal;
  final Value<String> baseUrl;
  final Value<int> parallelUpdateJobs;
  final Value<int> amountOfSongsInRequest;
  final Value<bool> noCms;
  final Value<String> songFields;
  final Value<bool> isEnabled;
  final Value<bool> isOfflineMode;
  final Value<DateTime?> lastUpdated;
  const BanksCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.logo = const Value.absent(),
    this.tinyLogo = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.legal = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.parallelUpdateJobs = const Value.absent(),
    this.amountOfSongsInRequest = const Value.absent(),
    this.noCms = const Value.absent(),
    this.songFields = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isOfflineMode = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  BanksCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    this.logo = const Value.absent(),
    this.tinyLogo = const Value.absent(),
    required String name,
    required String description,
    required String legal,
    required String baseUrl,
    required int parallelUpdateJobs,
    required int amountOfSongsInRequest,
    required bool noCms,
    required String songFields,
    required bool isEnabled,
    required bool isOfflineMode,
    this.lastUpdated = const Value.absent(),
  }) : uuid = Value(uuid),
       name = Value(name),
       description = Value(description),
       legal = Value(legal),
       baseUrl = Value(baseUrl),
       parallelUpdateJobs = Value(parallelUpdateJobs),
       amountOfSongsInRequest = Value(amountOfSongsInRequest),
       noCms = Value(noCms),
       songFields = Value(songFields),
       isEnabled = Value(isEnabled),
       isOfflineMode = Value(isOfflineMode);
  static Insertable<BanksData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<i2.Uint8List>? logo,
    Expression<i2.Uint8List>? tinyLogo,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? legal,
    Expression<String>? baseUrl,
    Expression<int>? parallelUpdateJobs,
    Expression<int>? amountOfSongsInRequest,
    Expression<bool>? noCms,
    Expression<String>? songFields,
    Expression<bool>? isEnabled,
    Expression<bool>? isOfflineMode,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (logo != null) 'logo': logo,
      if (tinyLogo != null) 'tiny_logo': tinyLogo,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (legal != null) 'legal': legal,
      if (baseUrl != null) 'base_url': baseUrl,
      if (parallelUpdateJobs != null)
        'parallel_update_jobs': parallelUpdateJobs,
      if (amountOfSongsInRequest != null)
        'amount_of_songs_in_request': amountOfSongsInRequest,
      if (noCms != null) 'no_cms': noCms,
      if (songFields != null) 'song_fields': songFields,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (isOfflineMode != null) 'is_offline_mode': isOfflineMode,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  BanksCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<i2.Uint8List?>? logo,
    Value<i2.Uint8List?>? tinyLogo,
    Value<String>? name,
    Value<String>? description,
    Value<String>? legal,
    Value<String>? baseUrl,
    Value<int>? parallelUpdateJobs,
    Value<int>? amountOfSongsInRequest,
    Value<bool>? noCms,
    Value<String>? songFields,
    Value<bool>? isEnabled,
    Value<bool>? isOfflineMode,
    Value<DateTime?>? lastUpdated,
  }) {
    return BanksCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      logo: logo ?? this.logo,
      tinyLogo: tinyLogo ?? this.tinyLogo,
      name: name ?? this.name,
      description: description ?? this.description,
      legal: legal ?? this.legal,
      baseUrl: baseUrl ?? this.baseUrl,
      parallelUpdateJobs: parallelUpdateJobs ?? this.parallelUpdateJobs,
      amountOfSongsInRequest:
          amountOfSongsInRequest ?? this.amountOfSongsInRequest,
      noCms: noCms ?? this.noCms,
      songFields: songFields ?? this.songFields,
      isEnabled: isEnabled ?? this.isEnabled,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (logo.present) {
      map['logo'] = Variable<i2.Uint8List>(logo.value);
    }
    if (tinyLogo.present) {
      map['tiny_logo'] = Variable<i2.Uint8List>(tinyLogo.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (legal.present) {
      map['legal'] = Variable<String>(legal.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (parallelUpdateJobs.present) {
      map['parallel_update_jobs'] = Variable<int>(parallelUpdateJobs.value);
    }
    if (amountOfSongsInRequest.present) {
      map['amount_of_songs_in_request'] = Variable<int>(
        amountOfSongsInRequest.value,
      );
    }
    if (noCms.present) {
      map['no_cms'] = Variable<bool>(noCms.value);
    }
    if (songFields.present) {
      map['song_fields'] = Variable<String>(songFields.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (isOfflineMode.present) {
      map['is_offline_mode'] = Variable<bool>(isOfflineMode.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BanksCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('logo: $logo, ')
          ..write('tinyLogo: $tinyLogo, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('legal: $legal, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('parallelUpdateJobs: $parallelUpdateJobs, ')
          ..write('amountOfSongsInRequest: $amountOfSongsInRequest, ')
          ..write('noCms: $noCms, ')
          ..write('songFields: $songFields, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isOfflineMode: $isOfflineMode, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class Songs extends Table with TableInfo<Songs, SongsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Songs(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> sourceBank = GeneratedColumn<String>(
    'source_bank',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES banks (uuid)',
    ),
  );
  late final GeneratedColumn<String> contentMap = GeneratedColumn<String>(
    'content_map',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> opensong = GeneratedColumn<String>(
    'opensong',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> composer = GeneratedColumn<String>(
    'composer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> lyricist = GeneratedColumn<String>(
    'lyricist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> translator = GeneratedColumn<String>(
    'translator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> keyField = GeneratedColumn<String>(
    'key_field',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> userNote = GeneratedColumn<String>(
    'user_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    sourceBank,
    contentMap,
    title,
    opensong,
    composer,
    lyricist,
    translator,
    keyField,
    userNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SongsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      sourceBank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_bank'],
      ),
      contentMap: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_map'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      opensong: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opensong'],
      )!,
      composer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}composer'],
      ),
      lyricist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lyricist'],
      ),
      translator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translator'],
      ),
      keyField: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_field'],
      )!,
      userNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_note'],
      ),
    );
  }

  @override
  Songs createAlias(String alias) {
    return Songs(attachedDatabase, alias);
  }
}

class SongsData extends DataClass implements Insertable<SongsData> {
  final int id;
  final String uuid;
  final String? sourceBank;
  final String contentMap;
  final String title;
  final String opensong;
  final String? composer;
  final String? lyricist;
  final String? translator;
  final String keyField;
  final String? userNote;
  const SongsData({
    required this.id,
    required this.uuid,
    this.sourceBank,
    required this.contentMap,
    required this.title,
    required this.opensong,
    this.composer,
    this.lyricist,
    this.translator,
    required this.keyField,
    this.userNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || sourceBank != null) {
      map['source_bank'] = Variable<String>(sourceBank);
    }
    map['content_map'] = Variable<String>(contentMap);
    map['title'] = Variable<String>(title);
    map['opensong'] = Variable<String>(opensong);
    if (!nullToAbsent || composer != null) {
      map['composer'] = Variable<String>(composer);
    }
    if (!nullToAbsent || lyricist != null) {
      map['lyricist'] = Variable<String>(lyricist);
    }
    if (!nullToAbsent || translator != null) {
      map['translator'] = Variable<String>(translator);
    }
    map['key_field'] = Variable<String>(keyField);
    if (!nullToAbsent || userNote != null) {
      map['user_note'] = Variable<String>(userNote);
    }
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      sourceBank: sourceBank == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceBank),
      contentMap: Value(contentMap),
      title: Value(title),
      opensong: Value(opensong),
      composer: composer == null && nullToAbsent
          ? const Value.absent()
          : Value(composer),
      lyricist: lyricist == null && nullToAbsent
          ? const Value.absent()
          : Value(lyricist),
      translator: translator == null && nullToAbsent
          ? const Value.absent()
          : Value(translator),
      keyField: Value(keyField),
      userNote: userNote == null && nullToAbsent
          ? const Value.absent()
          : Value(userNote),
    );
  }

  factory SongsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongsData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      sourceBank: serializer.fromJson<String?>(json['sourceBank']),
      contentMap: serializer.fromJson<String>(json['contentMap']),
      title: serializer.fromJson<String>(json['title']),
      opensong: serializer.fromJson<String>(json['opensong']),
      composer: serializer.fromJson<String?>(json['composer']),
      lyricist: serializer.fromJson<String?>(json['lyricist']),
      translator: serializer.fromJson<String?>(json['translator']),
      keyField: serializer.fromJson<String>(json['keyField']),
      userNote: serializer.fromJson<String?>(json['userNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'sourceBank': serializer.toJson<String?>(sourceBank),
      'contentMap': serializer.toJson<String>(contentMap),
      'title': serializer.toJson<String>(title),
      'opensong': serializer.toJson<String>(opensong),
      'composer': serializer.toJson<String?>(composer),
      'lyricist': serializer.toJson<String?>(lyricist),
      'translator': serializer.toJson<String?>(translator),
      'keyField': serializer.toJson<String>(keyField),
      'userNote': serializer.toJson<String?>(userNote),
    };
  }

  SongsData copyWith({
    int? id,
    String? uuid,
    Value<String?> sourceBank = const Value.absent(),
    String? contentMap,
    String? title,
    String? opensong,
    Value<String?> composer = const Value.absent(),
    Value<String?> lyricist = const Value.absent(),
    Value<String?> translator = const Value.absent(),
    String? keyField,
    Value<String?> userNote = const Value.absent(),
  }) => SongsData(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    sourceBank: sourceBank.present ? sourceBank.value : this.sourceBank,
    contentMap: contentMap ?? this.contentMap,
    title: title ?? this.title,
    opensong: opensong ?? this.opensong,
    composer: composer.present ? composer.value : this.composer,
    lyricist: lyricist.present ? lyricist.value : this.lyricist,
    translator: translator.present ? translator.value : this.translator,
    keyField: keyField ?? this.keyField,
    userNote: userNote.present ? userNote.value : this.userNote,
  );
  SongsData copyWithCompanion(SongsCompanion data) {
    return SongsData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      sourceBank: data.sourceBank.present
          ? data.sourceBank.value
          : this.sourceBank,
      contentMap: data.contentMap.present
          ? data.contentMap.value
          : this.contentMap,
      title: data.title.present ? data.title.value : this.title,
      opensong: data.opensong.present ? data.opensong.value : this.opensong,
      composer: data.composer.present ? data.composer.value : this.composer,
      lyricist: data.lyricist.present ? data.lyricist.value : this.lyricist,
      translator: data.translator.present
          ? data.translator.value
          : this.translator,
      keyField: data.keyField.present ? data.keyField.value : this.keyField,
      userNote: data.userNote.present ? data.userNote.value : this.userNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SongsData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('sourceBank: $sourceBank, ')
          ..write('contentMap: $contentMap, ')
          ..write('title: $title, ')
          ..write('opensong: $opensong, ')
          ..write('composer: $composer, ')
          ..write('lyricist: $lyricist, ')
          ..write('translator: $translator, ')
          ..write('keyField: $keyField, ')
          ..write('userNote: $userNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    sourceBank,
    contentMap,
    title,
    opensong,
    composer,
    lyricist,
    translator,
    keyField,
    userNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongsData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.sourceBank == this.sourceBank &&
          other.contentMap == this.contentMap &&
          other.title == this.title &&
          other.opensong == this.opensong &&
          other.composer == this.composer &&
          other.lyricist == this.lyricist &&
          other.translator == this.translator &&
          other.keyField == this.keyField &&
          other.userNote == this.userNote);
}

class SongsCompanion extends UpdateCompanion<SongsData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String?> sourceBank;
  final Value<String> contentMap;
  final Value<String> title;
  final Value<String> opensong;
  final Value<String?> composer;
  final Value<String?> lyricist;
  final Value<String?> translator;
  final Value<String> keyField;
  final Value<String?> userNote;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.sourceBank = const Value.absent(),
    this.contentMap = const Value.absent(),
    this.title = const Value.absent(),
    this.opensong = const Value.absent(),
    this.composer = const Value.absent(),
    this.lyricist = const Value.absent(),
    this.translator = const Value.absent(),
    this.keyField = const Value.absent(),
    this.userNote = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    this.sourceBank = const Value.absent(),
    required String contentMap,
    required String title,
    required String opensong,
    this.composer = const Value.absent(),
    this.lyricist = const Value.absent(),
    this.translator = const Value.absent(),
    required String keyField,
    this.userNote = const Value.absent(),
  }) : uuid = Value(uuid),
       contentMap = Value(contentMap),
       title = Value(title),
       opensong = Value(opensong),
       keyField = Value(keyField);
  static Insertable<SongsData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? sourceBank,
    Expression<String>? contentMap,
    Expression<String>? title,
    Expression<String>? opensong,
    Expression<String>? composer,
    Expression<String>? lyricist,
    Expression<String>? translator,
    Expression<String>? keyField,
    Expression<String>? userNote,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (sourceBank != null) 'source_bank': sourceBank,
      if (contentMap != null) 'content_map': contentMap,
      if (title != null) 'title': title,
      if (opensong != null) 'opensong': opensong,
      if (composer != null) 'composer': composer,
      if (lyricist != null) 'lyricist': lyricist,
      if (translator != null) 'translator': translator,
      if (keyField != null) 'key_field': keyField,
      if (userNote != null) 'user_note': userNote,
    });
  }

  SongsCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String?>? sourceBank,
    Value<String>? contentMap,
    Value<String>? title,
    Value<String>? opensong,
    Value<String?>? composer,
    Value<String?>? lyricist,
    Value<String?>? translator,
    Value<String>? keyField,
    Value<String?>? userNote,
  }) {
    return SongsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      sourceBank: sourceBank ?? this.sourceBank,
      contentMap: contentMap ?? this.contentMap,
      title: title ?? this.title,
      opensong: opensong ?? this.opensong,
      composer: composer ?? this.composer,
      lyricist: lyricist ?? this.lyricist,
      translator: translator ?? this.translator,
      keyField: keyField ?? this.keyField,
      userNote: userNote ?? this.userNote,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (sourceBank.present) {
      map['source_bank'] = Variable<String>(sourceBank.value);
    }
    if (contentMap.present) {
      map['content_map'] = Variable<String>(contentMap.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (opensong.present) {
      map['opensong'] = Variable<String>(opensong.value);
    }
    if (composer.present) {
      map['composer'] = Variable<String>(composer.value);
    }
    if (lyricist.present) {
      map['lyricist'] = Variable<String>(lyricist.value);
    }
    if (translator.present) {
      map['translator'] = Variable<String>(translator.value);
    }
    if (keyField.present) {
      map['key_field'] = Variable<String>(keyField.value);
    }
    if (userNote.present) {
      map['user_note'] = Variable<String>(userNote.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('sourceBank: $sourceBank, ')
          ..write('contentMap: $contentMap, ')
          ..write('title: $title, ')
          ..write('opensong: $opensong, ')
          ..write('composer: $composer, ')
          ..write('lyricist: $lyricist, ')
          ..write('translator: $translator, ')
          ..write('keyField: $keyField, ')
          ..write('userNote: $userNote')
          ..write(')'))
        .toString();
  }
}

class Assets extends Table with TableInfo<Assets, AssetsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Assets(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> songUuid = GeneratedColumn<String>(
    'song_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
    'field_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<i2.Uint8List> content =
      GeneratedColumn<i2.Uint8List>(
        'content',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    songUuid,
    sourceUrl,
    fieldName,
    content,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      songUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_uuid'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      fieldName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_name'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}content'],
      )!,
    );
  }

  @override
  Assets createAlias(String alias) {
    return Assets(attachedDatabase, alias);
  }
}

class AssetsData extends DataClass implements Insertable<AssetsData> {
  final int id;
  final String songUuid;
  final String sourceUrl;
  final String fieldName;
  final i2.Uint8List content;
  const AssetsData({
    required this.id,
    required this.songUuid,
    required this.sourceUrl,
    required this.fieldName,
    required this.content,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['song_uuid'] = Variable<String>(songUuid);
    map['source_url'] = Variable<String>(sourceUrl);
    map['field_name'] = Variable<String>(fieldName);
    map['content'] = Variable<i2.Uint8List>(content);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      songUuid: Value(songUuid),
      sourceUrl: Value(sourceUrl),
      fieldName: Value(fieldName),
      content: Value(content),
    );
  }

  factory AssetsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetsData(
      id: serializer.fromJson<int>(json['id']),
      songUuid: serializer.fromJson<String>(json['songUuid']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      content: serializer.fromJson<i2.Uint8List>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'songUuid': serializer.toJson<String>(songUuid),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'fieldName': serializer.toJson<String>(fieldName),
      'content': serializer.toJson<i2.Uint8List>(content),
    };
  }

  AssetsData copyWith({
    int? id,
    String? songUuid,
    String? sourceUrl,
    String? fieldName,
    i2.Uint8List? content,
  }) => AssetsData(
    id: id ?? this.id,
    songUuid: songUuid ?? this.songUuid,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    fieldName: fieldName ?? this.fieldName,
    content: content ?? this.content,
  );
  AssetsData copyWithCompanion(AssetsCompanion data) {
    return AssetsData(
      id: data.id.present ? data.id.value : this.id,
      songUuid: data.songUuid.present ? data.songUuid.value : this.songUuid,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      fieldName: data.fieldName.present ? data.fieldName.value : this.fieldName,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetsData(')
          ..write('id: $id, ')
          ..write('songUuid: $songUuid, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('fieldName: $fieldName, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    songUuid,
    sourceUrl,
    fieldName,
    $driftBlobEquality.hash(content),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetsData &&
          other.id == this.id &&
          other.songUuid == this.songUuid &&
          other.sourceUrl == this.sourceUrl &&
          other.fieldName == this.fieldName &&
          $driftBlobEquality.equals(other.content, this.content));
}

class AssetsCompanion extends UpdateCompanion<AssetsData> {
  final Value<int> id;
  final Value<String> songUuid;
  final Value<String> sourceUrl;
  final Value<String> fieldName;
  final Value<i2.Uint8List> content;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.songUuid = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.content = const Value.absent(),
  });
  AssetsCompanion.insert({
    this.id = const Value.absent(),
    required String songUuid,
    required String sourceUrl,
    required String fieldName,
    required i2.Uint8List content,
  }) : songUuid = Value(songUuid),
       sourceUrl = Value(sourceUrl),
       fieldName = Value(fieldName),
       content = Value(content);
  static Insertable<AssetsData> custom({
    Expression<int>? id,
    Expression<String>? songUuid,
    Expression<String>? sourceUrl,
    Expression<String>? fieldName,
    Expression<i2.Uint8List>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songUuid != null) 'song_uuid': songUuid,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (fieldName != null) 'field_name': fieldName,
      if (content != null) 'content': content,
    });
  }

  AssetsCompanion copyWith({
    Value<int>? id,
    Value<String>? songUuid,
    Value<String>? sourceUrl,
    Value<String>? fieldName,
    Value<i2.Uint8List>? content,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      songUuid: songUuid ?? this.songUuid,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      fieldName: fieldName ?? this.fieldName,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (songUuid.present) {
      map['song_uuid'] = Variable<String>(songUuid.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (content.present) {
      map['content'] = Variable<i2.Uint8List>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('songUuid: $songUuid, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('fieldName: $fieldName, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class Cues extends Table with TableInfo<Cues, CuesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Cues(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> cueVersion = GeneratedColumn<int>(
    'cue_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    title,
    description,
    cueVersion,
    content,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cues';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CuesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      cueVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cue_version'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
    );
  }

  @override
  Cues createAlias(String alias) {
    return Cues(attachedDatabase, alias);
  }
}

class CuesData extends DataClass implements Insertable<CuesData> {
  final int id;
  final String uuid;
  final String title;
  final String description;
  final int cueVersion;
  final String content;
  const CuesData({
    required this.id,
    required this.uuid,
    required this.title,
    required this.description,
    required this.cueVersion,
    required this.content,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['cue_version'] = Variable<int>(cueVersion);
    map['content'] = Variable<String>(content);
    return map;
  }

  CuesCompanion toCompanion(bool nullToAbsent) {
    return CuesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      title: Value(title),
      description: Value(description),
      cueVersion: Value(cueVersion),
      content: Value(content),
    );
  }

  factory CuesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CuesData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      cueVersion: serializer.fromJson<int>(json['cueVersion']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'cueVersion': serializer.toJson<int>(cueVersion),
      'content': serializer.toJson<String>(content),
    };
  }

  CuesData copyWith({
    int? id,
    String? uuid,
    String? title,
    String? description,
    int? cueVersion,
    String? content,
  }) => CuesData(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    title: title ?? this.title,
    description: description ?? this.description,
    cueVersion: cueVersion ?? this.cueVersion,
    content: content ?? this.content,
  );
  CuesData copyWithCompanion(CuesCompanion data) {
    return CuesData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      cueVersion: data.cueVersion.present
          ? data.cueVersion.value
          : this.cueVersion,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CuesData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('cueVersion: $cueVersion, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, title, description, cueVersion, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CuesData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.title == this.title &&
          other.description == this.description &&
          other.cueVersion == this.cueVersion &&
          other.content == this.content);
}

class CuesCompanion extends UpdateCompanion<CuesData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> title;
  final Value<String> description;
  final Value<int> cueVersion;
  final Value<String> content;
  const CuesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.cueVersion = const Value.absent(),
    this.content = const Value.absent(),
  });
  CuesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String title,
    required String description,
    required int cueVersion,
    required String content,
  }) : uuid = Value(uuid),
       title = Value(title),
       description = Value(description),
       cueVersion = Value(cueVersion),
       content = Value(content);
  static Insertable<CuesData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? cueVersion,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (cueVersion != null) 'cue_version': cueVersion,
      if (content != null) 'content': content,
    });
  }

  CuesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? title,
    Value<String>? description,
    Value<int>? cueVersion,
    Value<String>? content,
  }) {
    return CuesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      cueVersion: cueVersion ?? this.cueVersion,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cueVersion.present) {
      map['cue_version'] = Variable<int>(cueVersion.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('cueVersion: $cueVersion, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class PreferenceStorage extends Table
    with TableInfo<PreferenceStorage, PreferenceStorageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PreferenceStorage(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_storage';
  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  PreferenceStorageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceStorageData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  PreferenceStorage createAlias(String alias) {
    return PreferenceStorage(attachedDatabase, alias);
  }
}

class PreferenceStorageData extends DataClass
    implements Insertable<PreferenceStorageData> {
  final String key;
  final String value;
  const PreferenceStorageData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferenceStorageCompanion toCompanion(bool nullToAbsent) {
    return PreferenceStorageCompanion(key: Value(key), value: Value(value));
  }

  factory PreferenceStorageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceStorageData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferenceStorageData copyWith({String? key, String? value}) =>
      PreferenceStorageData(key: key ?? this.key, value: value ?? this.value);
  PreferenceStorageData copyWithCompanion(PreferenceStorageCompanion data) {
    return PreferenceStorageData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceStorageData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceStorageData &&
          other.key == this.key &&
          other.value == this.value);
}

class PreferenceStorageCompanion
    extends UpdateCompanion<PreferenceStorageData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const PreferenceStorageCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferenceStorageCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<PreferenceStorageData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferenceStorageCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return PreferenceStorageCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceStorageCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SongsFts extends Table
    with
        TableInfo<SongsFts, SongsFtsData>,
        VirtualTableInfo<SongsFts, SongsFtsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SongsFts(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> opensong = GeneratedColumn<String>(
    'opensong',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> composer = GeneratedColumn<String>(
    'composer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> lyricist = GeneratedColumn<String>(
    'lyricist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> translator = GeneratedColumn<String>(
    'translator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    title,
    opensong,
    composer,
    lyricist,
    translator,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs_fts';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SongsFtsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongsFtsData(
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      opensong: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opensong'],
      )!,
      composer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}composer'],
      )!,
      lyricist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lyricist'],
      )!,
      translator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translator'],
      )!,
    );
  }

  @override
  SongsFts createAlias(String alias) {
    return SongsFts(attachedDatabase, alias);
  }

  @override
  String get moduleAndArgs =>
      'fts5(title, opensong, composer, lyricist, translator, content=\'songs\', content_rowid=\'id\', tokenize=\'trigram remove_diacritics 1\')';
}

class SongsFtsData extends DataClass implements Insertable<SongsFtsData> {
  final String title;
  final String opensong;
  final String composer;
  final String lyricist;
  final String translator;
  const SongsFtsData({
    required this.title,
    required this.opensong,
    required this.composer,
    required this.lyricist,
    required this.translator,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['title'] = Variable<String>(title);
    map['opensong'] = Variable<String>(opensong);
    map['composer'] = Variable<String>(composer);
    map['lyricist'] = Variable<String>(lyricist);
    map['translator'] = Variable<String>(translator);
    return map;
  }

  SongsFtsCompanion toCompanion(bool nullToAbsent) {
    return SongsFtsCompanion(
      title: Value(title),
      opensong: Value(opensong),
      composer: Value(composer),
      lyricist: Value(lyricist),
      translator: Value(translator),
    );
  }

  factory SongsFtsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongsFtsData(
      title: serializer.fromJson<String>(json['title']),
      opensong: serializer.fromJson<String>(json['opensong']),
      composer: serializer.fromJson<String>(json['composer']),
      lyricist: serializer.fromJson<String>(json['lyricist']),
      translator: serializer.fromJson<String>(json['translator']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'opensong': serializer.toJson<String>(opensong),
      'composer': serializer.toJson<String>(composer),
      'lyricist': serializer.toJson<String>(lyricist),
      'translator': serializer.toJson<String>(translator),
    };
  }

  SongsFtsData copyWith({
    String? title,
    String? opensong,
    String? composer,
    String? lyricist,
    String? translator,
  }) => SongsFtsData(
    title: title ?? this.title,
    opensong: opensong ?? this.opensong,
    composer: composer ?? this.composer,
    lyricist: lyricist ?? this.lyricist,
    translator: translator ?? this.translator,
  );
  SongsFtsData copyWithCompanion(SongsFtsCompanion data) {
    return SongsFtsData(
      title: data.title.present ? data.title.value : this.title,
      opensong: data.opensong.present ? data.opensong.value : this.opensong,
      composer: data.composer.present ? data.composer.value : this.composer,
      lyricist: data.lyricist.present ? data.lyricist.value : this.lyricist,
      translator: data.translator.present
          ? data.translator.value
          : this.translator,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SongsFtsData(')
          ..write('title: $title, ')
          ..write('opensong: $opensong, ')
          ..write('composer: $composer, ')
          ..write('lyricist: $lyricist, ')
          ..write('translator: $translator')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(title, opensong, composer, lyricist, translator);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongsFtsData &&
          other.title == this.title &&
          other.opensong == this.opensong &&
          other.composer == this.composer &&
          other.lyricist == this.lyricist &&
          other.translator == this.translator);
}

class SongsFtsCompanion extends UpdateCompanion<SongsFtsData> {
  final Value<String> title;
  final Value<String> opensong;
  final Value<String> composer;
  final Value<String> lyricist;
  final Value<String> translator;
  final Value<int> rowid;
  const SongsFtsCompanion({
    this.title = const Value.absent(),
    this.opensong = const Value.absent(),
    this.composer = const Value.absent(),
    this.lyricist = const Value.absent(),
    this.translator = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongsFtsCompanion.insert({
    required String title,
    required String opensong,
    required String composer,
    required String lyricist,
    required String translator,
    this.rowid = const Value.absent(),
  }) : title = Value(title),
       opensong = Value(opensong),
       composer = Value(composer),
       lyricist = Value(lyricist),
       translator = Value(translator);
  static Insertable<SongsFtsData> custom({
    Expression<String>? title,
    Expression<String>? opensong,
    Expression<String>? composer,
    Expression<String>? lyricist,
    Expression<String>? translator,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (title != null) 'title': title,
      if (opensong != null) 'opensong': opensong,
      if (composer != null) 'composer': composer,
      if (lyricist != null) 'lyricist': lyricist,
      if (translator != null) 'translator': translator,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongsFtsCompanion copyWith({
    Value<String>? title,
    Value<String>? opensong,
    Value<String>? composer,
    Value<String>? lyricist,
    Value<String>? translator,
    Value<int>? rowid,
  }) {
    return SongsFtsCompanion(
      title: title ?? this.title,
      opensong: opensong ?? this.opensong,
      composer: composer ?? this.composer,
      lyricist: lyricist ?? this.lyricist,
      translator: translator ?? this.translator,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (opensong.present) {
      map['opensong'] = Variable<String>(opensong.value);
    }
    if (composer.present) {
      map['composer'] = Variable<String>(composer.value);
    }
    if (lyricist.present) {
      map['lyricist'] = Variable<String>(lyricist.value);
    }
    if (translator.present) {
      map['translator'] = Variable<String>(translator.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsFtsCompanion(')
          ..write('title: $title, ')
          ..write('opensong: $opensong, ')
          ..write('composer: $composer, ')
          ..write('lyricist: $lyricist, ')
          ..write('translator: $translator, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final Banks banks = Banks(this);
  late final Songs songs = Songs(this);
  late final Index songsUuid = Index(
    'songs_uuid',
    'CREATE UNIQUE INDEX songs_uuid ON songs (uuid)',
  );
  late final Assets assets = Assets(this);
  late final Index assetSourceUrl = Index(
    'asset_source_url',
    'CREATE UNIQUE INDEX asset_source_url ON assets (source_url)',
  );
  late final Cues cues = Cues(this);
  late final Index cuesUuid = Index(
    'cues_uuid',
    'CREATE UNIQUE INDEX cues_uuid ON cues (uuid)',
  );
  late final PreferenceStorage preferenceStorage = PreferenceStorage(this);
  late final SongsFts songsFts = SongsFts(this);
  late final Trigger songsAi = Trigger(
    'CREATE TRIGGER songs_ai AFTER INSERT ON songs BEGIN INSERT INTO songs_fts ("rowid", title, opensong, composer, lyricist, translator) VALUES (new.id, new.title, new.opensong, new.composer, new.lyricist, new.translator);END',
    'songs_ai',
  );
  late final Trigger songsAd = Trigger(
    'CREATE TRIGGER songs_ad AFTER DELETE ON songs BEGIN INSERT INTO songs_fts (songs_fts, "rowid", title, opensong, composer, lyricist, translator) VALUES (\'delete\', "rowid", old.title, old.opensong, old.composer, old.lyricist, old.translator);END',
    'songs_ad',
  );
  late final Trigger songsAu = Trigger(
    'CREATE TRIGGER songs_au AFTER UPDATE ON songs BEGIN INSERT INTO songs_fts (songs_fts, "rowid", title, opensong, composer, lyricist, translator) VALUES (\'delete\', "rowid", old.title, old.opensong, old.composer, old.lyricist, old.translator);INSERT INTO songs_fts ("rowid", title, opensong, composer, lyricist, translator) VALUES (new.id, new.title, new.opensong, new.composer, new.lyricist, new.translator);END',
    'songs_au',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    banks,
    songs,
    songsUuid,
    assets,
    assetSourceUrl,
    cues,
    cuesUuid,
    preferenceStorage,
    songsFts,
    songsAi,
    songsAd,
    songsAu,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
  ]);
  @override
  int get schemaVersion => 1;
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
