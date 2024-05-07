// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AgentsTable extends Agents with TableInfo<$AgentsTable, Agent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgentsTable(this.attachedDatabase, [this._alias]);
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
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _systemMeta = const VerificationMeta('system');
  @override
  late final GeneratedColumn<String> system = GeneratedColumn<String>(
      'system', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 2048),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _fewShotMeta =
      const VerificationMeta('fewShot');
  @override
  late final GeneratedColumn<String> fewShot = GeneratedColumn<String>(
      'few_shot', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 2048),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, avatar, description, system, fewShot, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agents';
  @override
  VerificationContext validateIntegrity(Insertable<Agent> instance,
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
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    } else if (isInserting) {
      context.missing(_avatarMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('system')) {
      context.handle(_systemMeta,
          system.isAcceptableOrUnknown(data['system']!, _systemMeta));
    }
    if (data.containsKey('few_shot')) {
      context.handle(_fewShotMeta,
          fewShot.isAcceptableOrUnknown(data['few_shot']!, _fewShotMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Agent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Agent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      system: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system']),
      fewShot: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}few_shot']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AgentsTable createAlias(String alias) {
    return $AgentsTable(attachedDatabase, alias);
  }
}

class Agent extends DataClass implements Insertable<Agent> {
  final int id;
  final String name;
  final String avatar;
  final String? description;
  final String? system;
  final String? fewShot;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Agent(
      {required this.id,
      required this.name,
      required this.avatar,
      this.description,
      this.system,
      this.fewShot,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['avatar'] = Variable<String>(avatar);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || system != null) {
      map['system'] = Variable<String>(system);
    }
    if (!nullToAbsent || fewShot != null) {
      map['few_shot'] = Variable<String>(fewShot);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AgentsCompanion toCompanion(bool nullToAbsent) {
    return AgentsCompanion(
      id: Value(id),
      name: Value(name),
      avatar: Value(avatar),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      system:
          system == null && nullToAbsent ? const Value.absent() : Value(system),
      fewShot: fewShot == null && nullToAbsent
          ? const Value.absent()
          : Value(fewShot),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Agent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Agent(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String>(json['avatar']),
      description: serializer.fromJson<String?>(json['description']),
      system: serializer.fromJson<String?>(json['system']),
      fewShot: serializer.fromJson<String?>(json['fewShot']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String>(avatar),
      'description': serializer.toJson<String?>(description),
      'system': serializer.toJson<String?>(system),
      'fewShot': serializer.toJson<String?>(fewShot),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Agent copyWith(
          {int? id,
          String? name,
          String? avatar,
          Value<String?> description = const Value.absent(),
          Value<String?> system = const Value.absent(),
          Value<String?> fewShot = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Agent(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        description: description.present ? description.value : this.description,
        system: system.present ? system.value : this.system,
        fewShot: fewShot.present ? fewShot.value : this.fewShot,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Agent(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('description: $description, ')
          ..write('system: $system, ')
          ..write('fewShot: $fewShot, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, avatar, description, system, fewShot, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Agent &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.description == this.description &&
          other.system == this.system &&
          other.fewShot == this.fewShot &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AgentsCompanion extends UpdateCompanion<Agent> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> avatar;
  final Value<String?> description;
  final Value<String?> system;
  final Value<String?> fewShot;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AgentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.description = const Value.absent(),
    this.system = const Value.absent(),
    this.fewShot = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AgentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String avatar,
    this.description = const Value.absent(),
    this.system = const Value.absent(),
    this.fewShot = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        avatar = Value(avatar);
  static Insertable<Agent> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<String>? description,
    Expression<String>? system,
    Expression<String>? fewShot,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (description != null) 'description': description,
      if (system != null) 'system': system,
      if (fewShot != null) 'few_shot': fewShot,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AgentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? avatar,
      Value<String?>? description,
      Value<String?>? system,
      Value<String?>? fewShot,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AgentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      system: system ?? this.system,
      fewShot: fewShot ?? this.fewShot,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (system.present) {
      map['system'] = Variable<String>(system.value);
    }
    if (fewShot.present) {
      map['few_shot'] = Variable<String>(fewShot.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('description: $description, ')
          ..write('system: $system, ')
          ..write('fewShot: $fewShot, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _sumarizePromptMeta =
      const VerificationMeta('sumarizePrompt');
  @override
  late final GeneratedColumn<String> sumarizePrompt = GeneratedColumn<String>(
      'sumarize_prompt', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(""));
  static const VerificationMeta _summaryTitleMeta =
      const VerificationMeta('summaryTitle');
  @override
  late final GeneratedColumn<String> summaryTitle = GeneratedColumn<String>(
      'summary_title', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(""));
  static const VerificationMeta _sumarizeMsgIdMeta =
      const VerificationMeta('sumarizeMsgId');
  @override
  late final GeneratedColumn<int> sumarizeMsgId = GeneratedColumn<int>(
      'sumarize_msg_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _systemPromptMeta =
      const VerificationMeta('systemPrompt');
  @override
  late final GeneratedColumn<String> systemPrompt = GeneratedColumn<String>(
      'system_prompt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _agentIdMeta =
      const VerificationMeta('agentId');
  @override
  late final GeneratedColumn<int> agentId = GeneratedColumn<int>(
      'agent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES agents(id)');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        avatar,
        sumarizePrompt,
        summaryTitle,
        sumarizeMsgId,
        systemPrompt,
        agentId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(Insertable<Chat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    } else if (isInserting) {
      context.missing(_avatarMeta);
    }
    if (data.containsKey('sumarize_prompt')) {
      context.handle(
          _sumarizePromptMeta,
          sumarizePrompt.isAcceptableOrUnknown(
              data['sumarize_prompt']!, _sumarizePromptMeta));
    }
    if (data.containsKey('summary_title')) {
      context.handle(
          _summaryTitleMeta,
          summaryTitle.isAcceptableOrUnknown(
              data['summary_title']!, _summaryTitleMeta));
    }
    if (data.containsKey('sumarize_msg_id')) {
      context.handle(
          _sumarizeMsgIdMeta,
          sumarizeMsgId.isAcceptableOrUnknown(
              data['sumarize_msg_id']!, _sumarizeMsgIdMeta));
    }
    if (data.containsKey('system_prompt')) {
      context.handle(
          _systemPromptMeta,
          systemPrompt.isAcceptableOrUnknown(
              data['system_prompt']!, _systemPromptMeta));
    }
    if (data.containsKey('agent_id')) {
      context.handle(_agentIdMeta,
          agentId.isAcceptableOrUnknown(data['agent_id']!, _agentIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar'])!,
      sumarizePrompt: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sumarize_prompt'])!,
      summaryTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary_title'])!,
      sumarizeMsgId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sumarize_msg_id']),
      systemPrompt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_prompt']),
      agentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}agent_id']),
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class Chat extends DataClass implements Insertable<Chat> {
  final int id;
  final String title;
  final String avatar;
  final String sumarizePrompt;
  final String summaryTitle;
  final int? sumarizeMsgId;
  final String? systemPrompt;
  final int? agentId;
  const Chat(
      {required this.id,
      required this.title,
      required this.avatar,
      required this.sumarizePrompt,
      required this.summaryTitle,
      this.sumarizeMsgId,
      this.systemPrompt,
      this.agentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['avatar'] = Variable<String>(avatar);
    map['sumarize_prompt'] = Variable<String>(sumarizePrompt);
    map['summary_title'] = Variable<String>(summaryTitle);
    if (!nullToAbsent || sumarizeMsgId != null) {
      map['sumarize_msg_id'] = Variable<int>(sumarizeMsgId);
    }
    if (!nullToAbsent || systemPrompt != null) {
      map['system_prompt'] = Variable<String>(systemPrompt);
    }
    if (!nullToAbsent || agentId != null) {
      map['agent_id'] = Variable<int>(agentId);
    }
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      title: Value(title),
      avatar: Value(avatar),
      sumarizePrompt: Value(sumarizePrompt),
      summaryTitle: Value(summaryTitle),
      sumarizeMsgId: sumarizeMsgId == null && nullToAbsent
          ? const Value.absent()
          : Value(sumarizeMsgId),
      systemPrompt: systemPrompt == null && nullToAbsent
          ? const Value.absent()
          : Value(systemPrompt),
      agentId: agentId == null && nullToAbsent
          ? const Value.absent()
          : Value(agentId),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      avatar: serializer.fromJson<String>(json['avatar']),
      sumarizePrompt: serializer.fromJson<String>(json['sumarizePrompt']),
      summaryTitle: serializer.fromJson<String>(json['summaryTitle']),
      sumarizeMsgId: serializer.fromJson<int?>(json['sumarizeMsgId']),
      systemPrompt: serializer.fromJson<String?>(json['systemPrompt']),
      agentId: serializer.fromJson<int?>(json['agentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'avatar': serializer.toJson<String>(avatar),
      'sumarizePrompt': serializer.toJson<String>(sumarizePrompt),
      'summaryTitle': serializer.toJson<String>(summaryTitle),
      'sumarizeMsgId': serializer.toJson<int?>(sumarizeMsgId),
      'systemPrompt': serializer.toJson<String?>(systemPrompt),
      'agentId': serializer.toJson<int?>(agentId),
    };
  }

  Chat copyWith(
          {int? id,
          String? title,
          String? avatar,
          String? sumarizePrompt,
          String? summaryTitle,
          Value<int?> sumarizeMsgId = const Value.absent(),
          Value<String?> systemPrompt = const Value.absent(),
          Value<int?> agentId = const Value.absent()}) =>
      Chat(
        id: id ?? this.id,
        title: title ?? this.title,
        avatar: avatar ?? this.avatar,
        sumarizePrompt: sumarizePrompt ?? this.sumarizePrompt,
        summaryTitle: summaryTitle ?? this.summaryTitle,
        sumarizeMsgId:
            sumarizeMsgId.present ? sumarizeMsgId.value : this.sumarizeMsgId,
        systemPrompt:
            systemPrompt.present ? systemPrompt.value : this.systemPrompt,
        agentId: agentId.present ? agentId.value : this.agentId,
      );
  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('avatar: $avatar, ')
          ..write('sumarizePrompt: $sumarizePrompt, ')
          ..write('summaryTitle: $summaryTitle, ')
          ..write('sumarizeMsgId: $sumarizeMsgId, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('agentId: $agentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, avatar, sumarizePrompt,
      summaryTitle, sumarizeMsgId, systemPrompt, agentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.id == this.id &&
          other.title == this.title &&
          other.avatar == this.avatar &&
          other.sumarizePrompt == this.sumarizePrompt &&
          other.summaryTitle == this.summaryTitle &&
          other.sumarizeMsgId == this.sumarizeMsgId &&
          other.systemPrompt == this.systemPrompt &&
          other.agentId == this.agentId);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> avatar;
  final Value<String> sumarizePrompt;
  final Value<String> summaryTitle;
  final Value<int?> sumarizeMsgId;
  final Value<String?> systemPrompt;
  final Value<int?> agentId;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.avatar = const Value.absent(),
    this.sumarizePrompt = const Value.absent(),
    this.summaryTitle = const Value.absent(),
    this.sumarizeMsgId = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.agentId = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String avatar,
    this.sumarizePrompt = const Value.absent(),
    this.summaryTitle = const Value.absent(),
    this.sumarizeMsgId = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.agentId = const Value.absent(),
  })  : title = Value(title),
        avatar = Value(avatar);
  static Insertable<Chat> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? avatar,
    Expression<String>? sumarizePrompt,
    Expression<String>? summaryTitle,
    Expression<int>? sumarizeMsgId,
    Expression<String>? systemPrompt,
    Expression<int>? agentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (avatar != null) 'avatar': avatar,
      if (sumarizePrompt != null) 'sumarize_prompt': sumarizePrompt,
      if (summaryTitle != null) 'summary_title': summaryTitle,
      if (sumarizeMsgId != null) 'sumarize_msg_id': sumarizeMsgId,
      if (systemPrompt != null) 'system_prompt': systemPrompt,
      if (agentId != null) 'agent_id': agentId,
    });
  }

  ChatsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? avatar,
      Value<String>? sumarizePrompt,
      Value<String>? summaryTitle,
      Value<int?>? sumarizeMsgId,
      Value<String?>? systemPrompt,
      Value<int?>? agentId}) {
    return ChatsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      avatar: avatar ?? this.avatar,
      sumarizePrompt: sumarizePrompt ?? this.sumarizePrompt,
      summaryTitle: summaryTitle ?? this.summaryTitle,
      sumarizeMsgId: sumarizeMsgId ?? this.sumarizeMsgId,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      agentId: agentId ?? this.agentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (sumarizePrompt.present) {
      map['sumarize_prompt'] = Variable<String>(sumarizePrompt.value);
    }
    if (summaryTitle.present) {
      map['summary_title'] = Variable<String>(summaryTitle.value);
    }
    if (sumarizeMsgId.present) {
      map['sumarize_msg_id'] = Variable<int>(sumarizeMsgId.value);
    }
    if (systemPrompt.present) {
      map['system_prompt'] = Variable<String>(systemPrompt.value);
    }
    if (agentId.present) {
      map['agent_id'] = Variable<int>(agentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('avatar: $avatar, ')
          ..write('sumarizePrompt: $sumarizePrompt, ')
          ..write('summaryTitle: $summaryTitle, ')
          ..write('sumarizeMsgId: $sumarizeMsgId, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('agentId: $agentId')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES chats(id) NOT NULL');
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message =
      GeneratedColumn<String>('message', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, chatId, message, type, author, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chat_id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final int id;
  final int chatId;
  final String message;
  final int type;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Message(
      {required this.id,
      required this.chatId,
      required this.message,
      required this.type,
      required this.author,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_id'] = Variable<int>(chatId);
    map['message'] = Variable<String>(message);
    map['type'] = Variable<int>(type);
    map['author'] = Variable<String>(author);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      message: Value(message),
      type: Value(type),
      author: Value(author),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      message: serializer.fromJson<String>(json['message']),
      type: serializer.fromJson<int>(json['type']),
      author: serializer.fromJson<String>(json['author']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chatId': serializer.toJson<int>(chatId),
      'message': serializer.toJson<String>(message),
      'type': serializer.toJson<int>(type),
      'author': serializer.toJson<String>(author),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Message copyWith(
          {int? id,
          int? chatId,
          String? message,
          int? type,
          String? author,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Message(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        message: message ?? this.message,
        type: type ?? this.type,
        author: author ?? this.author,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('message: $message, ')
          ..write('type: $type, ')
          ..write('author: $author, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chatId, message, type, author, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.message == this.message &&
          other.type == this.type &&
          other.author == this.author &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<int> id;
  final Value<int> chatId;
  final Value<String> message;
  final Value<int> type;
  final Value<String> author;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.message = const Value.absent(),
    this.type = const Value.absent(),
    this.author = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required int chatId,
    required String message,
    this.type = const Value.absent(),
    required String author,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : chatId = Value(chatId),
        message = Value(message),
        author = Value(author);
  static Insertable<Message> custom({
    Expression<int>? id,
    Expression<int>? chatId,
    Expression<String>? message,
    Expression<int>? type,
    Expression<String>? author,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (message != null) 'message': message,
      if (type != null) 'type': type,
      if (author != null) 'author': author,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MessagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? chatId,
      Value<String>? message,
      Value<int>? type,
      Value<String>? author,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MessagesCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      message: message ?? this.message,
      type: type ?? this.type,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('message: $message, ')
          ..write('type: $type, ')
          ..write('author: $author, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $AgentsTable agents = $AgentsTable(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [agents, chats, messages];
}
