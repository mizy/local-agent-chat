import 'dart:async';
import 'dart:io';
import 'package:chat_gguf/utils.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

import 'store/settings.dart';

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

  Future<String> useSettings(Settings settings) async {
    if (type == "llama.cpp") {
      final params = settings.llamaParams;
      if (params["model"] == null) {
        return "Model file path  must be set";
      }
      final file = File(params["model"]!);
      if (!file.existsSync()) {
        return "Model file not found";
      }
      final err = await requestPermission();
      if (err != "") {
        return err;
      }
      llamaParams = settings.llamaParams;
      llamaInstance?.dispose();
      llamaInstance = LlamaCPP();
      if (settings.promptTemplate != null) {
        llamaInstance!.setTemplate(settings.promptTemplate ?? "");
      }
      final res = await llamaInstance?.init(llamaParams);
      if (!res!) {
        llamaInstance = null;
        return "Failed to init llama.cpp";
      }
    }
    return "";
  }

  Stream<String> chat(List<ChatMessage> messages) {
    if (type == "llama.cpp") {
      return llamaInstance!.chat(messages);
    }
    return const Stream.empty();
  }

  Future<String> sumarizeHistory(
    List<ChatMessage> messages,
  ) async {
    String conversation = "";
    for (ChatMessage message in messages) {
      conversation += "${message.role}: ${message.content}\n";
    }
    String prompt =
        "Please provide a summary of the user's chat topics and purpose concisely and clearly. This summary should be used as the context for future conversations.  and should not exceed 200 characters. conversation:\n $conversation ";
    final newMessages = [...messages, ChatMessage(prompt, "user")];
    final summaryList = await chat(newMessages).toList();
    String summary = summaryList.join(' ');
    if (summary.length > 200) {
      summary = summary.substring(0, 200); // 限制长度为200字符
    }
    return summary;
  }

  Future<String> sumarizeTitle(
    List<ChatMessage> messages,
  ) async {
    String prompt =
        "Return the brief theme of this sentence in four to five words directly, without explanation, punctuation, tone words, or extra text";
    final newMessages = [...messages, ChatMessage(prompt, "user")];
    final summaryList = await chat(newMessages).toList();
    String summary = summaryList.join('');
    print("summaryTitle: $summary");
    if (summary.length > 30) {
      summary = summary.substring(0, 30);
    }
    summary = summary.replaceAll("\n", "");
    summary = summary.replaceAll(RegExp(r'\*\*|\*|__|_'), '');
    return summary;
  }

  void dispose() {
    if (type == "llama.cpp") {
      llamaInstance?.dispose();
    }
  }
}

AI ai = AI();
