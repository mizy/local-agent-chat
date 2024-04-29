import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final List<Map<String, dynamic>> pages = [
    {
      "icon": Icons.chat_outlined,
      "selectedIcon": Icons.chat,
      "label": "Chat List",
      "route": "/chat_list"
    },
    {
      "icon": Icons.message_outlined,
      "selectedIcon": Icons.message,
      "label": "Agents",
      "route": "/agent_list"
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
        Navigator.pushReplacementNamed(
          context,
          pages[index]['route'] as String,
        );
      },
    );
  }
}
