import 'package:chat_gguf/ai.dart';
import 'package:chat_gguf/chat/chat_setting/page.dart';
import 'package:chat_gguf/chat_list/page.dart';
import 'package:chat_gguf/database/database.dart';
import 'package:chat_gguf/setting/page.dart';
import 'package:chat_gguf/store/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'chat/page.dart';

class GlobalStore {
  static final GlobalStore _singleton = GlobalStore._internal();
  factory GlobalStore() {
    return _singleton;
  }
  GlobalStore._internal();
  late AppDatabase database;
}

final GlobalStore global = GlobalStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  global.database = database;
  await settings.loadSettings();
  initializeDateFormatting().then((_) => runApp(ChangeNotifierProvider(
        create: (context) => settings,
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const AppLifecycleDisplay();
}

class AppLifecycleDisplay extends StatefulWidget {
  const AppLifecycleDisplay({super.key});

  @override
  State<AppLifecycleDisplay> createState() => _AppLifecycleDisplayState();
}

class _AppLifecycleDisplayState extends State<AppLifecycleDisplay> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onDetach: () {
        global.database.close();
        ai.dispose();
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialRoute: '/',
      builder: EasyLoading.init(),
      routes: {
        '/': (context) => const ChatListPage(),
        '/chat': (context) => const ChatPage(),
        '/chat_list': (context) => const ChatListPage(),
        '/setting': (context) => const SettingPage(),
        '/chat_setting': (context) => const ChatSettingPage(),
      },
    );
  }
}
