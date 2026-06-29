import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/fetch_stories_usecase.dart';

part 'lazy_hacker_news_cubit.freezed.dart';
part 'lazy_hacker_news_state.dart';

class LazyHackerNewsCubit extends Cubit<LazyHackerNewsState> {
  final FetchStoriesUseCase _fetchStories;

  LazyHackerNewsCubit({required this._fetchStories})
      : super(const LazyHackerNewsState(isLoading: true)) {
    _loadStories();
  }

  void selectNext() {
    final stories = state.stories;
    if (stories.isEmpty) return;
    final next = (state.selectedIndex + 1).clamp(0, stories.length - 1);
    emit(state.copyWith(selectedIndex: next));
  }

  void selectAt(int index) {
    final stories = state.stories;
    if (stories.isEmpty) return;
    emit(state.copyWith(selectedIndex: index.clamp(0, stories.length - 1)));
  }

  void selectPrevious() {
    final stories = state.stories;
    if (stories.isEmpty) return;
    final prev = (state.selectedIndex - 1).clamp(0, stories.length - 1);
    emit(state.copyWith(selectedIndex: prev));
  }

  void refresh() {
    emit(state.copyWith(isLoading: true, error: null));
    _loadStories();
  }

  void setCategory(FeedType category) {
    emit(
      state.copyWith(
        category: category,
        selectedIndex: 0,
        stories: [],
        isLoading: true,
        error: null,
      ),
    );
    _loadStories();
  }

  void loadMore() {
    if (state.isLoadingMore || !state.hasMore) return;
    _loadBatch(state.stories.length);
  }

  Future<void> _loadBatch(int offset) async {
    emit(state.copyWith(isLoadingMore: true));
    final result = await _fetchStories(state.category, offset: offset, limit: 15);
    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (stories) => emit(
        state.copyWith(
          stories: [...state.stories, ...stories],
          isLoadingMore: false,
          hasMore: stories.length >= 15,
        ),
      ),
    );
  }

  Future<void> _loadStories() async {
    final result = await _fetchStories(state.category);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, error: failure.message),
      ),
      (stories) => emit(
        state.copyWith(
          stories: stories,
          isLoading: false,
          error: null,
          hasMore: stories.length >= 15,
        ),
      ),
    );
  }
}
