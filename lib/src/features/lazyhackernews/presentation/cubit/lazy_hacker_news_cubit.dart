import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import '../../data/models/models.dart';

part 'lazy_hacker_news_cubit.freezed.dart';
part 'lazy_hacker_news_state.dart';

class LazyHackerNewsCubit extends Cubit<LazyHackerNewsState> {
  LazyHackerNewsCubit() : super(const LazyHackerNewsState()) {
    _loadSampleStories();
  }

  void selectNext() {
    final stories = state.stories;
    if (stories.isEmpty) return;
    final next = (state.selectedIndex + 1).clamp(0, stories.length - 1);
    emit(state.copyWith(selectedIndex: next));
  }

  void selectPrevious() {
    final stories = state.stories;
    if (stories.isEmpty) return;
    final prev = (state.selectedIndex - 1).clamp(0, stories.length - 1);
    emit(state.copyWith(selectedIndex: prev));
  }

  void refresh() {
    emit(state.copyWith(isLoading: true));
    _loadSampleStories();
  }

  void setCategory(Category category) {
    emit(
      state.copyWith(
        category: category,
        selectedIndex: 0,
        stories: [],
        isLoading: true,
      ),
    );
    _loadSampleStories();
  }

  void _loadSampleStories() {
    Timer(const Duration(milliseconds: 500), () {
      emit(
        state.copyWith(
          stories: _sampleStories(state.category),
          isLoading: false,
        ),
      );
    });
  }

  List<Story> _sampleStories(Category category) {
    switch (category) {
      case Category.top:
        return [
          const Story(
            id: 1,
            title: 'Ask HN: What are you working on this month?',
            points: 342,
            author: 'sahin',
            commentCount: 89,
          ),
          const Story(
            id: 2,
            title: 'Show HN: I built a terminal UI for Hacker News',
            points: 256,
            author: 'drkxo',
            commentCount: 45,
            url: 'https://github.com/drkxo/lazyhackernews',
          ),
          const Story(
            id: 3,
            title: 'The Era of Senior Engineers',
            points: 189,
            author: 'joshwa',
            commentCount: 234,
            url: 'https://example.com/senior-engineers',
          ),
          const Story(
            id: 4,
            title: 'SQLite is not a toy database',
            points: 567,
            author: 'peterk',
            commentCount: 120,
          ),
          const Story(
            id: 5,
            title: 'Linux kernel 6.12 released with new scheduler',
            points: 145,
            author: 'mrybczyn',
            commentCount: 67,
          ),
          const Story(
            id: 6,
            title: 'How to write a disassembler',
            points: 98,
            author: 'pkrumins',
            commentCount: 23,
          ),
          const Story(
            id: 7,
            title: 'The "do file" idiom',
            points: 76,
            author: 'ingve',
            commentCount: 34,
            url: 'https://example.com/do-file',
          ),
          const Story(
            id: 8,
            title: 'Building a second brain in plain text files',
            points: 234,
            author: 'shadownlp',
            commentCount: 156,
          ),
          const Story(
            id: 9,
            title: 'Rust in the Linux kernel (April 2026)',
            points: 312,
            author: 'nathanj',
            commentCount: 189,
          ),
          const Story(
            id: 10,
            title: 'Why I left Google after 10 years',
            points: 423,
            author: 'exgoogler',
            commentCount: 345,
          ),
        ];
      case Category.new_:
        return [
          const Story(
            id: 11,
            title: 'A new vector search algorithm',
            points: 45,
            author: 'newuser',
            commentCount: 12,
          ),
          const Story(
            id: 12,
            title: 'My experience with OCaml in production',
            points: 67,
            author: 'ocaml_fan',
            commentCount: 34,
          ),
        ];
      case Category.ask:
        return [
          const Story(
            id: 13,
            title: 'Ask HN: Best code review practices?',
            points: 89,
            author: 'junior_dev',
            commentCount: 56,
          ),
          const Story(
            id: 14,
            title: 'Ask HN: How do you stay motivated?',
            points: 156,
            author: 'burnout_dev',
            commentCount: 123,
          ),
        ];
      case Category.show:
        return [
          const Story(
            id: 15,
            title: 'Show HN: A new note-taking app for developers',
            points: 178,
            author: 'maker1',
            commentCount: 45,
          ),
        ];
      case Category.jobs:
        return [
          const Story(
            id: 16,
            title: 'Stripe is hiring engineers worldwide',
            points: 0,
            author: 'stripe_jobs',
            commentCount: 89,
          ),
        ];
    }
  }
}
