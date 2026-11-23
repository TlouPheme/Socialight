import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'theme.dart';

void main() {
  runApp(const SocialightApp());
}

class SocialightApp extends StatelessWidget {
  const SocialightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socialight',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const LoginScreen(),
    );
  }
}
