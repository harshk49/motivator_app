/// Data model representing a motivational quote
/// Contains the quote text and its author
class Quote {
  /// The actual quote text
  final String text;

  /// The author of the quote
  final String author;

  /// Creates a new Quote instance
  const Quote({
    required this.text,
    required this.author,
  });

  /// Creates a Quote from a JSON map
  /// Used when parsing quotes from the assets/quotes.json file
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['text'] as String,
      author: json['author'] as String,
    );
  }

  /// Converts the Quote to a JSON map
  /// Useful for debugging or potential future features
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
    };
  }

  /// String representation of the quote for debugging
  @override
  String toString() => 'Quote(text: "$text", author: "$author")';

  /// Equality comparison based on text and author
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quote && other.text == text && other.author == author;
  }

  /// Hash code based on text and author
  @override
  int get hashCode => text.hashCode ^ author.hashCode;
}
