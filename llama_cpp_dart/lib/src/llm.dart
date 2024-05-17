import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

import 'bindings.dart';

class ChatMessage {
  final String content;
  final String role;

  ChatMessage(this.content, this.role);

  ChatMessage.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        role = json['role'];

  Map<String, dynamic> toJson() => {
        'content': content,
        'role': role,
      };
}

class LlamaCPP {
  static llama_cpp_binding? _lib;
  static SendPort? sendPort; //stream output sendPort
  int argc = 0;
  Isolate? llmIsolate;
  late SendPort isolateSendPort;

  Pointer<Pointer<Char>>? argv;
  static void Function(String)? _log = (str) {
    stdout.write(str);
  };

  /// Getter for the Llama library.
  ///
  /// Loads the library based on the current platform.
  static llama_cpp_binding get lib {
    if (_lib == null) {
      if (Platform.isWindows) {
        _lib = llama_cpp_binding(DynamicLibrary.open('libllm.dll'));
      } else if (Platform.isLinux || Platform.isAndroid) {
        _lib = llama_cpp_binding(DynamicLibrary.open('libllama.so'));
      } else {
        _lib = llama_cpp_binding(DynamicLibrary.process());
      }
    }
    return _lib!;
  }

  LlamaCPP({void Function(String)? log}) {
    if (log != null) _log = log;
  }

  Future<bool> init(Map<String, String> params) async {
    final receivePort = ReceivePort();
    final completer = Completer<bool>();
    llmIsolate =
        await Isolate.spawn(initIsolate, [params, receivePort.sendPort]);
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        completer.complete(true);
      }
      if (message == null) {
        receivePort.close();
        completer.complete(false);
      }
      if (message is String) {}
    });
    return completer.future;
  }

  static (int, Pointer<Pointer<Char>>) makeArgv(Map<String, String> params) {
    final argc = params.length * 2 + 1;
    final argv = calloc<Pointer<Char>>(argc);
    argv[0] = 'llm'.toNativeUtf8().cast<Char>();
    for (var i = 0; i < params.length; i++) {
      final key = params.keys.elementAt(i);
      final value = params[key]!;
      argv[2 * i + 1] = ("--$key").toNativeUtf8().cast<Char>();
      argv[2 * i + 1 + 1] = value.toNativeUtf8().cast<Char>();
    }
    return (argc, argv);
  }

  void initIsolate(List<dynamic> args) {
    final params = args[0] as Map<String, String>;
    final mainSendPort = args[1] as SendPort;
    final isolateReceivePort = ReceivePort();
    final (argc, argv) = makeArgv(params);
    final res = lib.llm_init(argc, argv, Pointer.fromFunction(_logOutput));
    if (res != 0) {
      lib.llm_cleanup();
      return mainSendPort.send(null);
    }
    mainSendPort.send(isolateReceivePort.sendPort);
    isolateReceivePort.listen((message) {
      final type = message[0] as String;
      final data = message[1];
      if (type == "chat") {
        final (List<ChatMessage> messages, SendPort sendPort) = data;
        _chatIsolate([messages, sendPort]);
      } else if (type == "completion") {
        final (String input, SendPort sendPort) = data;
        _completionIsolate([input, sendPort]);
      } else if (type == "dispose") {
        final sendPort = data as SendPort;
        lib.llm_cleanup();
        for (var i = 0; i < argc; i++) {
          calloc.free(argv[i]);
        }
        calloc.free(argv);
        sendPort.send(null);
        isolateReceivePort.close();
      }
    });
  }

  static void output(Pointer<Char> buffer, bool stop) {
    try {
      sendPort!.send((buffer.cast<Utf8>().toDartString(), stop));
    } catch (e) {
      _log!('Error sending message from isolate: $e');
    }
  }

  Stream<String> chat(List<ChatMessage> messages) async* {
    final receivePort = ReceivePort();
    isolateSendPort.send(["chat", (messages, receivePort.sendPort)]);
    try {
      await for (var data in receivePort) {
        final (String message, bool done) = data;
        if (done) {
          receivePort.close();
          return;
        }
        yield message;
      }
    } catch (e) {
      receivePort.close();
      _log!('Error receiving message from isolate: $e');
    }
  }

  static void _chatIsolate(List args) {
    final messages = args[0] as List<ChatMessage>;
    sendPort = args[1] as SendPort;
    final chatMessage = _toNativeChatMessages(messages);
    try {
      lib.llm_chat(chatMessage, messages.length, Pointer.fromFunction(output));
    } finally {
      _freeChatMessage(chatMessage, messages.length);
    }
  }

  static _freeChatMessage(
      Pointer<Pointer<llama_chat_message>> chatMessage, int length) {
    for (var i = 0; i < length; i++) {
      calloc.free(chatMessage[i].ref.role);
      calloc.free(chatMessage[i].ref.content);
      calloc.free(chatMessage[i]);
    }
    calloc.free(chatMessage);
  }

  static Pointer<Pointer<llama_chat_message>> _toNativeChatMessages(
      List<ChatMessage> messages) {
    final chatMessages = calloc<Pointer<llama_chat_message>>(messages.length);

    for (var i = 0; i < messages.length; i++) {
      chatMessages[i] = calloc<llama_chat_message>();
      chatMessages[i].ref.role = messages[i].role.toNativeUtf8().cast<Char>();
      chatMessages[i].ref.content =
          messages[i].content.toNativeUtf8().cast<Char>();
    }

    return chatMessages;
  }

  Stream<String> completion({required String input}) async* {
    final receivePort = ReceivePort();
    isolateSendPort.send([
      "completion",
      [input, receivePort.sendPort]
    ]);
    try {
      await for (var data in receivePort) {
        final (String message, bool done) = data;
        if (done) {
          receivePort.close();
          return;
        }
        yield message;
      }
    } catch (e) {
      receivePort.close();
      _log!('Error receiving message from isolate: $e');
    }
  }

  static void _completionIsolate(List args) {
    final input = args[0] as String;
    sendPort = args[1] as SendPort;
    lib.llm_completion(
        input.toNativeUtf8().cast<Char>(), Pointer.fromFunction(output));
  }

  void setTemplate(String template) {
    lib.set_chat_template(template.toNativeUtf8().cast<Char>());
  }

  void setLogger(void Function(String) log) {
    _log = log;
  }

  //dart ffi can only use int function(Pointer<Char> message),use void will cause error
  static int _logOutput(Pointer<Char> message) {
    if (_log != null) {
      _log!(message.cast<Utf8>().toDartString());
    }
    return 1;
  }

  void stop() {
    lib.llm_stop();
  }

  Future<void> dispose() async {
    final receivePort = ReceivePort();
    final completer = Completer<void>();
    isolateSendPort.send(["dispose", receivePort.sendPort]);
    receivePort.listen((message) {
      if (message == null) {
        receivePort.close();
        llmIsolate!.kill();
        completer.complete();
      }
    });
    return completer.future;
  }
}
