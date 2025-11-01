import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/app_theme.dart';
import 'package:mumhelpmum/features/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MhmApp());
}

class MhmApp extends StatelessWidget {
  const MhmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MumHelpMum',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // 这里不使用 const 也可以；保持简单更稳
      home: HomeScreen(),
    );
  }
}

