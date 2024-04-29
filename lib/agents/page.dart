import 'package:chat_gguf/agents/agent_detail_page.dart';
import 'package:chat_gguf/agents/agent_edit.dart';
import 'package:chat_gguf/bottom_bar/bar.dart';
import 'package:chat_gguf/chat_list/load_status.dart';
import 'package:chat_gguf/main.dart';
import 'package:chat_gguf/store/settings.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart'; // 你的数据库包

class DatabaseService {
  final table = global.database.agents;

  Future<List<Agent>> getAgents() {
    return (global.database.select(table)..limit(1000)).get();
  }

  Future<void> addAgent(Insertable<Agent> agent) {
    return global.database.into(table).insert(agent);
  }

  Future<void> updateAgent(Insertable<Agent> agent) {
    return global.database.update(table).replace(agent);
  }

  Future<void> deleteAgent(Insertable<Agent> agent) {
    return global.database.delete(table).delete(agent);
  }
}

class AgentListPage extends StatefulWidget {
  const AgentListPage({super.key});

  @override
  AgentListPageState createState() => AgentListPageState();
}

class AgentListPageState extends State<AgentListPage> {
  final DatabaseService dbService = DatabaseService();

  AgentListPageState();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Settings>();
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Agent list'),
              const SizedBox(width: 8.0),
              Tooltip(
                  message: settings.llmLoaded == LoadStatus.loaded
                      ? 'Model Loaded'
                      : 'Model Not Loaded',
                  child: LoadingBox(status: settings.llmLoaded)),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person_add_alt_1_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgentEditPage(),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
            ),
          ]),
      body: FutureBuilder<List<Agent>>(
        future: dbService.getAgents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data![index].avatar),
                  ),
                  title: Text(snapshot.data![index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AgentDetails(agent: snapshot.data![index]),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: CustomNavigationBar(
        route: '/agent_list',
      ),
    );
  }
}
