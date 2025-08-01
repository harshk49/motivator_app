import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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
      theme: ThemeData(
        // Dark theme configuration for a modern, minimalist look
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        // Custom text theme for better quote readability
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
