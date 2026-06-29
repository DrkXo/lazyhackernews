part of '../../data/models/models.dart';

@freezed
abstract class Item with _$Item {
  const factory Item({
    required int id,
    @Default(false) bool deleted,
    ItemType? type,
    String? by,
    int? time,
    String? text,
    @Default(false) bool dead,
    int? parent,
    int? poll,
    @Default([]) List<int> kids,
    String? url,
    int? score,
    String? title,
    @Default([]) List<int> parts,
    int? descendants,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
