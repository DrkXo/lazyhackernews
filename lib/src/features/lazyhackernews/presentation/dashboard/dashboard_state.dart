part of 'dashboard_cubit.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default([]) List<Story> stories,
    @Default(0) int selectedIndex,
    @Default(FeedType.top) FeedType category,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    String? error,
  }) = _DashboardState;
}
