import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:chat_gguf/agents/page.dart';
import 'package:chat_gguf/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

class AgentEditPage extends StatefulWidget {
  final Agent? agent;

  const AgentEditPage({super.key, this.agent});

  @override
  AgentEditPageState createState() => AgentEditPageState();
}

class MessageController {
  TextEditingController roleController;
  TextEditingController contentController;

  MessageController(
      {required this.roleController, required this.contentController});
}

class AgentEditPageState extends State<AgentEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _avatarController;
  late TextEditingController _systemPromptController;
  late List<MessageController> _presetMessagesControllers;
  final DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    final fewShots = jsonDecode(
      widget.agent?.fewShot ?? '[]',
    ) as List;

    _nameController = TextEditingController(text: widget.agent?.name);
    _avatarController = TextEditingController(text: widget.agent?.avatar);
    _systemPromptController = TextEditingController(text: widget.agent?.system);
    _presetMessagesControllers = fewShots
            .map((message) => MessageController(
                  roleController: TextEditingController(text: message["role"]),
                  contentController:
                      TextEditingController(text: message["content"]),
                ))
            .toList() ??
        [];
  }

  onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Save the agent
      var agent = AgentsCompanion.insert(
        name: _nameController.text,
        avatar: _avatarController.text,
        system: _systemPromptController.text != ''
            ? drift.Value(_systemPromptController.text)
            : const drift.Value(null),
        fewShot: drift.Value(jsonEncode(_presetMessagesControllers
            .map((controller) => ChatMessage(
                  controller.contentController.text,
                  controller.roleController.text,
                ))
            .toList())),
      );
      if (widget.agent == null) {
        dbService.addAgent(agent);
      } else {
        final updateAgent = agent.copyWith(
          id: drift.Value(widget.agent!.id),
          updatedAt: drift.Value(DateTime.now()),
          createdAt: drift.Value(widget.agent!.createdAt),
        );
        dbService.updateAgent(updateAgent);
      }
      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agent saved'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agent == null ? 'Add Agent' : 'Edit Agent'),
        actions: [
          //save
          TextButton(
            onPressed: onSubmit,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      setState(() {
                        _avatarController.text = image.path;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: _avatarController.text.isEmpty
                          ? null
                          : FileImage(File(_avatarController.text)),
                      child: _avatarController.text.isEmpty
                          ? const Icon(Icons.camera_alt)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                    child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                )),
              ],
            ),
            TextFormField(
              controller: _systemPromptController,
              decoration: const InputDecoration(labelText: 'System Prompt'),
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(64),
              },
              children: _presetMessagesControllers
                  .map(
                    (controller) => TableRow(
                      children: [
                        TextFormField(
                          controller: controller.roleController,
                          decoration: const InputDecoration(labelText: 'Role'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a sender';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextFormField(
                            controller: controller.contentController,
                            decoration:
                                const InputDecoration(labelText: 'Message'),
                            maxLines: null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a message';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              _presetMessagesControllers.remove(controller);
                            });
                          },
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _presetMessagesControllers.add(MessageController(
                    roleController: TextEditingController(),
                    contentController: TextEditingController(),
                  ));
                });
              },
              child: const Text('Add Preset Message'),
            ),
          ],
        ),
      ),
    );
  }
}
