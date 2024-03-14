import 'dart:ffi';
import 'dart:io';

import 'package:llama_cpp_dart/llama_cpp_dart.dart';

Future<void> main() async {
  DynamicLibrary.open("./libllm.so");
  final Map<String, String> params = {
    "model":
        "/Users/mizy/projects/llama-cpp-gpt-api/models/lmstudio-ai/gemma-2b-it-GGUF/gemma-2b-it-q8_0.gguf",
    "ctx-size": "512",
  };
  final instance = LlamaCPP(params);
  instance.setTemplate("gemma");
  final messages = [
    ChatMessage("hello", "user")
  ]; // Change this to the messages you want to send to the model
  final chats = instance.chat(messages);

  await for (String token in chats) {
    stdout.write(token);
  }
  stdout.write("\n");
  instance.dispose();
}
