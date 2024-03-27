import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  Map<String, String> llamaParams = {};
  bool llmLoaded = false;
  String? promptTemplate;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? settingsJson = prefs.getString('setting');
    if (settingsJson != null) {
      final json = jsonDecode(settingsJson);
      Map<String, dynamic> originalMap = json['llamaParams'];
      llamaParams =
          originalMap.map((key, value) => MapEntry(key, value.toString()));
      promptTemplate = json['promptTemplate'];
      if (llamaParams['ctx-size'] != null) {
        llamaParams['ctx-size'] = '4096';
      }
    }
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = {'llamaParams': llamaParams, 'promptTemplate': promptTemplate};
    final s = jsonEncode(json);
    prefs.setString('setting', s);
  }

  void updateLlamaParams(String key, String value) {
    llamaParams[key] = value;
    saveSettings();
    notifyListeners();
  }

  void updatePromptTemplate(String? template) {
    promptTemplate = template;
    saveSettings();
    notifyListeners();
  }

  void updateLLMLoaded(bool loaded) {
    llmLoaded = loaded;
    saveSettings();
    notifyListeners();
  }
}

final settings = Settings();
