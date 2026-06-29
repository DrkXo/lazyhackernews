// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Item {

 int get id; bool get deleted; ItemType? get type; String? get by; int? get time; String? get text; bool get dead; int? get parent; int? get poll; List<int> get kids; String? get url; int? get score; String? get title; List<int> get parts; int? get descendants;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.id, id) || other.id == id)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&(identical(other.type, type) || other.type == type)&&(identical(other.by, by) || other.by == by)&&(identical(other.time, time) || other.time == time)&&(identical(other.text, text) || other.text == text)&&(identical(other.dead, dead) || other.dead == dead)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.poll, poll) || other.poll == poll)&&const DeepCollectionEquality().equals(other.kids, kids)&&(identical(other.url, url) || other.url == url)&&(identical(other.score, score) || other.score == score)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.parts, parts)&&(identical(other.descendants, descendants) || other.descendants == descendants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deleted,type,by,time,text,dead,parent,poll,const DeepCollectionEquality().hash(kids),url,score,title,const DeepCollectionEquality().hash(parts),descendants);

@override
String toString() {
  return 'Item(id: $id, deleted: $deleted, type: $type, by: $by, time: $time, text: $text, dead: $dead, parent: $parent, poll: $poll, kids: $kids, url: $url, score: $score, title: $title, parts: $parts, descendants: $descendants)';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 int id, bool deleted, ItemType? type, String? by, int? time, String? text, bool dead, int? parent, int? poll, List<int> kids, String? url, int? score, String? title, List<int> parts, int? descendants
});




}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deleted = null,Object? type = freezed,Object? by = freezed,Object? time = freezed,Object? text = freezed,Object? dead = null,Object? parent = freezed,Object? poll = freezed,Object? kids = null,Object? url = freezed,Object? score = freezed,Object? title = freezed,Object? parts = null,Object? descendants = freezed,}) {
  return _then(Item(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ItemType?,by: freezed == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,dead: null == dead ? _self.dead : dead // ignore: cast_nullable_to_non_nullable
as bool,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as int?,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as int?,kids: null == kids ? _self.kids : kids // ignore: cast_nullable_to_non_nullable
as List<int>,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,descendants: freezed == descendants ? _self.descendants : descendants // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Item value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Item value)  $default,){
final _that = this;
switch (_that) {
case _Item():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Item value)?  $default,){
final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  bool deleted,  ItemType? type,  String? by,  int? time,  String? text,  bool dead,  int? parent,  int? poll,  List<int> kids,  String? url,  int? score,  String? title,  List<int> parts,  int? descendants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.deleted,_that.type,_that.by,_that.time,_that.text,_that.dead,_that.parent,_that.poll,_that.kids,_that.url,_that.score,_that.title,_that.parts,_that.descendants);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  bool deleted,  ItemType? type,  String? by,  int? time,  String? text,  bool dead,  int? parent,  int? poll,  List<int> kids,  String? url,  int? score,  String? title,  List<int> parts,  int? descendants)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.id,_that.deleted,_that.type,_that.by,_that.time,_that.text,_that.dead,_that.parent,_that.poll,_that.kids,_that.url,_that.score,_that.title,_that.parts,_that.descendants);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  bool deleted,  ItemType? type,  String? by,  int? time,  String? text,  bool dead,  int? parent,  int? poll,  List<int> kids,  String? url,  int? score,  String? title,  List<int> parts,  int? descendants)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.deleted,_that.type,_that.by,_that.time,_that.text,_that.dead,_that.parent,_that.poll,_that.kids,_that.url,_that.score,_that.title,_that.parts,_that.descendants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Item implements Item {
  const _Item({required this.id, this.deleted = false, this.type, this.by, this.time, this.text, this.dead = false, this.parent, this.poll,  List<int> kids = const [], this.url, this.score, this.title,  List<int> parts = const [], this.descendants}): _kids = kids,_parts = parts;
  factory _Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

@override final  int id;
@override@JsonKey() final  bool deleted;
@override final  ItemType? type;
@override final  String? by;
@override final  int? time;
@override final  String? text;
@override@JsonKey() final  bool dead;
@override final  int? parent;
@override final  int? poll;
 final  List<int> _kids;
@override@JsonKey() List<int> get kids {
  if (_kids is EqualUnmodifiableListView) return _kids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kids);
}

@override final  String? url;
@override final  int? score;
@override final  String? title;
 final  List<int> _parts;
@override@JsonKey() List<int> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

@override final  int? descendants;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.id, id) || other.id == id)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&(identical(other.type, type) || other.type == type)&&(identical(other.by, by) || other.by == by)&&(identical(other.time, time) || other.time == time)&&(identical(other.text, text) || other.text == text)&&(identical(other.dead, dead) || other.dead == dead)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.poll, poll) || other.poll == poll)&&const DeepCollectionEquality().equals(other._kids, _kids)&&(identical(other.url, url) || other.url == url)&&(identical(other.score, score) || other.score == score)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._parts, _parts)&&(identical(other.descendants, descendants) || other.descendants == descendants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deleted,type,by,time,text,dead,parent,poll,const DeepCollectionEquality().hash(_kids),url,score,title,const DeepCollectionEquality().hash(_parts),descendants);

@override
String toString() {
  return 'Item(id: $id, deleted: $deleted, type: $type, by: $by, time: $time, text: $text, dead: $dead, parent: $parent, poll: $poll, kids: $kids, url: $url, score: $score, title: $title, parts: $parts, descendants: $descendants)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 int id, bool deleted, ItemType? type, String? by, int? time, String? text, bool dead, int? parent, int? poll, List<int> kids, String? url, int? score, String? title, List<int> parts, int? descendants
});




}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deleted = null,Object? type = freezed,Object? by = freezed,Object? time = freezed,Object? text = freezed,Object? dead = null,Object? parent = freezed,Object? poll = freezed,Object? kids = null,Object? url = freezed,Object? score = freezed,Object? title = freezed,Object? parts = null,Object? descendants = freezed,}) {
  return _then(_Item(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ItemType?,by: freezed == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,dead: null == dead ? _self.dead : dead // ignore: cast_nullable_to_non_nullable
as bool,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as int?,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as int?,kids: null == kids ? _self._kids : kids // ignore: cast_nullable_to_non_nullable
as List<int>,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,descendants: freezed == descendants ? _self.descendants : descendants // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$User {

 String get id; int? get created; int? get karma; String? get about; List<int> get submitted;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.created, created) || other.created == created)&&(identical(other.karma, karma) || other.karma == karma)&&(identical(other.about, about) || other.about == about)&&const DeepCollectionEquality().equals(other.submitted, submitted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,created,karma,about,const DeepCollectionEquality().hash(submitted));

@override
String toString() {
  return 'User(id: $id, created: $created, karma: $karma, about: $about, submitted: $submitted)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, int? created, int? karma, String? about, List<int> submitted
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? created = freezed,Object? karma = freezed,Object? about = freezed,Object? submitted = null,}) {
  return _then(User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int?,karma: freezed == karma ? _self.karma : karma // ignore: cast_nullable_to_non_nullable
as int?,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int? created,  int? karma,  String? about,  List<int> submitted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.created,_that.karma,_that.about,_that.submitted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int? created,  int? karma,  String? about,  List<int> submitted)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.created,_that.karma,_that.about,_that.submitted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int? created,  int? karma,  String? about,  List<int> submitted)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.created,_that.karma,_that.about,_that.submitted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.id, this.created, this.karma, this.about,  List<int> submitted = const []}): _submitted = submitted;
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  int? created;
@override final  int? karma;
@override final  String? about;
 final  List<int> _submitted;
@override@JsonKey() List<int> get submitted {
  if (_submitted is EqualUnmodifiableListView) return _submitted;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_submitted);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.created, created) || other.created == created)&&(identical(other.karma, karma) || other.karma == karma)&&(identical(other.about, about) || other.about == about)&&const DeepCollectionEquality().equals(other._submitted, _submitted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,created,karma,about,const DeepCollectionEquality().hash(_submitted));

@override
String toString() {
  return 'User(id: $id, created: $created, karma: $karma, about: $about, submitted: $submitted)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, int? created, int? karma, String? about, List<int> submitted
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? created = freezed,Object? karma = freezed,Object? about = freezed,Object? submitted = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int?,karma: freezed == karma ? _self.karma : karma // ignore: cast_nullable_to_non_nullable
as int?,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,submitted: null == submitted ? _self._submitted : submitted // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
