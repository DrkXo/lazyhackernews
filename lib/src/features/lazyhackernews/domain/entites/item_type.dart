part of '../../data/models/models.dart';

enum ItemType {
  @JsonValue('job')
  job,
  @JsonValue('story')
  story,
  @JsonValue('comment')
  comment,
  @JsonValue('poll')
  poll,
  @JsonValue('pollopt')
  pollopt,
}
