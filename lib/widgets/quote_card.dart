import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../theme/app_theme.dart';

/// A beautifully styled card widget that displays a motivational quote
/// Features elegant typography, proper spacing, and smooth animations
class QuoteCard extends StatelessWidget {
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

    // Responsive padding based on screen size
    final horizontalPadding = isLargeScreen 
        ? screenSize.width * 0.15 
        : isTablet 
            ? AppTheme.spacingXxl 
            : AppTheme.spacingLg;
    
    final verticalPadding = isTablet 
        ? AppTheme.spacingXxl * 1.5 
        : AppTheme.spacingXl;

    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(
          milliseconds:
              (AppTheme.quoteAnimation.inMilliseconds * (1.0 - opacity))
                  .round()),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        padding: EdgeInsets.all(
          isTablet ? AppTheme.spacingXxl : AppTheme.spacingXl,
        ),
        decoration: BoxDecoration(
          // Enhanced card background with better visual hierarchy
          color: colorScheme.surface.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.3),
            width: 1.5,
          ),
          // Enhanced shadow for better depth and centering emphasis
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Opening quote mark with responsive sizing
            Icon(
              Icons.format_quote,
              size: isTablet ? 48 : 36,
              color: colorScheme.primary.withOpacity(0.8),
            ),

            SizedBox(height: isTablet ? AppTheme.spacingXl : AppTheme.spacingLg),

            // Main quote text with responsive typography and enhanced readability
            Text(
              quote.text,
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: quoteFontSize,
                height: 1.4, // Improved line height for better readability
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
              maxLines: null,
            ),

            SizedBox(height: isTablet ? AppTheme.spacingXxl : AppTheme.spacingXl),

            // Author attribution with responsive styling
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? AppTheme.spacingLg : AppTheme.spacingMd,
                vertical: isTablet ? AppTheme.spacingMd : AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
              ),
              child: Text(
                '— ${quote.author}',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                  fontSize: authorFontSize,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
