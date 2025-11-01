import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});
  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  final _search = TextEditingController();
  final Set<String> _filters = {'Stroller-friendly'}; // 默认示例
  List<Activity> _data = []; // 首次为空，显示空态

  final _allChips = const [
    'Fenced', 'Stroller-friendly', 'Shaded', 'Indoor', 'Group buy', 'Promotions'
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Activity> get _filtered {
    final q = _search.text.trim().toLowerCase();
    return _data.where((a) {
      final matchQ = q.isEmpty || a.title.toLowerCase().contains(q) || a.subtitle.toLowerCase().contains(q);
      final matchTag = _filters.isEmpty || _filters.every((f) => a.tags.contains(f));
      return matchQ && matchTag;
    }).toList();
  }

  void _loadExamples() {
    setState(() {
      _data = [
        Activity(Icons.park_outlined, 'Adventure Playground', '1.2 km away • Today 10 AM • Free',
            tags: const ['Fenced','Shaded','Stroller-friendly']),
        Activity(Icons.local_library_outlined, 'Library Storytime', '0.5 km away • Wed & Fri • Free',
            tags: const ['Indoor','Stroller-friendly','Promotions']),
        Activity(Icons.local_cafe_outlined, 'Cozzy Kids Cafe', '2.1 km away • Mon & Sun • \$',
            tags: const ['Indoor','Group buy']),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;

    return Column(
      children: [
        const SizedBox(height: 8),
        // 顶部品牌
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: MhmColors.accent, size: 26),
              const SizedBox(width: 8),
              Text('MumHelpMum', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800, color: MhmColors.accent,
              )),
              const Spacer(),
              const Icon(Icons.menu),
            ],
          ),
        ),
        Text('mumhelpmum.com',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black54)),
        const SizedBox(height: 10),

        // 搜索
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _search,
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

        // Chips
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _allChips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final label = _allChips[i];
              final selected = _filters.contains(label);
              final primary = label == 'Stroller-friendly';
              return FilterChip(
                label: Text(label),
                selected: selected,
                onSelected: (v) => setState(() => v ? _filters.add(label) : _filters.remove(label)),
                showCheckmark: false,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Colors.white,
                selectedColor: primary ? MhmColors.mint : Colors.black12,
                shape: StadiumBorder(
                  side: BorderSide(color: selected ? MhmColors.mint : Colors.black26),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // 列表 or 空态
        Expanded(
          child: list.isEmpty
              ? _EmptyState(onLoadExamples: _loadExamples)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _ActivityTile(
                    activity: list[i],
                    onAdd: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added "${list[i].title}" to Planner (mock)')),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class Activity {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> tags;
  Activity(this.icon, this.title, this.subtitle, {this.tags = const []});
}

class _ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback onAdd;
  const _ActivityTile({required this.activity, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,6))],
      ),
      child: ListTile(
        leading: Icon(activity.icon, size: 28),
        title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(activity.subtitle),
        trailing: IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: onAdd),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onLoadExamples;
  const _EmptyState({required this.onLoadExamples});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.family_restroom, size: 88, color: Colors.black26),
            const SizedBox(height: 12),
            Text('No activities found yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Try enable location or view examples.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onLoadExamples,
              style: ElevatedButton.styleFrom(
                backgroundColor: MhmColors.mint, foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text('Load Example Data'),
            ),
          ],
        ),
      ),
    );
  }
}
