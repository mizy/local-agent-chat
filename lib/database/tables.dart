import 'package:drift/drift.dart';

class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(max: 64)();
  TextColumn get avatar => text().withLength()();
  TextColumn get sumarizePrompt =>
      text().withLength(max: 200).withDefault(const Constant(""))();
  TextColumn get summaryTitle =>
      text().withLength(max: 64).withDefault(const Constant(""))();
  IntColumn get sumarizeMsgId => integer().nullable()();
  TextColumn get systemPrompt => text().nullable()();
  // agentid
  IntColumn get agentId =>
      integer().customConstraint('REFERENCES agents(id)').nullable()();
}

enum MessageType {
  text,
  image,
  audio,
}

class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chatId =>
      integer().customConstraint('REFERENCES chats(id) NOT NULL')();
  TextColumn get message => text().withLength(min: 1)();
  IntColumn get type => integer().withDefault(const Constant(0))();
  TextColumn get author => text().withLength(max: 64)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Agents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 64)();
  TextColumn get avatar => text().withLength()();
  TextColumn get description => text().withLength(max: 200).nullable()();
  TextColumn get system => text().withLength(max: 2048).nullable()();
  TextColumn get fewShot => text().withLength(max: 2048).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
