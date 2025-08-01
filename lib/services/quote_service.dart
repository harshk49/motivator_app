import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/quote.dart';

/// Service class responsible for loading and managing motivational quotes
/// Handles loading quotes from assets and providing random quote selection
class QuoteService {
  static const String _quotesAssetPath = 'assets/quotes.json';

  /// Cached list of all quotes loaded from the JSON asset
  List<Quote>? _quotes;

  /// Random number generator for selecting random quotes
  final Random _random = Random();

  /// Loads all quotes from the assets/quotes.json file
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

  /// Returns a random quote from the loaded quotes
  /// Automatically loads quotes if they haven't been loaded yet
  /// Returns null if no quotes are available
  Future<Quote?> getRandomQuote() async {
    // Load quotes if not already cached
    if (_quotes == null || _quotes!.isEmpty) {
      await loadQuotes();
    }

    // Return null if still no quotes available
    if (_quotes == null || _quotes!.isEmpty) {
      return null;
    }

    // Return a random quote
    final int randomIndex = _random.nextInt(_quotes!.length);
    return _quotes![randomIndex];
  }

  /// Returns the total number of available quotes
  /// Returns 0 if quotes haven't been loaded yet
  int get quoteCount => _quotes?.length ?? 0;

  /// Checks if quotes have been loaded
  bool get hasQuotes => _quotes != null && _quotes!.isNotEmpty;

  /// Clears the cached quotes (useful for testing or refresh scenarios)
  void clearCache() {
    _quotes = null;
  }
}
