// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Item _$ItemFromJson(Map<String, dynamic> json) => _Item(
  id: (json['id'] as num).toInt(),
  deleted: json['deleted'] as bool? ?? false,
  type: $enumDecodeNullable(_$ItemTypeEnumMap, json['type']),
  by: json['by'] as String?,
  time: (json['time'] as num?)?.toInt(),
  text: json['text'] as String?,
  dead: json['dead'] as bool? ?? false,
  parent: (json['parent'] as num?)?.toInt(),
  poll: (json['poll'] as num?)?.toInt(),
  kids:
      (json['kids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  url: json['url'] as String?,
  score: (json['score'] as num?)?.toInt(),
  title: json['title'] as String?,
  parts:
      (json['parts'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  descendants: (json['descendants'] as num?)?.toInt(),
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'id': instance.id,
  'deleted': instance.deleted,
  'type': _$ItemTypeEnumMap[instance.type],
  'by': instance.by,
  'time': instance.time,
  'text': instance.text,
  'dead': instance.dead,
  'parent': instance.parent,
  'poll': instance.poll,
  'kids': instance.kids,
  'url': instance.url,
  'score': instance.score,
  'title': instance.title,
  'parts': instance.parts,
  'descendants': instance.descendants,
};

const _$ItemTypeEnumMap = {
  ItemType.job: 'job',
  ItemType.story: 'story',
  ItemType.comment: 'comment',
  ItemType.poll: 'poll',
  ItemType.pollopt: 'pollopt',
};

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  created: (json['created'] as num?)?.toInt(),
  karma: (json['karma'] as num?)?.toInt(),
  about: json['about'] as String?,
  submitted:
      (json['submitted'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'created': instance.created,
  'karma': instance.karma,
  'about': instance.about,
  'submitted': instance.submitted,
};
