import 'package:flutter/material.dart';

/// 通用圆角卡片：支持标题区 + 自定义 body。
class MhmCard extends StatelessWidget {
  final Color? background;
  final Widget? leading;
  final String? title;          // 简单标题
  final Widget? titleWidget;    // 或完全自定义标题
  final Widget? trailing;
  final Widget? body;           // ⭐ 这就是 Planner 用到的 body
  final EdgeInsetsGeometry padding;

  const MhmCard({
    super.key,
    this.background,
    this.leading,
    this.title,
    this.titleWidget,
    this.trailing,
    this.body,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final hasHeader = leading != null || title != null || titleWidget != null || trailing != null;

    return Container(
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasHeader)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 8)],
                if (titleWidget != null)
                  Expanded(
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      child: titleWidget!,
                    ),
                  )
                else if (title != null)
                  Expanded(
                    child: Text(title!,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  ),
                if (trailing != null) trailing!,
              ],
            ),
          if (hasHeader && body != null) const SizedBox(height: 8),
          if (body != null) body!,
        ],
      ),
    );
  }
}
