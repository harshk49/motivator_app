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
          // Subtle card background with rounded corners
          color: colorScheme.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          // Soft shadow for depth
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opening quote mark
            Icon(
              Icons.format_quote,
              size: 32,
              color: colorScheme.primary.withOpacity(0.7),
            ),

            const SizedBox(height: AppTheme.spacingLg),

            // Main quote text
            Text(
              quote.text,
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Author attribution
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
