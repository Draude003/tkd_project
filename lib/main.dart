import 'package:flutter/material.dart';
import 'package:tkd/features/login/screens/login_screen.dart';
import 'theme/app_theme.dart';

//import 'features/alert/screens/alert_screen.dart';
//import 'features/parent/screens/parent_home_screen.dart';

void main() {
  runApp(const TKDApp());
}

class TKDApp extends StatelessWidget {
  const TKDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TKD Student App',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
