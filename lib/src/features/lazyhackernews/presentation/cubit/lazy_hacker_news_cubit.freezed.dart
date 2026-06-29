// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lazy_hacker_news_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LazyHackerNewsState {

 List<Story> get stories; int get selectedIndex; Category get category; bool get isLoading; String? get error;
/// Create a copy of LazyHackerNewsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LazyHackerNewsStateCopyWith<LazyHackerNewsState> get copyWith => _$LazyHackerNewsStateCopyWithImpl<LazyHackerNewsState>(this as LazyHackerNewsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LazyHackerNewsState&&const DeepCollectionEquality().equals(other.stories, stories)&&(identical(other.selectedIndex, selectedIndex) || other.selectedIndex == selectedIndex)&&const DeepCollectionEquality().equals(other.category, category)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(stories),selectedIndex,const DeepCollectionEquality().hash(category),isLoading,error);

@override
String toString() {
  return 'LazyHackerNewsState(stories: $stories, selectedIndex: $selectedIndex, category: $category, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $LazyHackerNewsStateCopyWith<$Res>  {
  factory $LazyHackerNewsStateCopyWith(LazyHackerNewsState value, $Res Function(LazyHackerNewsState) _then) = _$LazyHackerNewsStateCopyWithImpl;
@useResult
$Res call({
 List<Story> stories, int selectedIndex, Category category, bool isLoading, String? error
});




}
/// @nodoc
class _$LazyHackerNewsStateCopyWithImpl<$Res>
    implements $LazyHackerNewsStateCopyWith<$Res> {
  _$LazyHackerNewsStateCopyWithImpl(this._self, this._then);

  final LazyHackerNewsState _self;
  final $Res Function(LazyHackerNewsState) _then;

/// Create a copy of LazyHackerNewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stories = null,Object? selectedIndex = null,Object? category = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(LazyHackerNewsState(
stories: null == stories ? _self.stories : stories // ignore: cast_nullable_to_non_nullable
as List<Story>,selectedIndex: null == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LazyHackerNewsState].
extension LazyHackerNewsStatePatterns on LazyHackerNewsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LazyHackerNewsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LazyHackerNewsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LazyHackerNewsState value)  $default,){
final _that = this;
switch (_that) {
case _LazyHackerNewsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LazyHackerNewsState value)?  $default,){
final _that = this;
switch (_that) {
case _LazyHackerNewsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Story> stories,  int selectedIndex,  Category category,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LazyHackerNewsState() when $default != null:
return $default(_that.stories,_that.selectedIndex,_that.category,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Story> stories,  int selectedIndex,  Category category,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _LazyHackerNewsState():
return $default(_that.stories,_that.selectedIndex,_that.category,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Story> stories,  int selectedIndex,  Category category,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _LazyHackerNewsState() when $default != null:
return $default(_that.stories,_that.selectedIndex,_that.category,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _LazyHackerNewsState implements LazyHackerNewsState {
  const _LazyHackerNewsState({ List<Story> stories = const [], this.selectedIndex = 0, this.category = Category.top, this.isLoading = false, this.error}): _stories = stories;
  

 final  List<Story> _stories;
@override@JsonKey() List<Story> get stories {
  if (_stories is EqualUnmodifiableListView) return _stories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stories);
}

@override@JsonKey() final  int selectedIndex;
@override@JsonKey() final  Category category;
@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of LazyHackerNewsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LazyHackerNewsStateCopyWith<_LazyHackerNewsState> get copyWith => __$LazyHackerNewsStateCopyWithImpl<_LazyHackerNewsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LazyHackerNewsState&&const DeepCollectionEquality().equals(other._stories, _stories)&&(identical(other.selectedIndex, selectedIndex) || other.selectedIndex == selectedIndex)&&const DeepCollectionEquality().equals(other.category, category)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stories),selectedIndex,const DeepCollectionEquality().hash(category),isLoading,error);

@override
String toString() {
  return 'LazyHackerNewsState(stories: $stories, selectedIndex: $selectedIndex, category: $category, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$LazyHackerNewsStateCopyWith<$Res> implements $LazyHackerNewsStateCopyWith<$Res> {
  factory _$LazyHackerNewsStateCopyWith(_LazyHackerNewsState value, $Res Function(_LazyHackerNewsState) _then) = __$LazyHackerNewsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Story> stories, int selectedIndex, Category category, bool isLoading, String? error
});




}
/// @nodoc
class __$LazyHackerNewsStateCopyWithImpl<$Res>
    implements _$LazyHackerNewsStateCopyWith<$Res> {
  __$LazyHackerNewsStateCopyWithImpl(this._self, this._then);

  final _LazyHackerNewsState _self;
  final $Res Function(_LazyHackerNewsState) _then;

/// Create a copy of LazyHackerNewsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stories = null,Object? selectedIndex = null,Object? category = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_LazyHackerNewsState(
stories: null == stories ? _self._stories : stories // ignore: cast_nullable_to_non_nullable
as List<Story>,selectedIndex: null == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
