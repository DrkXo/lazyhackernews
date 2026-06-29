part of 'lazy_hacker_news_cubit.dart';

@freezed
abstract class LazyHackerNewsState with _$LazyHackerNewsState {
  const factory LazyHackerNewsState({
    @Default([]) List<Story> stories,
    @Default(0) int selectedIndex,
    @Default(Category.top) Category category,
    @Default(false) bool isLoading,
    String? error,
  }) = _LazyHackerNewsState;
}
