import 'dart:ffi';
import 'dart:io';

import 'package:llama_cpp_dart/llama_cpp_dart.dart';

Future<void> main() async {
  DynamicLibrary.open("./libllm.so");
  final Map<String, String> params = {
    "model": "/Users/mizy/projects/ggufs/Phi-3-mini-4k-instruct-q4.gguf",
    "ctx-size": "512",
  };
  final instance = LlamaCPP();
  await instance.init(params);
  instance.setTemplate("phi3");
  final messages = [
    ChatMessage("hi,how can i help you?", "asistant"),
    ChatMessage("hello", "user"),
  ]; // Change this to the messages you want to send to the model
  final chats = instance.chat(messages);

  await for (String token in chats) {
    stdout.write(token);
  }
  stdout.write("\n");
  await instance.dispose();
  exit(0);
}
