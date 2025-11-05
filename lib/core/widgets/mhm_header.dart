import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/colors.dart';

/// 兼容两套参数：
/// 新：title / subtitle / showMenuLeft / showMenuRight / showBell / showProfile / centerBrand
/// 旧：compact / showActions / showHamburgerLeft / showOverflowRight
class MhmHeader extends StatelessWidget {
  // —— 新参数（推荐）——
  final String? title;
  final String? subtitle;
  final bool? showMenuLeft;
  final bool? showMenuRight;
  final bool? showBell;
  final bool? showProfile;
  final bool? centerBrand;

  // —— 旧参数（兼容）——
  final bool compact;
  final bool showActions;
  final bool showHamburgerLeft;
  final bool showOverflowRight;

  const MhmHeader({
    super.key,
    // 新参数
    this.title,
    this.subtitle,
    this.showMenuLeft,
    this.showMenuRight,
    this.showBell,
    this.showProfile,
    this.centerBrand,
    // 旧参数（保留默认）
    this.compact = false,
    this.showActions = false,
    this.showHamburgerLeft = true,
    this.showOverflowRight = false,
  });

  /// 首页 Hub 用（示例预设）
  static const Widget brandDefault = MhmHeader(
    title: 'MumHelpMum',
    subtitle: 'mumhelpmum.com',
    showMenuLeft: true,
    showMenuRight: false,
    showBell: true,
    showProfile: true,
    centerBrand: true,
  );

  /// 其它页（Planner/Events/Deals）用（示例预设）
  static const Widget brandBasic = MhmHeader(
    title: 'MumHelpMum',
    subtitle: 'mumhelpmum.com',
    showMenuLeft: true,
    showMenuRight: false,
    showBell: false,
    showProfile: false,
    centerBrand: true,
  );

  @override
  Widget build(BuildContext context) {
    // —— 计算“有效值”：新参数优先，缺省则回落到旧参数 —— 
    final String effTitle      = title     ?? 'MumHelpMum';
    final String effSubtitle   = subtitle  ?? 'mumhelpmum.com';
    final bool   effMenuLeft   = showMenuLeft  ?? showHamburgerLeft;
    final bool   effMenuRight  = showMenuRight ?? showOverflowRight;
    final bool   effShowBell   = showBell      ?? showActions;
    final bool   effShowProfile= showProfile   ?? showActions;
    final bool   effCenter     = centerBrand   ?? true;

    final titleStyle = TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: compact ? 20 : 24,
      color: MhmColors.coral,
      height: 1.0,
    );
    final subStyle = TextStyle(
      fontSize: compact ? 12 : 13,
      color: Colors.black54,
      height: 1.0,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 中间品牌（可居中/居左）
            Align(
              alignment: effCenter ? Alignment.center : Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.favorite, size: 20, color: MhmColors.coral),
                    const SizedBox(width: 6),
                    Text(effTitle, style: titleStyle),
                  ]),
                  const SizedBox(height: 2),
                  Text(effSubtitle, style: subStyle),
                ],
              ),
            ),

            // 左侧
            Align(
              alignment: Alignment.centerLeft,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (effMenuLeft)
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                    tooltip: 'Menu',
                  ),
              ]),
            ),

            // 右侧
            Align(
              alignment: Alignment.centerRight,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (effShowBell)
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                    tooltip: 'Notifications',
                  ),
                if (effShowProfile)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.person, color: Colors.black54, size: 18),
                    ),
                  ),
                if (effMenuRight)
                  IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () {},
                    tooltip: 'More',
                  ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
