import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: MhmColors.mint),
    scaffoldBackgroundColor: MhmColors.bg,
  );

  // 底部导航：更小字号/图标，并区分选中/未选中颜色
  final labelStyle = MaterialStateProperty.resolveWith<TextStyle?>((states) {
    final selected = states.contains(MaterialState.selected);
    return TextStyle(
      fontSize: 11, // ← 你要的小字号
      fontWeight: FontWeight.w600,
      color: selected ? Colors.white : MhmColors.text,
    );
  });

  final iconTheme = MaterialStateProperty.resolveWith<IconThemeData?>((states) {
    final selected = states.contains(MaterialState.selected);
    return IconThemeData(
      size: 20, // ← 更小图标
      color: selected ? Colors.white : MhmColors.text,
    );
  });

  return base.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: MhmColors.text,
      displayColor: MhmColors.text,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: MhmColors.bg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: const CardThemeData( // ✅ 用 CardThemeData
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 56,                       // 更矮
      backgroundColor: Colors.transparent,
      indicatorColor: MhmColors.mint,
      indicatorShape: const StadiumBorder(),
      labelTextStyle: labelStyle,       // 小字号
      iconTheme: iconTheme,             // 小图标
      surfaceTintColor: Colors.transparent,
    ),
  );
}
