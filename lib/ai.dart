import 'dart:async';
import 'dart:io';
import 'package:chat_gguf/format/gemma_format.dart';
import 'package:chat_gguf/settings.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

class Message {
  final String command;
  final Map<String, dynamic> data;
  Message(this.command, this.data);
}

class AI {
  String type = "llama.cpp"; // "llama.cpp" or "openai"
  LlamaCPP? llamaInstance;
  Map<String, String> llamaParams = {};
  AI() {
    if (type == "llama.cpp") {
      initLLama();
    }
  }

  void initLLama() async {
    stdout.writeln("AI init...");
  }

  String useSettings(Settings settings) {
    if (type == "llama.cpp") {
      if (settings.modelFilePath == null || settings.promptTemplate == null) {
        return "Model file path and prompt template must be set";
      }
      llamaParams["model"] = settings.modelFilePath!;
      llamaParams["template"] = settings.promptTemplate!;
      llamaInstance?.dispose();
      llamaInstance = LlamaCPP(llamaParams);
    }
    return "";
  }

  Stream<String> run(List<ChatMessage> messages) {
    if (type == "llama.cpp") {
      return llamaInstance!.chat(messages);
    }
    return const Stream.empty();
  }

  void dispose() {
    if (type == "llama.cpp") {
      llamaInstance?.dispose();
    }
  }
}

final gemma = GemmaFormat();
