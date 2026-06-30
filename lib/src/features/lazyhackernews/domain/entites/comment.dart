part of '../../data/models/models.dart';

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required int id,
    @Default('') String author,
    @Default('') String text,
    @Default(0) int time,
    @Default(0) int points,
    @Default(0) int depth,
    @Default(false) bool isDeleted,
    @Default(false) bool isDead,
  }) = _Comment;

  const Comment._();

  String get displayText {
    if (isDeleted || isDead) return '[removed]';

    var result = text;

    // Decode HTML entities first so URLs are clean
    result = result
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#39;', "'")
        .replaceAll('&#x2F;', '/')
        .replaceAll('&#47;', '/')
        .replaceAll('&quot;', '"');

    // Format links: avoid redundancy when text == URL
    result = result.replaceAllMapped(
      RegExp(r'<a\s+href="([^"]+)"[^>]*>(.*?)</a>', caseSensitive: false),
      (m) {
        final url = m[1]!;
        final linkText = m[2]!.trim();
        if (linkText.isEmpty || linkText == url) return url;
        return '$linkText ($url)';
      },
    );

    // Convert block/inline HTML to newlines for readability
    result = result.replaceAll(RegExp(r'</?p>', caseSensitive: false), '\n');
    result = result.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    result = result.replaceAll(RegExp(r'</?pre>', caseSensitive: false), '\n');
    result = result.replaceAll(RegExp(r'</?code>', caseSensitive: false), '\n');

    // Strip remaining HTML tags
    result = result.replaceAll(RegExp(r'<[^>]*>'), '');

    // Collapse multiple newlines
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return result.trim();
  }

  String get oneLineText {
    final dt = displayText;
    final line = dt.replaceAll(RegExp(r'\s+'), ' ');
    return line.length > 120 ? '${line.substring(0, 120)}...' : line;
  }
}
