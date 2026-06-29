part of '../../data/models/models.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    int? created,
    int? karma,
    String? about,
    @Default([]) List<int> submitted,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
