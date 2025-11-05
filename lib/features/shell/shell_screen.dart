import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/features/hub/hub_screen.dart';
import 'package:mumhelpmum/features/deals/deals_screen.dart';
import 'package:mumhelpmum/features/events/events_screen.dart';
import 'package:mumhelpmum/features/planner/planner_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;

  /// 新顺序：Mumhelpmum → Deals → Events → Planner
  final List<Widget> _pages = const [
    HubScreen(),
    DealsScreen(),
    EventsScreen(),
    PlannerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MhmColors.bg,
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            backgroundColor: Colors.white,
            height: 64,
            elevation: 0,
            indicatorColor: MhmColors.mint.withOpacity(0.15),
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Mumhelpmum',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_offer_outlined),
                selectedIcon: Icon(Icons.local_offer),
                label: 'Deals',
              ),
              NavigationDestination(
                icon: Icon(Icons.campaign_outlined),
                selectedIcon: Icon(Icons.campaign),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_cafe_outlined),
                selectedIcon: Icon(Icons.local_cafe),
                label: 'Planner',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
