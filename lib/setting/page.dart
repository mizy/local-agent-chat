import "dart:io";

import "package:chat_gguf/ai.dart";
import "package:chat_gguf/store/settings.dart";
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:macos_secure_bookmarks/macos_secure_bookmarks.dart";
import "package:provider/provider.dart";
import 'package:path/path.dart' as path;

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  String? modelFilePath;
  String? promptTemplate;
  double? topP;
  int? topK;
  late Settings settings;

  void selectPromptTemplate() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <String>[
            'gemma',
            'chatml',
            'llama2',
            'llama3',
            'zephyr',
            'monarch'
          ].map((String template) {
            return ListTile(
              title: Text(template),
              onTap: () {
                settings.updatePromptTemplate(template);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> selectModel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      settings.updateLlamaParams("model", result.files.single.path!);
    } else {
      // User canceled the picker
    }
  }

  void initModelParams() async {
    final messager = ScaffoldMessenger.of(context);
    final settings = context.read<Settings>();
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.show(
      status: 'llm loading...',
    );
    final err = await ai.useSettings(settings);
    if (err != "") {
      messager.showSnackBar(
        SnackBar(
          content: Text(err),
        ),
      );
      return;
    }
    settings.updateLLMLoaded(true);
    EasyLoading.dismiss();
    messager.showSnackBar(
      const SnackBar(
        content: Text("llm load success"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    settings = context.watch<Settings>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Model Path'),
              trailing: SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: selectModel,
                  child: Text(
                    settings.llamaParams["model"] != null
                        ? path.basename(settings.llamaParams["model"]!)
                        : 'Select Model',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            ListTile(
                title: const Text('Prompt Template'),
                trailing: SizedBox(
                  width: 200,
                  child: TextButton(
                    onPressed: selectPromptTemplate,
                    child: Text(settings.promptTemplate ?? 'Select Template'),
                  ),
                )),
            ListTile(
              title: const Text('Context Length'),
              trailing: SizedBox(
                width: 200,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: settings.llamaParams["ctx-size"],
                  ),
                  onChanged: (String value) {
                    settings.updateLlamaParams("ctx-size", value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: initModelParams,
          child: const Text('Reload Model'),
        ),
      ),
    );
  }
}
