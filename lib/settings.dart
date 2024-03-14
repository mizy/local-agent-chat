import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  String? modelFilePath;
  String? promptTemplate = "chatml";
  double? topP;
  int? topK;

  void updateModelFilePath(String? path) {
    modelFilePath = path;
  }

  void updatePromptTemplate(String? template) {
    promptTemplate = template;
    notifyListeners();
  }
  // Add more methods to update other fields...
}
