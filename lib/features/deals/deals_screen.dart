import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/core/widgets/mhm_header.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MhmColors.bg,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // 统一品牌头
          // 顶部品牌头（新 API）
            const MhmHeader(
              compact: true,            // 紧凑字号
              showActions: false,       // 不显示头像/铃铛
              showHamburgerLeft: true,  // 左侧汉堡
              showOverflowRight: false, // 右侧更多菜单
            ),
            const SizedBox(height: 8),

          // 顶部筛选 Chips：Free / Group Buy / MHM Benifit（妈帮专享）
          _DealsChips(),

          const SizedBox(height: 12),

          // 示例卡片列表
          _DealCard(
            icon: Icons.park_outlined,
            title: 'Adventure Playground — Free Day',
            subtitle: 'This Sat • 10:00–16:00 • Free entry for kids',
            badge: 'Free',
            badgeColor: MhmColors.mint,
          ),
          _DealCard(
            icon: Icons.coffee_outlined,
            title: 'Cozzy Kids Cafe — Group Buy',
            // ⚠️ 价格里的 $ 需要转义
            subtitle: 'Mon–Sun • Group bundle • 2 drinks + 2 snacks just \$18',
            badge: 'Group Buy',
            badgeColor: Colors.orangeAccent,
          ),
          _DealCard(
            icon: Icons.storefront_outlined,
            title: 'Little Steps Store — 15% Off',
            subtitle: 'Weekdays • Code: MHM15 • Exclusive “MHM Benefit”',
            badge: 'MHM Benefit',
            badgeColor: MhmColors.coral,
          ),
        ],
      ),
    );
  }
}

class _DealsChips extends StatefulWidget {
  @override
  State<_DealsChips> createState() => _DealsChipsState();
}

class _DealsChipsState extends State<_DealsChips> {
  int selected = 0; // 0=Free, 1=Group Buy, 2=MHM Benefit

  @override
  Widget build(BuildContext context) {
    final items = ['Free', 'Group Buy', 'MHM Benefit'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final isSel = i == selected;
          return ChoiceChip(
            label: Text(items[i]),
            selected: isSel,
            onSelected: (_) => setState(() => selected = i),
            selectedColor: MhmColors.mint,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSel ? Colors.white : MhmColors.text,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: isSel ? Colors.transparent : Colors.black12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          );
        },
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;

  const _DealCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: MhmColors.mint.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: MhmColors.text),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: MhmColors.text),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: badgeColor.withOpacity(.25)),
                      ),
                      child: Text(badge, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: badgeColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(fontSize: 13, color: MhmColors.text.withOpacity(0.65))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add to Planner',
          ),
        ],
      ),
    );
  }
}
