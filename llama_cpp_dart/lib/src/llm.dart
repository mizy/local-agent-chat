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
}

class LlamaCPP {
  static llama_cpp_binding? _lib;
  static SendPort? sendPort;

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

  LlamaCPP(Map<String, String> params, {void Function(String)? log}) {
    if (log != null) _log = log;
    final int argc = params.length * 2 + 1;
    final Pointer<Pointer<Char>> argv = calloc<Pointer<Char>>(argc);
    argv[0] = 'llm'.toNativeUtf8().cast<Char>();
    for (var i = 0; i < params.length; i++) {
      final key = params.keys.elementAt(i);
      final value = params[key]!;
      argv[2 * i + 1] = ("--$key").toNativeUtf8().cast<Char>();
      argv[2 * i + 1 + 1] = value.toNativeUtf8().cast<Char>();
    }
    lib.llm_init(argc, argv, Pointer.fromFunction(_logOutput));
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
    final sendPort = receivePort.sendPort;
    final isolate = await Isolate.spawn(_chatIsolate, [messages, sendPort]);
    try {
      await for (var data in receivePort) {
        final (String message, bool done) = data;
        if (done) {
          receivePort.close();
          isolate.kill();
          return;
        }
        yield message;
      }
    } catch (e) {
      receivePort.close();
      isolate.kill();
      _log!('Error receiving message from isolate: $e');
    }
  }

  static void _chatIsolate(List args) {
    final messages = args[0] as List<ChatMessage>;
    sendPort = args[1] as SendPort;
    final chatMessage = _toNativeChatMessages(messages);
    lib.llm_chat(chatMessage, messages.length, Pointer.fromFunction(output));
  }

  static Pointer<Pointer<llama_chat_message>> _toNativeChatMessages(
      List<ChatMessage> messages) {
    final chatMessages = calloc<Pointer<llama_chat_message>>(messages.length);

    for (var i = 0; i < messages.length; i++) {
      chatMessages[i] = calloc<llama_chat_message>()
        ..ref.role = messages[i].role.toNativeUtf8().cast<Char>()
        ..ref.content = messages[i].content.toNativeUtf8().cast<Char>();
    }
    return chatMessages;
  }

  Stream<String> completion({required String input}) async* {
    final receivePort = ReceivePort();
    final isolate =
        await Isolate.spawn(_completionIsolate, [input, receivePort.sendPort]);
    try {
      await for (var data in receivePort) {
        final (String message, bool done) = data;
        if (done) {
          receivePort.close();
          isolate.kill();
          return;
        }
        yield message;
      }
    } catch (e) {
      receivePort.close();
      isolate.kill();
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

  static void _logOutput(Pointer<Char> message) {
    if (_log != null) {
      _log!(message.cast<Utf8>().toDartString());
    }
  }

  void stop() {
    lib.llm_stop();
  }

  void dispose() {
    lib.llm_cleanup();
  }
}
