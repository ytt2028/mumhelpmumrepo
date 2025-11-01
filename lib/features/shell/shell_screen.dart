import 'package:flutter/material.dart';
import 'package:mumhelpmum/features/hub/hub_screen.dart';
import 'package:mumhelpmum/features/planner/planner_screen.dart';
import 'package:mumhelpmum/features/events/events_screen.dart';
import 'package:mumhelpmum/features/explore/explore_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HubScreen(),        // Mum Help（合并 Kids+Mom）
      const PlannerScreen(),    // Planner（Daily Activities + Nap/Focus Timer）
      const EventsScreen(),     // Events（活动列表）
      const ExploreScreen(),    // Explore（地图 + 搜索/结果）
    ];

    return Scaffold(
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8)),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Mum Help Mum',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_cafe_outlined),
                selectedIcon: Icon(Icons.local_cafe),
                label: 'Planner',
              ),
              NavigationDestination(
                icon: Icon(Icons.campaign_outlined),
                selectedIcon: Icon(Icons.campaign),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.travel_explore_outlined),
                selectedIcon: Icon(Icons.travel_explore),
                label: 'Explore',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
