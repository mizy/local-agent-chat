import 'package:chat_gguf/bottom_bar/bar.dart';
import 'package:chat_gguf/chat_list/chat_session.dart';
import 'package:chat_gguf/utils.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  ChatListPageState createState() => ChatListPageState();
}

class ChatListPageState extends State<ChatListPage> {
  final List<ChatSession> chatHistoryList = [];

  void addHistory() {
    final item = ChatSession(
        id: chatHistoryList.length.toString(),
        name: 'New Chat${chatHistoryList.length}',
        lastMessage: 'This is the last message',
        lastMessageTime: DateTime.now(),
        avatarUrl: 'https://example.com/image.jpg');
    setState(() {
      chatHistoryList.add(item);
    });
    Navigator.pushNamed(context, '/chat', arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GGUF Chat'),
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
            onPressed: addHistory,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatHistoryList.length,
        itemBuilder: (context, index) {
          final item = chatHistoryList[index];
          return Dismissible(
            key: Key(item.id),
            onDismissed: (direction) {
              setState(() {
                chatHistoryList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$item dismissed")),
              );
            },
            background: Container(color: Colors.red),
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/chat', arguments: item);
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item.avatarUrl), // 这里可以替换为你的头像URL
              ),
              title: Text(
                item.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                item.lastMessage, // 这里可以替换为最后一条消息的内容
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
      ),
      bottomNavigationBar: CustomNavigationBar(
        route: '/chat_list',
      ),
    );
  }
}
