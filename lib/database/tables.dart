import 'package:drift/drift.dart';

class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(max: 64)();
  TextColumn get avatar => text().withLength()();
  TextColumn get sumarizePrompt =>
      text().withLength(max: 200).withDefault(const Constant(""))();
  TextColumn get summaryTitle =>
      text().withLength(max: 64).withDefault(const Constant(""))();
  IntColumn get sumarizeMsgId =>
      integer().customConstraint('REFERENCES messages(id)').nullable()();
  TextColumn get systemPrompt => text().nullable()();
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
