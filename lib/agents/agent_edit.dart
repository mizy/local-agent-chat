import 'dart:convert';

import 'package:chat_gguf/agents/page.dart';
import 'package:chat_gguf/database/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

class AgentEditPage extends StatefulWidget {
  final Agent? agent;

  const AgentEditPage({super.key, this.agent});

  @override
  AgentEditPageState createState() => AgentEditPageState();
}

class AgentEditPageState extends State<AgentEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _avatarController;
  late TextEditingController _systemPromptController;
  late List<TextEditingController> _presetMessagesControllers;
  final DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.agent == null) {
      return;
    }
    final fewShots =
        jsonDecode(widget.agent?.fewShot ?? '[]') as List<ChatMessage>;

    _nameController = TextEditingController(text: widget.agent?.name);
    _avatarController = TextEditingController(text: widget.agent?.avatar);
    _systemPromptController = TextEditingController(text: widget.agent?.system);
    _presetMessagesControllers = fewShots
            .map((message) => TextEditingController(text: message.content))
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agent == null ? 'Add Agent' : 'Edit Agent'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _avatarController,
              decoration: const InputDecoration(labelText: 'Avatar'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an avatar';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _systemPromptController,
              decoration: const InputDecoration(labelText: 'System Prompt'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a system prompt';
                }
                return null;
              },
            ),
            ..._presetMessagesControllers
                .map((controller) => TextFormField(
                      controller: controller,
                      decoration:
                          const InputDecoration(labelText: 'Preset Message'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a preset message';
                        }
                        return null;
                      },
                    ))
                .toList(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save the agent
                  final agent = AgentsCompanion.insert(
                    name: _nameController.text,
                    avatar: _avatarController.text,
                    system: Value(_systemPromptController.text),
                    fewShot: Value(jsonEncode(_presetMessagesControllers
                        .map((controller) => controller.text)
                        .toList())),
                  );
                  if (widget.agent == null) {
                    dbService.addAgent(agent);
                  } else {
                    dbService.updateAgent(agent);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
