import 'dart:io';

import 'package:chat_gguf/chat_list/chat_session.dart';
import 'package:chat_gguf/database/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

@DriftDatabase(tables: [Chats, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        m.database.allTables;
        m.database.allSchemaEntities;
      },
    );
  }

  Future<List<ChatSession>> getChatsWithLastMessage() {
    Future<List<ChatSession>> sessions = Future.value([]);
    try {
      sessions = customSelect(
        'SELECT c.*, m.message AS last_message_content, m.updatedAt AS last_message_time '
        'FROM Chats c '
        'LEFT JOIN Messages m ON c.id = m.chat_id '
        'GROUP BY c.id '
        'ORDER BY m.updatedAt DESC',
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
