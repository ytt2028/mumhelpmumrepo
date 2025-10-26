import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/core/widgets/mhm_segment_tabs.dart';
import 'package:mumhelpmum/features/kids/kids_screen.dart';
import 'package:mumhelpmum/features/mom/mom_screen.dart';
import 'package:mumhelpmum/features/planner/planner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MhmSection section = MhmSection.kids;

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (section) {
      case MhmSection.kids:
        body = KidsScreen();
        break;
      case MhmSection.mom:
        body = MomScreen();
        break;
      case MhmSection.planner:
        body = PlannerScreen();
        break;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: MhmColors.accent, size: 26),
                  const SizedBox(width: 8),
                  Text(
                    'MumHelpMum',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: MhmColors.accent,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text('mumhelpmum.com',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.black54)),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MhmSegmentTabs(
                selected: section,
                onChanged: (s) => setState(() => section = s),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
