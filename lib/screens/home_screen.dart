import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';
import '../widgets/quote_card.dart';

/// Main screen of the app that displays motivational quotes
/// Features tap-to-refresh functionality and smooth animations
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Service for managing quotes
  final QuoteService _quoteService = QuoteService();

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
    _loadRandomQuote();
  }

  /// Loads a random quote and updates the UI
  Future<void> _loadRandomQuote() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _opacity = 0.0;
    });

    try {
      final quote = await _quoteService.getRandomQuote();
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
  Future<void> _handleTapToRefresh() async {
    // Fade out current quote
    setState(() {
      _opacity = 0.0;
    });

    // Wait for fade out to complete
    await Future.delayed(const Duration(milliseconds: 300));

    // Load new quote
    await _loadRandomQuote();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Full-screen dark background
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: GestureDetector(
          // Tap anywhere to refresh quote
          onTap: _isLoading ? null : _handleTapToRefresh,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              // Subtle gradient background for depth
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface,
                  colorScheme.surface.withOpacity(0.8),
                ],
              ),
            ),
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
              onPressed: _loadRandomQuote,
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
