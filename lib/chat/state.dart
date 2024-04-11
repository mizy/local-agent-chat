import 'dart:io';

import 'package:chat_gguf/ai.dart';
import 'package:chat_gguf/chat/page.dart';
import 'package:chat_gguf/database/tables.dart';
import 'package:chat_gguf/main.dart';
import 'package:chat_gguf/utils.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart' as table;

class ChatPageState extends State<ChatPage> {
  table.Chat? chatSession;
  List<types.Message> _messages = [];
  late int chatId;
  final _user = const types.User(
    id: 'user',
  );
  final _bot = const types.User(
    id: 'bot',
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initChat();
  }

  Future<table.Chat> getChatSession() async {
    final chat = await global.database.getChatById(chatId);
    setState(() {
      chatSession = chat;
    });
    return chat;
  }

  void initChat() async {
    chatId = ModalRoute.of(context)!.settings.arguments as int;
    getChatSession();
    loadMessage();
  }

  void loadMessage() async {
    List<types.Message> messagesList = [];
    final messages = await global.database.getMessagesByChatId(chatId);
    if (messages.isEmpty) {
      var message = types.TextMessage(
        author: _bot,
        id: '0',
        text: "hi, how can I help you?",
      );
      messagesList.add(message);
    } else {
      for (var message in messages) {
        messagesList.add(types.TextMessage(
            author: message.author == "user" ? _user : _bot,
            id: message.id.toString(),
            text: message.message,
            createdAt: message.createdAt.microsecondsSinceEpoch));
      }
    }
    setState(() {
      _messages = messagesList;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  SizedBox _buildAvatar(types.User? user) {
    const double maxRadius = 18.0;
    CircleAvatar avatar;
    if (user == null && chatSession != null) {
      avatar = CircleAvatar(
          maxRadius: maxRadius,
          backgroundImage: getAvatar(chatSession!.avatar));
    } else if (user?.id == _bot.id && chatSession != null) {
      avatar = CircleAvatar(
          maxRadius: maxRadius,
          backgroundImage: getAvatar(chatSession!.avatar));
    } else {
      avatar = const CircleAvatar(
        maxRadius: maxRadius,
        backgroundImage: AssetImage('assets/user.jpeg'),
      );
    }
    return SizedBox(width: 50.0, height: 40.0, child: Center(child: avatar));
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
    saveMessage(textMessage);
    _handleBotResponse(textMessage);
  }

  void _handleBotResponse(types.TextMessage message) async {
    final botMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: "loading...",
    );
    var text = '';
    //last 5 messages
    final List<ChatMessage> messages = _messages
        .take(5)
        .toList()
        .reversed
        .map((e) => ChatMessage(
              (e as types.TextMessage).text,
              e.author == _user ? "user" : "asistant",
            ))
        .toList();
    //add system message,//todo: use agent system prompt
    messages.insert(
        0,
        ChatMessage(
          chatSession!.sumarizePrompt != ""
              ? "user conversation summarization : ${chatSession!.sumarizePrompt}"
              : "You are a helpful assistant",
          "system",
        ));
    //add the current message
    _addMessage(botMessage);
    types.TextMessage aiMessage = botMessage;
    ai.chat(messages).listen((event) {
      text += event;
      stdout.write(event);
      var json = botMessage.toJson();
      json['text'] = text;
      aiMessage = types.TextMessage.fromJson(json);
      final index =
          _messages.indexWhere((element) => element.id == botMessage.id);
      setState(() {
        _messages[index] = aiMessage;
      });
    }).onDone(() async {
      try {
        final id = await saveMessage(aiMessage);
        if (chatSession?.title == "") {
          final title = await ai.sumarizeTitle(messages);
          await saveSumarizeTitle(title);
        }
        final index = _messages.indexWhere(
            (element) => element.id == chatSession!.sumarizeMsgId.toString());
        if (index > 5) {
          final prompt = await ai.sumarizeHistory(messages);
          await saveSumarizePrompt(prompt, id);
        }
      } catch (e) {
        EasyLoading.showError(e.toString());
      }
      getChatSession();
    });
  }

  Future<int> saveSumarizePrompt(
    String sumarizePrompt,
    int limitId,
  ) async {
    return (global.database.update(global.database.chats)
          ..where((c) => c.id.equals(chatSession!.id)))
        .write(table.ChatsCompanion(
            sumarizePrompt: Value(sumarizePrompt),
            sumarizeMsgId: Value(limitId)));
  }

  Future<int> saveSumarizeTitle(
    String sumarizeTitle,
  ) async {
    return (global.database.update(global.database.chats)
          ..where((c) => c.id.equals(chatSession!.id)))
        .write(table.ChatsCompanion(title: Value(sumarizeTitle)));
  }

  Future<int> saveMessage(types.TextMessage message) async {
    return global.database
        .into(global.database.messages)
        .insert(table.MessagesCompanion.insert(
          chatId: chatSession!.id,
          message: message.text,
          author: message.author.id,
          type: Value(MessageType.text.index),
        ));
  }

  @override
  Widget build(BuildContext context) {
    String title = chatSession?.title ?? '';
    if (title == '') {
      title = 'New Chat';
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                Navigator.pushNamed(context, '/chat_setting',
                    arguments: chatSession);
              },
            ),
          ],
        ),
        body: Stack(children: [
          chat_ui.Chat(
            messages: _messages,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: _user,
            avatarBuilder: _buildAvatar,
            theme: const chat_ui.DefaultChatTheme(
              seenIcon: Text(
                'read',
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ),
          ),
        ]));
  }
}
