import 'package:chat_gguf/bottom_bar/bar.dart';
import 'package:chat_gguf/chat_list/chat_session.dart';
import 'package:chat_gguf/chat_list/load_status.dart';
import 'package:chat_gguf/database/database.dart';
import 'package:chat_gguf/main.dart';
import 'package:chat_gguf/store/settings.dart';
import 'package:chat_gguf/utils.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  ChatListPageState createState() => ChatListPageState();
}

class ChatListPageState extends State<ChatListPage> {
  late Future<List<ChatSession>> chatsFuture;

  @override
  void initState() {
    super.initState();
    refresh();
    settings.autoLoad();
  }

  void refresh() {
    setState(() {
      chatsFuture = global.database.getChatsWithLastMessage();
    });
  }

  void addSession() async {
    final database = GlobalStore().database;
    final chat = ChatsCompanion.insert(
        title: '',
        avatar: 'assets/bot1.jpeg',
        summaryTitle: const Value(""),
        sumarizePrompt: const Value(""));
    final id = await database.into(database.chats).insert(chat);
    if (id < 0) {
      EasyLoading.showError('Add Chat Failed');
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, '/chat', arguments: id)
          .then((_) => {refresh()});
    });
  }

  Future<int> removeSession(int id) async {
    final database = global.database;
    final count = await database.deleteChat(id);
    if (count != 1) {
      EasyLoading.showError('Remove Chat Failed');
    } else {
      EasyLoading.showSuccess('Remove Chat Success');
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Settings>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chat List'),
            const SizedBox(width: 8.0),
            Tooltip(
                message: settings.llmLoaded == LoadStatus.loaded
                    ? 'Model Loaded'
                    : 'Model Not Loaded',
                child: LoadingBox(status: settings.llmLoaded)),
          ],
        ),
        shadowColor: Theme.of(context).colorScheme.shadow,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/setting');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addSession,
          ),
        ],
      ),
      body: FutureBuilder<List<ChatSession>>(
          future: chatsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final chats = snapshot.data!;
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final item = chats[index];
                  return Dismissible(
                    key: Key(item.id.toString()),
                    onDismissed: (direction) async {
                      chats.removeAt(index);
                      await removeSession(item.id);
                      refresh();
                    },
                    background: Container(color: Colors.red),
                    child: ListTile(
                      onTap: () {
                        if (settings.llmLoaded == LoadStatus.loaded) {
                          Navigator.pushNamed(context, '/chat',
                              arguments: item.id);
                        } else {
                          EasyLoading.showError('Model Not Loaded');
                        }
                      },
                      leading: CircleAvatar(
                        backgroundImage: getAvatar(item.avatar),
                      ),
                      title: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        item.name == "" ? "new chat" : item.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        item.lastMessage ?? "", // 这里可以替换为最后一条消息的内容
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      trailing: Text(
                        formatTime(item.lastMessageTime), // 这里可以替换为最后一条消息的时间
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      bottomNavigationBar: CustomNavigationBar(
        route: '/chat_list',
      ),
    );
  }
}
