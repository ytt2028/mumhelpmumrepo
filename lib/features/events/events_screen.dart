import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/core/widgets/mhm_header.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _search = TextEditingController();

  // 顶部筛选 chips（示例）
  final chips = const ['This Week', 'Today', 'Free', 'Workshops', 'Outdoors'];
  final Set<String> selected = {'This Week'};

  final List<EventItem> _events = [
    const EventItem(
      title: 'Kids Art Craft Workshop',
      time: 'Sat, May 18 • 10 AM – 12 PM',
      place: 'Community Hall',
    ),
    const EventItem(
      title: 'Outdoor Family Picnic Day',
      time: 'Fri, May 17 • 10 AM – 5 PM',
      place: 'Local Park',
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _events
        .where((e) =>
            _search.text.isEmpty ||
            e.title.toLowerCase().contains(_search.text.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: MhmColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 统一品牌头（Events 不要铃铛/头像）
            const MhmHeader(
            compact: true,            // 紧凑字号
            showActions: false,       // 不显示头像/铃铛
            showHamburgerLeft: true,  // 左侧汉堡
            showOverflowRight: false, // 右侧更多
          ),
          const SizedBox(height: 8),


            // 搜索栏
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'Search events / areas…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: 'Add example event',
                    icon: const Icon(Icons.add),
                    onPressed: _addExampleEvent,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 8),

            // 横向筛选 Chips
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
                    onSelected: (v) => setState(
                      () => v ? selected.add(label) : selected.remove(label),
                    ),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                    backgroundColor: Colors.white,
                    selectedColor: MhmColors.mint,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSel ? MhmColors.mint : Colors.black26,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // 列表 / 空态
            Expanded(
              child: filtered.isEmpty
                  ? _emptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => _eventTile(filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 单条卡片
  Widget _eventTile(EventItem e) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.event_outlined, size: 28),
        title: Text(
          e.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text('${e.time}\n${e.place}'),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add to Planner',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added "${e.title}" (demo)')),
            );
          },
        ),
      ),
    );
  }

  // 空态
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 48, color: Colors.black38),
            const SizedBox(height: 12),
            const Text(
              'No events found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try a different keyword or load example data.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: _loadExamples,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MhmColors.mint,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Load Example Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addExampleEvent() {
    setState(() {
      _events.insert(
        0,
        const EventItem(
          title: 'Storytime at Central Library',
          time: 'Wed, May 22 • 11 AM – 11:45 AM',
          place: 'Central Library',
        ),
      );
    });
  }

  void _loadExamples() {
    setState(() {
      _events.addAll(const [
        EventItem(
          title: 'Puppet Show for Toddlers',
          time: 'Sun, May 19 • 3 PM – 4 PM',
          place: 'City Theater',
        ),
        EventItem(
          title: 'Mums & Bubs Yoga',
          time: 'Thu, May 23 • 9 AM – 10 AM',
          place: 'Wellness Studio',
        ),
      ]);
    });
  }
}

class EventItem {
  final String title;
  final String time;
  final String place;
  const EventItem({
    required this.title,
    required this.time,
    required this.place,
  });
}
