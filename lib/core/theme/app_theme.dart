import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: MhmColors.mint),
    scaffoldBackgroundColor: MhmColors.bg,
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
  );
}
