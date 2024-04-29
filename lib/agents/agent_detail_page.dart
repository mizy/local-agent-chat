import 'package:chat_gguf/database/database.dart';
import 'package:flutter/material.dart';

class AgentDetails extends StatelessWidget {
  final Agent agent;

  const AgentDetails({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agent list"),
      ),
      body: Column(
        children: [
          Text('Avatar: ${agent.avatar}'), // 添加这一行来显示avatar
          Text('Name: ${agent.name}'),
          Text('Description: ${agent.description}'),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}
