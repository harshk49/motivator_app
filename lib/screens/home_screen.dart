import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote.dart';
import '../widgets/quote_card.dart';
import '../main.dart'; // Import to access global quoteService

/// Main screen of the app that displays motivational quotes
/// Features tap-to-refresh functionality and smooth animations
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Currently displayed quote
  Quote? _currentQuote;

  /// Loading state indicator
  bool _isLoading = true;

  /// Error state message
  String? _errorMessage;

  /// Animation opacity for fade effects
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _loadInitialQuote();
  }

  /// Loads the first random quote on app launch immediately
  void _loadInitialQuote() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _opacity = 0.0;
    });

    try {
      // Get random quote from pre-loaded in-memory list
      final quote = quoteService.getRandomQuote();
      if (quote != null) {
        setState(() {
          _currentQuote = quote;
          _isLoading = false;
        });
        // Trigger fade-in animation
        _animateIn();
      } else {
        setState(() {
          _errorMessage = 'No quotes available';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load quote: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  /// Triggers the fade-in animation
  void _animateIn() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  /// Handles tap to refresh with smooth fade transition
  void _handleTapToRefresh() {
    // Fade out current quote
    setState(() {
      _opacity = 0.0;
    });

    // Wait for fade out to complete, then load new quote
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _loadNewQuote();
      }
    });
  }

  /// Loads a new random quote for refresh action
  void _loadNewQuote() {
    try {
      // Get new random quote from pre-loaded in-memory list
      final quote = quoteService.getRandomQuote();
      if (quote != null) {
        setState(() {
          _currentQuote = quote;
          _errorMessage = null;
        });
        // Trigger fade-in animation
        _animateIn();
      } else {
        setState(() {
          _errorMessage = 'No quotes available';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load quote: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
          child: Column(
            children: [
              // Enhanced header with app title and stats
              _buildHeader(),

              // Main content area
              Expanded(
                child: GestureDetector(
                  onTap: _isLoading ? null : _handleTapToRefresh,
                  child: _buildContent(),
                ),
              ),

              // Interactive bottom panel with action buttons
              _buildBottomPanel(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds enhanced header with app branding and stats
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // App logo/icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          // App title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Motivator',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                Text(
                  'Daily inspiration for your journey',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),

          // Quote counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Text(
              '${quoteService.quoteCount}+ quotes',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds interactive bottom panel with action buttons
  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Instruction text
          AnimatedOpacity(
            opacity: _opacity * 0.8,
            duration: const Duration(milliseconds: 600),
            child: Text(
              'Tap the quote for a new one, or use the actions below',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Refresh button
              _buildActionButton(
                icon: Icons.refresh,
                label: 'New Quote',
                onTap: _isLoading ? null : _handleTapToRefresh,
                isPrimary: true,
              ),

              // Share button
              _buildActionButton(
                icon: Icons.share,
                label: 'Share',
                onTap: _currentQuote != null ? _shareQuote : null,
              ),

              // Copy button
              _buildActionButton(
                icon: Icons.copy,
                label: 'Copy',
                onTap: _currentQuote != null ? _copyQuote : null,
              ),

              // Favorite button (placeholder for future enhancement)
              _buildActionButton(
                icon: Icons.favorite_outline,
                label: 'Save',
                onTap: _currentQuote != null ? _saveQuote : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual action button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary && isEnabled
              ? theme.colorScheme.primary
              : theme.colorScheme.surface.withOpacity(isEnabled ? 0.3 : 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary && isEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(isEnabled ? 0.3 : 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isPrimary && isEnabled
                  ? Colors.white
                  : theme.colorScheme.onSurface
                      .withOpacity(isEnabled ? 0.8 : 0.3),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isPrimary && isEnabled
                    ? Colors.white
                    : theme.colorScheme.onSurface
                        .withOpacity(isEnabled ? 0.8 : 0.3),
                fontWeight: isPrimary ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shares the current quote
  void _shareQuote() {
    if (_currentQuote != null) {
      // Note: In a real app, you'd use share_plus package
      // Share.share(text);
      _showSnackBar('Share functionality would open here');
    }
  }

  /// Copies the current quote to clipboard
  void _copyQuote() {
    if (_currentQuote != null) {
      final text = '"${_currentQuote!.text}"\n\n— ${_currentQuote!.author}';
      Clipboard.setData(ClipboardData(text: text));
      _showSnackBar('Quote copied to clipboard!');
    }
  }

  /// Saves the current quote (placeholder)
  void _saveQuote() {
    if (_currentQuote != null) {
      // In a real app, you'd save to local storage or favorites
      _showSnackBar('Quote saved to favorites!');
    }
  }

  /// Shows a snackbar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Builds the main content based on current state
  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_currentQuote != null) {
      return _buildQuoteState();
    }

    return _buildEmptyState();
  }

  /// Loading state with spinner
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text(
            'Loading inspiration...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  /// Error state with retry option
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadInitialQuote,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  /// Main quote display state
  Widget _buildQuoteState() {
    return Center(
      child: SingleChildScrollView(
        child: QuoteCard(
          quote: _currentQuote!,
          opacity: _opacity,
        ),
      ),
    );
  }

  /// Empty state (should rarely occur)
  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No quotes available',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
