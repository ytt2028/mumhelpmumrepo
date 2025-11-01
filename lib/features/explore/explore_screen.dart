import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

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
              const Icon(Icons.menu),
              const Spacer(),
              const Icon(Icons.favorite, color: MhmColors.accent),
              const SizedBox(width: 6),
              Text('MumHelpMum', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800, color: MhmColors.accent,
              )),
              const Spacer(),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
        Text('mumhelpmum.com',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black54)),
        const SizedBox(height: 10),

        // 搜索 + 过滤按钮
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search locations, parks, cafes',
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
              const SizedBox(width: 8),
              Container(
                height: 48, width: 48,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,4))]),
                child: const Icon(Icons.restaurant_menu_outlined),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 地图占位（Stack + 彩色标记）
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 260,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: Colors.grey.shade200),
                  CustomPaint(painter: _GridPainter()), // 网格当做简易地图
                  // 若干标记
                  const _Pin(top: 40, left: 60, icon: Icons.park_outlined, color: MhmColors.mint),
                  const _Pin(top: 120, right: 60, icon: Icons.local_cafe_outlined, color: Colors.redAccent),
                  const _Pin(bottom: 40, left: 90, icon: Icons.museum_outlined, color: Colors.teal),
                  const _Pin(bottom: 30, right: 40, icon: Icons.home_outlined, color: Colors.blueAccent),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // 结果列表
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: const [
              _ResultTile(
                icon: Icons.park_outlined,
                title: 'Adventure Playground',
                subtitle: '1.2 km away • Fenced • Shaded',
              ),
              SizedBox(height: 10),
              _ResultTile(
                icon: Icons.local_cafe_outlined,
                title: 'Storytime Cafe',
                subtitle: '0.8 km away • Indoor • Stroller-friendly',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _ResultTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,6))],
      ),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {}),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  final double? top, left, right, bottom;
  final IconData icon;
  final Color color;
  const _Pin({this.top, this.left, this.right, this.bottom, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, left: left, right: right, bottom: bottom,
      child: Icon(icon, color: color, size: 28),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white..strokeWidth = 1;
    final step = 24.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
