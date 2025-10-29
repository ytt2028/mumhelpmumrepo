import 'package:flutter/material.dart';
import '../theme/colors.dart';

enum MhmSection { kids, mom, planner }

class MhmSegmentTabs extends StatelessWidget {
  final MhmSection selected;
  final ValueChanged<MhmSection> onChanged;

  const MhmSegmentTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final entries = <MhmSection, String>{
      MhmSection.kids: 'Kids',
      MhmSection.mom: 'Mom',
      MhmSection.planner: 'Planner',
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: entries.entries.map((e) {
          final active = e.key == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? MhmColors.mint : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: Text(
                  e.value,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : MhmColors.text,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
