import 'dart:convert';
import 'dart:io';

import 'package:chat_gguf/ai.dart';
import 'package:chat_gguf/chat_list/load_status.dart';
import 'package:flutter/material.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  Map<String, String> llamaParams = {};
  LoadStatus llmLoaded = LoadStatus.none;
  String? promptTemplate;
  String? bookmark;

  Future<void> autoLoad() async {
    if (llamaParams['model'] != null && llmLoaded == LoadStatus.none) {
      llmLoaded = LoadStatus.loading;
      notifyListeners();
      final res = await ai.useSettings(settings);
      if (res != '') {
        print(res);
        llmLoaded = LoadStatus.none;
      } else {
        llmLoaded = LoadStatus.loaded;
      }
      notifyListeners();
    }
  }

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
        llamaParams['ctx-size'] = '512';
      }
    }
    bookmark = prefs.getString('bookmark');
    if (bookmark != null && Platform.isMacOS && bookmark != '') {
      loadBootmark();
    }
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = {'llamaParams': llamaParams, 'promptTemplate': promptTemplate};
    final s = jsonEncode(json);
    prefs.setString('setting', s);
    prefs.setString('bookmark', bookmark ?? '');
  }

  void updateLlamaParams(String key, String value) {
    llamaParams[key] = value;
    saveSettings();
    notifyListeners();
    if (key == 'model') {
      saveBootmark(value);
    }
  }

  void saveBootmark(String path) async {
    if (Platform.isMacOS) {
      final secureBookmarks = SecureBookmarks();
      bookmark = await secureBookmarks.bookmark(File(path));
    }
  }

  void loadBootmark() async {
    final secureBookmarks = SecureBookmarks();
    final file = await secureBookmarks.resolveBookmark(bookmark!);
    llamaParams['model'] = file.path;
  }

  void updatePromptTemplate(String? template) {
    promptTemplate = template;
    saveSettings();
    notifyListeners();
  }

  void updateLLMLoaded(bool loaded) {
    llmLoaded = loaded ? LoadStatus.loaded : LoadStatus.none;
    saveSettings();
    notifyListeners();
  }
}

final settings = Settings();
