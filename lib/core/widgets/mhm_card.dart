import 'package:flutter/material.dart';

class MhmCard extends StatelessWidget {
  final Color background;
  final Widget leading;
  final String title;
  final List<String> lines;

  const MhmCard({
    super.key,
    required this.background,
    required this.leading,
    required this.title,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                ...lines.map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(t),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
