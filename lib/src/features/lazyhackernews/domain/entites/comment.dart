part of '../../data/models/models.dart';

class Comment {
  final int id;
  final String author;
  final String text;
  final int time;
  final int points;
  final int depth;
  final bool isDeleted;
  final bool isDead;

  const Comment({
    required this.id,
    this.author = '',
    this.text = '',
    this.time = 0,
    this.points = 0,
    this.depth = 0,
    this.isDeleted = false,
    this.isDead = false,
  });

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
