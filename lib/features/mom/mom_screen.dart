import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/mhm_card.dart';
import '../../core/widgets/mhm_share_button.dart';

class MomScreen extends StatelessWidget {
  const MomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              MhmCard(
                background: MhmColors.cardSupport,
                leading: const Icon(Icons.groups_2, size: 36),
                title: 'Support Groups',
                lines: const [
                  'Local meetups',
                  'Online communities',
                  '• Free clothes, toys, & furniture'
                ],
              ),
              const SizedBox(height: 14),
              MhmCard(
                background: MhmColors.cardActivities,
                leading: const Icon(Icons.apartment, size: 36),
                title: 'Local Activities',
                lines: const ['Playgroups & classes', 'Library storytime'],
              ),
              const SizedBox(height: 14),
              MhmCard(
                background: MhmColors.cardHealth,
                leading: const Icon(Icons.favorite_border, size: 36),
                title: 'Health & Wellness',
                lines: const ['Postnatal yoga', 'Pelvic floor physio'],
              ),
            ],
          ),
        ),
        const Spacer(),
        MhmShareButton(onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Voice: coming soon')),
          );
        }),
      ],
    );
  }
}
