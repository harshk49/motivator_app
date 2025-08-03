import 'package:flutter/material.dart';
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
      // Full-screen dark background
      backgroundColor: colorScheme.surface,
      // Remove system UI overlays for truly full-screen experience
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Enhanced gradient background for depth and visual appeal
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
          child: GestureDetector(
            // Tap anywhere to refresh quote
            onTap: _isLoading ? null : _handleTapToRefresh,
            child: _buildContent(),
          ),
        ),
      ),
      // Floating action button for explicit refresh
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _handleTapToRefresh,
              tooltip: 'New Quote',
              backgroundColor: colorScheme.primary,
              child: const Icon(Icons.refresh),
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
    return Stack(
      children: [
        // Main quote content
        Center(
          child: SingleChildScrollView(
            child: QuoteCard(
              quote: _currentQuote!,
              opacity: _opacity,
            ),
          ),
        ),

        // Subtle hint for tap to refresh
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: _opacity * 0.6,
            duration: const Duration(milliseconds: 600),
            child: const Text(
              'Tap anywhere for a new quote',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
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
