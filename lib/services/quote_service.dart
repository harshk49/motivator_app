import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/quote.dart';

/// Service class responsible for loading and managing motivational quotes
/// Handles loading quotes from assets once at startup and providing smart quote selection
class QuoteService {
  static const String _quotesAssetPath = 'assets/quotes.json';

  /// Cached list of all quotes loaded from the JSON asset
  List<Quote>? _quotes;

  /// Random number generator for selecting random quotes
  final Random _random = Random();

  /// List to track recently shown quote indices to avoid immediate repetition
  /// Keeps track of the last 25% of total quotes to ensure variety
  final List<int> _recentQuoteIndices = [];

  /// Flag to track if quotes have been loaded at startup
  bool _isInitialized = false;

  /// Maximum number of recent quotes to track (25% of total quotes, min 5, max 25)
  int get _maxRecentQuotes {
    if (_quotes == null || _quotes!.isEmpty) return 5;
    final int quarterSize = (_quotes!.length * 0.25).round();
    return quarterSize.clamp(5, 25);
  }

  /// Initializes the service by loading all quotes once at startup
  /// This should be called during app initialization
  Future<void> initialize() async {
    if (_isInitialized) return; // Already initialized

    try {
      await loadQuotes();
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  /// Loads all quotes from the assets/quotes.json file into memory
  /// This is called once during app initialization
  /// Returns a list of Quote objects
  /// Throws an exception if the file cannot be loaded or parsed
  Future<List<Quote>> loadQuotes() async {
    try {
      // Load the JSON string from assets
      final String jsonString = await rootBundle.loadString(_quotesAssetPath);

      // Parse the JSON string into a list of dynamic objects
      final List<dynamic> jsonList = json.decode(jsonString);

      // Convert each JSON object to a Quote instance
      final List<Quote> quotes = jsonList
          .map((json) => Quote.fromJson(json as Map<String, dynamic>))
          .toList();

      // Cache the quotes for future use
      _quotes = quotes;

      return quotes;
    } catch (e) {
      throw Exception('Failed to load quotes: $e');
    }
  }

  /// Returns a random quote from the pre-loaded in-memory list
  /// Uses smart selection to avoid repeating recently shown quotes
  /// Returns null if quotes haven't been loaded or are unavailable
  Quote? getRandomQuote() {
    // Ensure quotes are loaded
    if (!_isInitialized || _quotes == null || _quotes!.isEmpty) {
      return null;
    }

    final int totalQuotes = _quotes!.length;
    int selectedIndex;

    // If we have shown fewer quotes than available, try to avoid recent ones
    if (_recentQuoteIndices.length < totalQuotes) {
      int attempts = 0;
      const int maxAttempts = 10; // Prevent infinite loops

      do {
        selectedIndex = _random.nextInt(totalQuotes);
        attempts++;
      } while (_recentQuoteIndices.contains(selectedIndex) &&
          attempts < maxAttempts);
    } else {
      // If we've shown all quotes recently, just pick any random one
      selectedIndex = _random.nextInt(totalQuotes);
    }

    // Add to recent quotes tracking
    _recentQuoteIndices.add(selectedIndex);

    // Maintain the recent quotes list size
    if (_recentQuoteIndices.length > _maxRecentQuotes) {
      _recentQuoteIndices.removeAt(0); // Remove the oldest entry
    }

    return _quotes![selectedIndex];
  }

  /// Checks if the service has been initialized and quotes are loaded
  bool get isInitialized => _isInitialized;

  /// Returns the total number of available quotes
  /// Returns 0 if quotes haven't been loaded yet
  int get quoteCount => _quotes?.length ?? 0;

  /// Checks if quotes have been loaded
  bool get hasQuotes =>
      _isInitialized && _quotes != null && _quotes!.isNotEmpty;

  /// Clears the cached quotes and recent selection history
  /// (useful for testing or refresh scenarios)
  void clearCache() {
    _quotes = null;
    _recentQuoteIndices.clear();
    _isInitialized = false;
  }

  /// Clears only the recent quotes tracking, allowing for fresh variety
  /// without reloading the entire quote database
  void clearRecentHistory() {
    _recentQuoteIndices.clear();
  }

  /// Returns the number of unique quotes remaining before repetition
  /// (quotes not in recent history)
  int get remainingUniqueQuotes {
    if (_quotes == null || _quotes!.isEmpty) return 0;
    return _quotes!.length - _recentQuoteIndices.length;
  }
}
