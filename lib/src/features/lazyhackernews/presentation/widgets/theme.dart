import 'package:nocterm/nocterm.dart';

class AppTheme {
  AppTheme._();

  static const Color border = Colors.gray;
  static const Color headerBg = Color(0x260000ff);
  static const Color title = Colors.green;
  static const Color accent = Colors.blue;
  static const Color muted = Colors.gray;
  static const Color error = Colors.red;
  static const Color author = Colors.cyan;
  static const Color selection = Color(0x4d0000ff);
  static const Color tabActive = Colors.green;
  static const Color tabInactive = Colors.gray;

  static TextStyle bold = const TextStyle(fontWeight: FontWeight.bold);
  static TextStyle sectionTitle = const TextStyle(
    color: accent,
    fontWeight: FontWeight.bold,
  );
  static TextStyle mutedText = const TextStyle(color: muted);
  static TextStyle errorText = const TextStyle(color: error);
  static TextStyle linkText = const TextStyle(
    color: accent,
    decoration: TextDecoration.underline,
  );

  static Color pointsColor(int points) {
    if (points > 100) return Colors.green;
    if (points > 50) return Colors.yellow;
    return Colors.gray;
  }
}
