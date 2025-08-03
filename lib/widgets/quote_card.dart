import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../theme/app_theme.dart';

/// A beautifully styled card widget that displays a motivational quote
/// Features elegant typography, proper spacing, and enhanced smooth animations
class QuoteCard extends StatefulWidget {
  /// The quote to display
  final Quote quote;

  /// Optional opacity for fade animations
  final double opacity;

  /// Creates a QuoteCard widget
  const QuoteCard({
    super.key,
    required this.quote,
    this.opacity = 1.0,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppTheme.quoteAnimation,
      vsync: this,
    );

    // Scale animation for subtle zoom effect
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // Enhanced opacity animation
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Subtle slide up animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation when widget appears
    _animationController.forward();
  }

  @override
  void didUpdateWidget(QuoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation when quote changes
    if (oldWidget.quote.text != widget.quote.text) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isLargeScreen = screenSize.width > 900;

    // Responsive font sizes based on screen size
    final quoteFontSize = isLargeScreen
        ? 32.0
        : isTablet
            ? 28.0
            : screenSize.width < 350
                ? 22.0
                : 26.0;

    final authorFontSize = isLargeScreen
        ? 20.0
        : isTablet
            ? 18.0
            : 16.0;

    // Enhanced responsive padding with better aesthetics
    final horizontalPadding = isLargeScreen
        ? screenSize.width * 0.12 // Slightly reduced for better balance
        : isTablet
            ? AppTheme.spacingXxl * 1.2
            : AppTheme.spacingLg * 1.1;

    final verticalPadding =
        isTablet ? AppTheme.spacingXxl * 1.8 : AppTheme.spacingXl * 1.3;

    final cardPadding = isLargeScreen
        ? AppTheme.spacingXxl * 1.5
        : isTablet
            ? AppTheme.spacingXxl * 1.2
            : AppTheme.spacingXl * 1.1;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedOpacity(
              opacity: widget.opacity * _opacityAnimation.value,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  // Enhanced card background with better visual hierarchy
                  color: colorScheme.surface.withOpacity(0.18),
                  borderRadius:
                      BorderRadius.circular(AppTheme.radiusCard * 1.2),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.25),
                    width: 1.5,
                  ),
                  // Enhanced shadow for better depth and centering emphasis
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 3,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                    // Subtle glow effect
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.05),
                      blurRadius: 25,
                      spreadRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Opening quote mark with enhanced styling and animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8 + (0.2 * value),
                          child: Icon(
                            Icons.format_quote,
                            size: isTablet ? 56 : 42,
                            color: colorScheme.primary.withOpacity(0.8 * value),
                          ),
                        );
                      },
                    ),

                    SizedBox(
                      height: isLargeScreen
                          ? AppTheme.spacingXl * 1.5
                          : isTablet
                              ? AppTheme.spacingXl * 1.2
                              : AppTheme.spacingLg * 1.1,
                    ),

                    // Main quote text with enhanced typography and better spacing
                    Text(
                      widget.quote.text,
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: quoteFontSize,
                        height: 1.45, // Slightly improved line height
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: null,
                    ),

                    SizedBox(
                      height: isLargeScreen
                          ? AppTheme.spacingXxl * 1.3
                          : isTablet
                              ? AppTheme.spacingXxl * 1.1
                              : AppTheme.spacingXl * 1.1,
                    ),

                    // Author attribution with enhanced styling and better spacing
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen
                            ? AppTheme.spacingLg * 1.3
                            : isTablet
                                ? AppTheme.spacingLg
                                : AppTheme.spacingMd * 1.2,
                        vertical: isLargeScreen
                            ? AppTheme.spacingMd * 1.2
                            : isTablet
                                ? AppTheme.spacingMd
                                : AppTheme.spacingSm * 1.3,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withOpacity(0.12),
                            colorScheme.primary.withOpacity(0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          isLargeScreen
                              ? 28
                              : isTablet
                                  ? 26
                                  : 22,
                        ),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '— ${widget.quote.author}',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.85),
                          fontSize: authorFontSize,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 0.5),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
