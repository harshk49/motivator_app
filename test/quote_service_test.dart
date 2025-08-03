import 'package:flutter_test/flutter_test.dart';
import 'package:motivator_app/services/quote_service.dart';

void main() {
  // Initialize Flutter bindings for asset loading in tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuoteService Tests', () {
    late QuoteService quoteService;

    setUp(() {
      quoteService = QuoteService();
    });

    test('should load quotes successfully', () async {
      // Test loading quotes
      final quotes = await quoteService.loadQuotes();

      expect(quotes, isNotEmpty);
      expect(quotes.length, greaterThan(50)); // We should have 100+ quotes

      // Verify quote structure
      final firstQuote = quotes.first;
      expect(firstQuote.text, isNotEmpty);
      expect(firstQuote.author, isNotEmpty);
    });

    test('should return random quotes', () async {
      final quote1 = await quoteService.getRandomQuote();
      final quote2 = await quoteService.getRandomQuote();

      expect(quote1, isNotNull);
      expect(quote2, isNotNull);
      expect(quote1!.text, isNotEmpty);
      expect(quote2!.text, isNotEmpty);
    });

    test('should track quote variety correctly', () async {
      // Load quotes first
      await quoteService.loadQuotes();

      // Get several quotes and verify variety tracking
      for (int i = 0; i < 10; i++) {
        final quote = await quoteService.getRandomQuote();
        expect(quote, isNotNull);
      }

      // Check that remaining unique quotes decreases
      expect(quoteService.remainingUniqueQuotes,
          lessThan(quoteService.quoteCount));
    });

    test('should clear cache properly', () {
      quoteService.clearCache();
      expect(quoteService.hasQuotes, isFalse);
      expect(quoteService.quoteCount, equals(0));
    });
  });
}
