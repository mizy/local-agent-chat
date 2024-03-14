import 'package:chat_gguf/chat_list/page.dart';
import 'package:chat_gguf/setting/page.dart';
import 'package:chat_gguf/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'chat/page.dart';

void main() async {
  initializeDateFormatting().then((_) => runApp(ChangeNotifierProvider(
        create: (context) => Settings(),
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => const ChatListPage(),
        '/chat': (context) => const ChatPage(),
        '/chat_list': (context) => const ChatListPage(),
        '/setting': (context) => const SettingPage(),
      },
    );
  }
}
