import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final chips = ['This Week','Today','Free','Workshops','Outdoors'];
  final Set<String> selected = {'This Week'};

  @override
  Widget build(BuildContext context) {
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
              Text('MumHelpMum',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: MhmColors.accent,
                      )),
            ],
          ),
        ),
        Text('mumhelpmum.com',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black54)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Events',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          ),
        ),
        const SizedBox(height: 8),

        // 搜索
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search events / areas…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.add),
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
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: chips.length,
            itemBuilder: (_, i) {
              final label = chips[i];
              final sel = selected.contains(label);
              return FilterChip(
                label: Text(label),
                selected: sel,
                onSelected: (v) => setState(() => v ? selected.add(label) : selected.remove(label)),
                showCheckmark: false,
                backgroundColor: Colors.white,
                selectedColor: MhmColors.mint,
                labelStyle: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                shape: StadiumBorder(side: BorderSide(color: sel ? MhmColors.mint : Colors.black26)),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // 列表
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: const [
              _EventCard(
                title: 'Kids Art Craft Workshop',
                time: 'Sat, May 18 • 10 AM – 12 PM',
                place: 'Community Hall',
                imageUrl: 'https://picsum.photos/seed/kidsart/600/300',
              ),
              SizedBox(height: 12),
              _EventCard(
                title: 'Outdoor Family Picnic Day',
                time: 'Fri, May 17 • 10 AM – 5 PM',
                place: 'Local Park',
                imageUrl: 'https://picsum.photos/seed/picnic/600/300',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title, time, place, imageUrl;
  const _EventCard({required this.title, required this.time, required this.place, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,6))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
          ),
          ListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('$time\n$place'),
            trailing: IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
