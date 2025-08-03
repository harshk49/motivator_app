import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'services/quote_service.dart';

// Global instance of QuoteService to be shared across the app
late QuoteService quoteService;

/// Entry point of the Motivator App
/// Sets up the app with a dark theme and loads quotes at startup
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize quote service and load all quotes once at startup
  quoteService = QuoteService();
  try {
    await quoteService.initialize();
  } catch (e) {
    // Log error but continue app startup
    debugPrint('Failed to initialize quotes: $e');
  }

  // Set system UI overlay style for dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

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
      // Force dark theme only
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
