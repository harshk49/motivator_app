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

    test('should initialize and load quotes successfully', () async {
      // Test initialization
      await quoteService.initialize();

      expect(quoteService.isInitialized, isTrue);
      expect(quoteService.hasQuotes, isTrue);
      expect(quoteService.quoteCount,
          greaterThan(50)); // We should have 100+ quotes
    });

    test('should return random quotes immediately after initialization',
        () async {
      // Initialize first
      await quoteService.initialize();

      final quote1 = quoteService.getRandomQuote();
      final quote2 = quoteService.getRandomQuote();

      expect(quote1, isNotNull);
      expect(quote2, isNotNull);
      expect(quote1!.text, isNotEmpty);
      expect(quote2!.text, isNotEmpty);
      expect(quote1.author, isNotEmpty);
      expect(quote2.author, isNotEmpty);
    });

    test('should return null when not initialized', () {
      // Don't initialize
      final quote = quoteService.getRandomQuote();
      expect(quote, isNull);
    });

    test('should track quote variety correctly', () async {
      // Initialize first
      await quoteService.initialize();

      // Get several quotes and verify variety tracking
      for (int i = 0; i < 10; i++) {
        final quote = quoteService.getRandomQuote();
        expect(quote, isNotNull);
      }

      // Check that remaining unique quotes decreases
      expect(quoteService.remainingUniqueQuotes,
          lessThan(quoteService.quoteCount));
    });

    test('should clear cache properly', () async {
      // Initialize first
      await quoteService.initialize();
      expect(quoteService.hasQuotes, isTrue);

      // Clear cache
      quoteService.clearCache();
      expect(quoteService.hasQuotes, isFalse);
      expect(quoteService.isInitialized, isFalse);
      expect(quoteService.quoteCount, equals(0));
    });
  });
}
