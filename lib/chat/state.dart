import 'dart:io';

import 'package:chat_gguf/ai.dart';
import 'package:chat_gguf/chat/page.dart';
import 'package:chat_gguf/database/tables.dart';
import 'package:chat_gguf/main.dart';
import 'package:chat_gguf/utils.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
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
    final database = global.database;
    chatId = ModalRoute.of(context)!.settings.arguments as int;
    await database.getChatById(chatId);
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
      setState(() {
        _messages = messagesList;
      });
    } else {
      for (var message in messages) {
        messagesList.add(types.TextMessage(
            author: message.author == "user" ? _user : _bot,
            id: message.id.toString(),
            text: message.message,
            createdAt: message.createdAt.microsecondsSinceEpoch));
      }
    }
  }

  @override
  void dispose() {
    ai.dispose();
    super.dispose();
  }

  _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
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
        .where((element) => element.id != "0") //filter out the first message
        .map((e) => ChatMessage(
              (e as types.TextMessage).text,
              e.author == _user ? "user" : "asistant",
            ))
        .toList()
        .reversed
        .take(5)
        .toList();
    //add summarized message
    if (chatSession!.sumarizePrompt != "") {
      messages.insert(
          0,
          ChatMessage(
            "user conversation summarization : ${chatSession!.sumarizePrompt}",
            "system",
          ));
    }
    //add the current message
    _addMessage(botMessage);

    ai.chat(messages).listen((event) {
      text += event;
      var json = botMessage.toJson();
      json['text'] = text;
      final updateMessage = types.TextMessage.fromJson(json);
      final index =
          _messages.indexWhere((element) => element.id == botMessage.id);
      setState(() {
        _messages[index] = updateMessage;
      });
    }).onDone(() async {
      saveMessage(message);
      final sumarizePrompt = await ai.sumarizeHistory(messages);
      await saveSumarizePrompt(sumarizePrompt, int.parse(botMessage.id));
    });
  }

  Future<int> saveSumarizePrompt(String sumarizePrompt, int limitId) async {
    return (global.database.update(global.database.chats)
          ..where((c) => c.id.equals(chatSession!.id)))
        .write(table.ChatsCompanion(
            sumarizePrompt: Value(sumarizePrompt),
            sumarizeMsgId: Value(limitId)));
  }

  Future<int> saveMessage(types.TextMessage message) async {
    return global.database
        .into(global.database.messages)
        .insert(table.MessagesCompanion.insert(
          chatId: chatSession!.id,
          message: message.text,
          author: message.author.id,
          type: Value(MessageType.text as int),
        ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(chatSession == null ? "a" : chatSession!.title),
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
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
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
