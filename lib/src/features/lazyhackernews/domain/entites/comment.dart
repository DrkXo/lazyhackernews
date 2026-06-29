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

    // Extract and format links from <a> tags first
    var result = text.replaceAllMapped(
      RegExp(r'<a\s+href="([^"]+)"[^>]*>(.*?)</a>', caseSensitive: false),
      (m) => '${m[2]} [${m[1]}]',
    );

    // Strip remaining HTML tags
    result = result.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode HTML entities
    result = result
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#39;', "'")
        .replaceAll('&quot;', '"')
        .trim();

    return result;
  }

  String get oneLineText {
    final dt = displayText;
    final line = dt.replaceAll(RegExp(r'\s+'), ' ');
    return line.length > 120 ? '${line.substring(0, 120)}...' : line;
  }
}
