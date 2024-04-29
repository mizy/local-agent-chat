import 'dart:io';

import 'package:chat_gguf/chat_list/chat_session.dart';
import 'package:chat_gguf/database/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class ChatWithLastMessage {
  final Chat chat;
  final String lastMessageContent;
  final DateTime lastMessageTime;

  ChatWithLastMessage({
    required this.chat,
    required this.lastMessageContent,
    required this.lastMessageTime,
  });
}

@DriftDatabase(tables: [Chats, Messages, Agents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
    }, onUpgrade: (Migrator m, int from, int to) async {
      autoMigrate(m);
    });
  }

  Future<void> autoMigrate(Migrator m) async {
    final nowTables = m.database.allTables;
    final allTablesBefore =
        await customSelect('SELECT name FROM sqlite_master WHERE type="table"')
            .map((QueryRow row) => row.read<String>('name'))
            .get();

    for (var table in nowTables) {
      if (!allTablesBefore.contains(table.actualTableName)) {
        await m.createTable(table);
      } else {
        final columnsBefore = await customSelect(
                'PRAGMA table_info(${table.actualTableName})',
                readsFrom: {table})
            .map((QueryRow row) => row.read<String>('name'))
            .get();
        for (var column in table.$columns) {
          if (!columnsBefore.contains(column.$name)) {
            await m.addColumn(table, column);
          }
        }
      }
    }
  }

  Future<List<ChatSession>> getChatsWithLastMessage() {
    Future<List<ChatSession>> sessions = Future.value([]);
    try {
      sessions = customSelect(
        'SELECT c.*, m.message AS last_message_content, MAX(m.updated_at) AS last_message_time '
        'FROM Chats c '
        'LEFT JOIN Messages m ON c.id = m.chat_id '
        'GROUP BY c.id '
        'ORDER BY last_message_time DESC',
        readsFrom: {chats, messages},
      ).map((row) {
        final avatarUrl = row.read<String>('avatar');
        return ChatSession(
          lastMessageTime: row.read<DateTime?>('last_message_time'),
          id: row.read<int>('id'),
          name: row.read<String>('title'),
          lastMessage: row.read<String?>('last_message_content'),
          avatar: avatarUrl,
        );
      }).get();
    } catch (e) {
      print(e);
    }
    return sessions;
  }

  Future<Chat> getChatById(int id) {
    return (select(chats)..where((c) => c.id.equals(id))).getSingle();
  }

  Future<List<Message>> getMessagesByChatId(int chatId) {
    return (select(messages)
          ..where((m) => m.chatId.equals(chatId))
          ..orderBy(
              [(m) => OrderingTerm.desc(m.createdAt)]) // 根据createdAt字段降序排序
          ..limit(20))
        .get();
  }

  Future<int> deleteChat(int id) {
    return transaction<int>(() async {
      await (delete(messages)..where((m) => m.chatId.equals(id))).go();
      await (delete(chats)..where((c) => c.id.equals(id))).go();
      return 1;
    });
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    if (!kReleaseMode) {
      // 在开发模式和测试模式下，删除数据库文件
      if (await file.exists()) {
        await file.delete();
      }
    }
    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
