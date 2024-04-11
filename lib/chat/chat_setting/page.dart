import 'package:chat_gguf/ai.dart';
import 'package:flutter/material.dart';

class ChatSettingPage extends StatefulWidget {
  const ChatSettingPage({super.key});

  @override
  ChatSettingPageState createState() => ChatSettingPageState();
}

class ChatSettingPageState extends State<ChatSettingPage> {
  String summarizePrompt = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Summarize Prompt'),
            subtitle: Text(summarizePrompt),
          ),
          // 在这里添加其他的设置选项
        ],
      ),
    );
  }
}
