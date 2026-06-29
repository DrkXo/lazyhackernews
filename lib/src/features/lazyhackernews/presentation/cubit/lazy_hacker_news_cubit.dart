import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/fetch_comments_usecase.dart';
import '../../domain/usecases/fetch_stories_usecase.dart';

part 'lazy_hacker_news_cubit.freezed.dart';
part 'lazy_hacker_news_state.dart';

class LazyHackerNewsCubit extends Cubit<LazyHackerNewsState> {
  final FetchStoriesUseCase _fetchStories;
  final FetchCommentsUseCase _fetchComments;

  LazyHackerNewsCubit({
    required this._fetchStories,
    required this._fetchComments,
  }) : super(const LazyHackerNewsState()) {
    _loadStories();
  }

  void selectNext() {
    final stories = state.stories;
    if (stories.isEmpty) return;
    final next = (state.selectedIndex + 1).clamp(0, stories.length - 1);
    emit(state.copyWith(selectedIndex: next));
    if (next != state.selectedIndex) _loadComments();
  }

  void selectAt(int index) {
    final stories = state.stories;
    if (stories.isEmpty) return;
    emit(state.copyWith(selectedIndex: index.clamp(0, stories.length - 1)));
    _loadComments();
  }

  void selectPrevious() {
    final stories = state.stories;
    if (stories.isEmpty) return;
    final prev = (state.selectedIndex - 1).clamp(0, stories.length - 1);
    emit(state.copyWith(selectedIndex: prev));
    if (prev != state.selectedIndex) _loadComments();
  }

  void refresh() {
    emit(state.copyWith(isLoading: true, error: null, comments: []));
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
        comments: [],
      ),
    );
    _loadStories();
  }

  Future<void> _loadStories() async {
    final result = await _fetchStories(state.category);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, error: failure.message),
      ),
      (stories) {
        emit(
          state.copyWith(stories: stories, isLoading: false, error: null),
        );
        if (stories.isNotEmpty) _loadComments();
      },
    );
  }

  Future<void> _loadComments() async {
    final stories = state.stories;
    if (stories.isEmpty || state.selectedIndex >= stories.length) return;
    emit(state.copyWith(isLoadingComments: true));
    final result = await _fetchComments(
      stories[state.selectedIndex].id,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingComments: false, error: failure.message),
      ),
      (comments) => emit(
        state.copyWith(comments: comments, isLoadingComments: false),
      ),
    );
  }
}
