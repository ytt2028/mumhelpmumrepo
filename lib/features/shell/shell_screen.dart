import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';
import 'package:mumhelpmum/features/hub/hub_screen.dart';
import 'package:mumhelpmum/features/deals/deals_screen.dart';
import 'package:mumhelpmum/features/events/events_screen.dart';
import 'package:mumhelpmum/features/planner/planner_screen.dart';
import 'package:mumhelpmum/features/hub/create_post_sheet.dart';
import 'package:mumhelpmum/core/state/feed_state.dart';
import 'package:mumhelpmum/features/hub/post_model.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});
  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  static const double _fabSize = 64;
  static const double _barHeight = 72;

  int _index = 0;

  /// 顺序：Mumhelpmum → Deals → Events → Planner
  final _pages = const [
    HubScreen(),
    DealsScreen(),
    EventsScreen(),
    PlannerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: MhmColors.bg,
      body: SafeArea(child: _pages[_index]),

      // 让凹槽居中并与 FAB 对齐
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: math.max(2, bottomInset)),
        child: SizedBox(
          width: _fabSize,
          height: _fabSize,
          child: FloatingActionButton(
            backgroundColor: MhmColors.coral,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            onPressed: () async {
              // 打开发帖面板并接收返回数据（需要 CreatePostSheet 返回 Map<String, dynamic>）
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const CreatePostSheet(),
              );

              if (!mounted || result == null) return;

              // 根据你的 Post 模型构造新贴
              final post = Post(
                author: 'You',
                content: (result['content'] ?? '') as String,
                tags: List<String>.from(result['tags'] ?? const []),
                imageUrl: result['imageUrl'] as String?,
                createdAt: DateTime.tryParse(result['createdAt'] as String? ?? '') ?? DateTime.now(),
                likes: 0,
                comments: 0,
                shares: 0,
              );

              // 插到 feed 顶部
              final current = List<Post>.from(FeedState.I.feed.value);
              FeedState.I.feed.value = [post, ...current];

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Posted!')),
              );
            },
            child: const Icon(Icons.add, size: 30, color: Colors.white),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          // 底部边距叠加安全区，防止任何溢出
          padding: EdgeInsets.fromLTRB(12, 8, 12, math.max(8, bottomInset)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SizedBox(
              height: _barHeight,
              child: BottomAppBar(
                color: Colors.white,
                height: _barHeight,
                elevation: 0,
                // 圆形凹槽；notchMargin 控制凹槽与 FAB 的间隙
                shape: const CircularNotchedRectangle(),
                notchMargin: 8,
                child: Row(
                  children: [
                    Expanded(
                      child: _NavItem(
                        index: 0,
                        current: _index,
                        label: 'Mumhelpmum',
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home_rounded,
                        onTap: _onTap,
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        index: 1,
                        current: _index,
                        label: 'Deals',
                        icon: Icons.local_offer_outlined,
                        selectedIcon: Icons.local_offer,
                        onTap: _onTap,
                      ),
                    ),

                    // 中间留位给凹槽和 FAB（≈ FAB 宽 + 两侧间隙）
                    const SizedBox(width: _fabSize + 24),

                    Expanded(
                      child: _NavItem(
                        index: 2,
                        current: _index,
                        label: 'Events',
                        icon: Icons.campaign_outlined,
                        selectedIcon: Icons.campaign,
                        onTap: _onTap,
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        index: 3,
                        current: _index,
                        label: 'Planner',
                        icon: Icons.local_cafe_outlined,
                        selectedIcon: Icons.local_cafe,
                        onTap: _onTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int i) => setState(() => _index = i);
}

/// 紧凑导航项（避免高度溢出）
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.current,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  });

  final int index;
  final int current;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final selected = index == current;

    return InkWell(
      onTap: () => onTap(index),
      child: SizedBox(
        height: 34, // 小于父约束，确保不溢出
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: selected ? MhmColors.mint.withOpacity(.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                selected ? selectedIcon : icon,
                size: 16,
                color: selected ? MhmColors.mint : Colors.black87,
              ),
            ),
            const SizedBox(height: 1),
            FittedBox(
              child: Text(
                label,
                textScaler: const TextScaler.linear(1.0),
                style: const TextStyle(
                  fontSize: 9,
                  height: 1.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
