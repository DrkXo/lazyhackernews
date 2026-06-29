part of '../../data/models/models.dart';

class Story {
  final int id;
  final String title;
  final int points;
  final String author;
  final int commentCount;
  final String? url;
  final String? domain;

  const Story({
    required this.id,
    required this.title,
    this.points = 0,
    this.author = '',
    this.commentCount = 0,
    this.url,
    this.domain,
  });
}
