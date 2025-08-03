import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// Entry point of the Motivator App
/// Sets up the app with a dark theme and launches the home screen
void main() {
  runApp(const MotivatorApp());
}

/// Root widget that configures the app theme and navigation
class MotivatorApp extends StatelessWidget {
  const MotivatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
