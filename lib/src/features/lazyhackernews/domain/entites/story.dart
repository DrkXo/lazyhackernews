part of '../../data/models/models.dart';

@freezed
abstract class Story with _$Story {
  const factory Story({
    required int id,
    required String title,
    @Default(0) int points,
    @Default('') String author,
    @Default(0) int commentCount,
    String? url,
    String? domain,
  }) = _Story;
}
