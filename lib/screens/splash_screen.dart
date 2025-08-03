import 'package:flutter/material.dart';
import 'home_screen.dart';

/// Splash screen that displays app branding and transitions smoothly to main screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _logoSlide;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo fade-in and slide up animation
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    // Title appears after logo
    _titleOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    ));

    // Subtitle appears last
    _subtitleOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    ));
  }

  void _startAnimationSequence() {
    _animationController.forward().then((_) {
      // Hold for a moment before transitioning
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _navigateToHome();
        }
      });
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Smooth fade transition
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Matching gradient with main screen
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withOpacity(0.9),
              colorScheme.surface.withOpacity(0.95),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with slide and fade animation
                  SlideTransition(
                    position: _logoSlide,
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: Container(
                        width: screenSize.width > 600 ? 120 : 100,
                        height: screenSize.width > 600 ? 120 : 100,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            screenSize.width > 600 ? 60 : 50,
                          ),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.format_quote,
                          size: screenSize.width > 600 ? 60 : 50,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenSize.width > 600 ? 40 : 32),

                  // App title with fade animation
                  FadeTransition(
                    opacity: _titleOpacity,
                    child: Text(
                      'Motivator',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: screenSize.width > 600 ? 48 : 42,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: screenSize.width > 600 ? 20 : 16),

                  // Subtitle with fade animation
                  FadeTransition(
                    opacity: _subtitleOpacity,
                    child: Text(
                      'Daily Inspiration',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: screenSize.width > 600 ? 20 : 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.8,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
