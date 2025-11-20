// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mumhelpmum/core/theme/app_theme.dart';
import 'package:mumhelpmum/features/auth/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const AuthGate(),
    );
  }
}
