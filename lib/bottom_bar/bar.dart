import 'package:chat_gguf/agents/page.dart';
import 'package:chat_gguf/chat_list/page.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final List<Map<String, dynamic>> pages = [
    {
      "icon": Icons.chat_outlined,
      "selectedIcon": Icons.chat,
      "label": "Chat List",
      "route": "/chat_list",
      "widget": const ChatListPage()
    },
    {
      "icon": Icons.account_circle_outlined,
      "selectedIcon": Icons.account_circle,
      "label": "Agents",
      "route": "/agent_list",
      "widget": const AgentListPage()
    },
    // {
    //   "icon": Icons.settings_outlined,
    //   "selectedIcon": Icons.settings,
    //   "label": "Setting",
    //   "route": "/setting"
    // },
  ];
  final String route;

  CustomNavigationBar({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    int currentIndex = pages.indexWhere(
      (element) => element['route'] == route,
    );
    return NavigationBar(
      selectedIndex: currentIndex,
      destinations: pages
          .map((e) => NavigationDestination(
                selectedIcon: Icon(e['selectedIcon'] as IconData),
                icon: Icon(e['icon'] as IconData),
                label: e['label'] as String,
              ))
          .toList(),
      onDestinationSelected: (index) {
        if (index == currentIndex) return;
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  pages[index]['widget'] as Widget,
            ));
      },
    );
  }
}
