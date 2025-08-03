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

    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(
          milliseconds:
              (AppTheme.quoteAnimation.inMilliseconds * (1.0 - opacity))
                  .round()),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg,
          vertical: AppTheme.spacingXl,
        ),
        padding: const EdgeInsets.all(AppTheme.spacingXl),
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
            // Opening quote mark with enhanced styling
            Icon(
              Icons.format_quote,
              size: 36,
              color: colorScheme.primary.withOpacity(0.8),
            ),

            const SizedBox(height: AppTheme.spacingLg),

            // Main quote text with enhanced centering and typography
            Text(
              quote.text,
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: null,
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Author attribution with enhanced styling
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '— ${quote.author}',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
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
