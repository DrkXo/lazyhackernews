part of 'lazy_hacker_news_cubit.dart';

@freezed
abstract class LazyHackerNewsState with _$LazyHackerNewsState {
  const factory LazyHackerNewsState({
    @Default([]) List<Story> stories,
    @Default(0) int selectedIndex,
    @Default(FeedType.top) FeedType category,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    String? error,
  }) = _LazyHackerNewsState;
}
