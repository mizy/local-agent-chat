import "package:chat_gguf/settings.dart";
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart";
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

  @override
  void initState() {
    super.initState();
    settings = context.read<Settings>();
  }

  void selectPromptTemplate() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <String>['gemma', 'chatml', 'llama2', 'zephyr', 'monarch']
              .map((String template) {
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
      settings.updateModelFilePath(result.files.single.path);
    } else {
      // User canceled the picker
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Setting'),
          shadowColor: Theme.of(context).colorScheme.shadow),
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
                    settings.modelFilePath != null
                        ? path.basename(settings.modelFilePath!)
                        : 'Select Model',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Prompt Template'),
              trailing: TextButton(
                onPressed: selectPromptTemplate,
                child: Text(settings.promptTemplate ?? 'Select Template'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
