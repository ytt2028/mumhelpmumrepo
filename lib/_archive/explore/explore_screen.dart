import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/core/widgets/mhm_header.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final controller = TextEditingController();
  final chips = const ['Group buy', 'Promotions']; // 按你的要求只保留这两项
  final Set<String> selected = {'Group buy'};

  final activities = const [
    Activity(Icons.park_outlined, 'Adventure Playground',
        '1.2 km away • Today 10 AM • Free'),
    Activity(Icons.local_library_outlined, 'Library Storytime',
        '0.5 km away • Wed & Fri • Free'),
    Activity(Icons.local_cafe_outlined, 'Cozzy Kids Cafe',
        '2.1 km away • Mon & Sun • \$\$', // 注意 \$\$
    ),
  ];

  List<Activity> get filtered {
    final q = controller.text.trim().toLowerCase();
    return activities
        .where((a) =>
            q.isEmpty ||
            a.title.toLowerCase().contains(q) ||
            a.subtitle.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = filtered;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MhmHeader(compact: true),

          // 搜索栏
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search activities / places…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 横向 chips（Group buy / Promotions）
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: chips.length,
              itemBuilder: (_, i) {
                final label = chips[i];
                final isSel = selected.contains(label);
                return FilterChip(
                  label: Text(label),
                  selected: isSel,
                  onSelected: (v) =>
                      setState(() => v ? selected.add(label) : selected.remove(label)),
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: MhmColors.mint,
                  shape: StadiumBorder(
                    side: BorderSide(color: isSel ? MhmColors.mint : Colors.black26),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // 活动列表
          ...list.map(_activityTile).toList(),
        ],
      ),
    );
  }

  Widget _activityTile(Activity a) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: ListTile(
        leading: Icon(a.icon, size: 28),
        title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(a.subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added "${a.title}" (demo)')),
            );
          },
        ),
      ),
    );
  }
}

class Activity {
  final IconData icon;
  final String title;
  final String subtitle;
  const Activity(this.icon, this.title, this.subtitle);
}
