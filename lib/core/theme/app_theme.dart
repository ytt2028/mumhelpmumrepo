import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: MhmColors.mint),
    scaffoldBackgroundColor: MhmColors.bg,
  );

  final selectedLabel = MaterialStateProperty.resolveWith<TextStyle?>(
    (states) => TextStyle(
      fontWeight: FontWeight.w600,
      color: states.contains(MaterialState.selected) ? Colors.white : MhmColors.text,
    ),
  );

  final iconTheme = MaterialStateProperty.resolveWith<IconThemeData?>(
    (states) => IconThemeData(
      color: states.contains(MaterialState.selected) ? Colors.white : MhmColors.text,
    ),
  );

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
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 64,
      backgroundColor: Colors.transparent, // 我们外层自定义容器做白底&圆角
      indicatorColor: MhmColors.mint,
      indicatorShape: const StadiumBorder(),
      labelTextStyle: selectedLabel,
      iconTheme: iconTheme,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
