import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:nocterm/nocterm.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import '../../../core/services/input_service.dart';
import '../../../core/services/mouse_service.dart';
import '../../../core/services/scroll_service.dart';
import '../data/models/models.dart';
import 'cubit/lazy_hacker_news_cubit.dart';

class LazyHackerNews extends StatefulComponent {
  const LazyHackerNews({super.key});

  @override
  State<LazyHackerNews> createState() => _LazyHackerNewsState();
}

class _LazyHackerNewsState extends State<LazyHackerNews> {
  late final LazyHackerNewsCubit _cubit;
  final _inputService = GetIt.I<InputService>();
  final _scrollService = GetIt.I<ScrollService>();
  final _mouseService = GetIt.I<MouseService>();
  int _prevSelectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LazyHackerNewsCubit>();

    _mouseService.onStoryTap = (index) {
      _cubit.selectAt(index);
    };

    _inputService.registerAll([
      KeyBinding(
        key: LogicalKey.escape,
        action: () => exit(0),
      ),
      KeyBinding(
        key: LogicalKey.keyQ,
        predicate: (e) => !e.isControlPressed,
        action: () => exit(0),
      ),
      KeyBinding(
        key: LogicalKey.keyQ,
        predicate: (e) => e.isControlPressed,
        action: () => exit(0),
      ),
      KeyBinding(
        key: LogicalKey.keyJ,
        action: () {
          _cubit.selectNext();
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.arrowDown,
        action: () {
          _cubit.selectNext();
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.keyK,
        action: () {
          _cubit.selectPrevious();
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.arrowUp,
        action: () {
          _cubit.selectPrevious();
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.keyR,
        action: () {
          _cubit.refresh();
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.digit1,
        action: () {
          _cubit.setCategory(FeedType.top);
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.digit2,
        action: () {
          _cubit.setCategory(FeedType.new_);
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.digit3,
        action: () {
          _cubit.setCategory(FeedType.ask);
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.digit4,
        action: () {
          _cubit.setCategory(FeedType.show);
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.digit5,
        action: () {
          _cubit.setCategory(FeedType.jobs);
          return true;
        },
      ),
    ]);
  }

  void _onStateChanged(LazyHackerNewsState state) {
    if (_prevSelectedIndex != state.selectedIndex) {
      _prevSelectedIndex = state.selectedIndex;
      _scrollToSelected();
    }
  }

  void _scrollToSelected() {
    _scrollService.scrollToIndex(_cubit.state.selectedIndex);
  }

  @override
  void dispose() {
    _scrollService.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyboardEvent event) {
    return _inputService.handle(event);
  }

  @override
  Component build(BuildContext context) {
    return Focusable(
      focused: true,
      onKeyEvent: _handleKeyEvent,
      child: BlocBuilder<LazyHackerNewsCubit, LazyHackerNewsState>(
        builder: (context, state) {
          _onStateChanged(state);
          return Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.gray),
            ),
            margin: const EdgeInsets.all(1),
            child: Column(
              children: [
                _buildHeader(state),
                const Divider(height: 1, color: Colors.gray),
                Expanded(
                  child: Row(
                    children: [
                      _buildStoryPanel(state),
                      const VerticalDivider(width: 1, color: Colors.gray),
                      _buildDetailPanel(state),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.gray),
                _buildStatusBar(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Component _buildHeader(LazyHackerNewsState state) {
    return Container(
      color: Colors.blue.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              Text(
                ' lazyhackernews ',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                _categoryLabel(state.category),
                style: const TextStyle(color: Colors.blue),
              ),
              const SizedBox(width: 2),
              const Text(
                'j/k:nav  q:quit',
                style: TextStyle(color: Colors.gray),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Component _buildStoryPanel(LazyHackerNewsState state) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: const SizedBox(
              height: 1,
              child: Text(
                ' Stories ',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildStoryList(state),
          ),
        ],
      ),
    );
  }

  Component _buildStoryList(LazyHackerNewsState state) {
    if (state.isLoading) {
      return const Center(
        child: Text('Loading...', style: TextStyle(color: Colors.gray)),
      );
    }

    if (state.stories.isEmpty) {
      return Center(
        child: Text(
          state.error ?? 'No stories. Press r to refresh.',
          style: TextStyle(
            color: state.error != null ? Colors.red : Colors.gray,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollService.controller,
      keyboardScrollable: false,
      itemCount: state.stories.length,
      itemBuilder: (context, index) {
        final story = state.stories[index];
        final isSelected = index == state.selectedIndex;
        return _buildStoryRow(story, index, isSelected);
      },
    );
  }

  Component _buildStoryRow(Story story, int index, bool isSelected) {
    final pointsColor = story.points > 100
        ? Colors.green
        : story.points > 50
        ? Colors.yellow
        : Colors.gray;

    final row = Container(
      color: isSelected ? Colors.blue.withOpacity(0.3) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              Text(
                isSelected ? ' \u25B6 ' : '   ',
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.gray,
                ),
              ),
              Expanded(
                child: Text(
                  '${index + 1}. ${story.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                ' ${story.points}pts',
                style: TextStyle(color: pointsColor),
              ),
            ],
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () => _mouseService.onStoryTapped(index),
      child: row,
    );
  }

  Component _buildDetailPanel(LazyHackerNewsState state) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: const SizedBox(
              height: 1,
              child: Text(
                ' Details ',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildDetailContent(state),
          ),
        ],
      ),
    );
  }

  Component _buildDetailContent(LazyHackerNewsState state) {
    if (state.stories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(1),
        child: Text(
          state.error ?? 'Select a story to view details',
          style: TextStyle(
            color: state.error != null ? Colors.red : Colors.gray,
          ),
        ),
      );
    }

    final story = state.stories[state.selectedIndex];

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 1),
          Text(
            'by ${story.author}',
            style: const TextStyle(color: Colors.cyan),
          ),
          Text(
            '${story.points} points  |  ${story.commentCount} comments',
            style: const TextStyle(color: Colors.gray),
          ),
          if (story.url != null) ...[
            const SizedBox(height: 1),
            Text(
              story.url!,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
          const SizedBox(height: 1),
          const Divider(height: 1, color: Colors.gray),
          const SizedBox(height: 1),
          const Text(
            'Comments',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          if (state.error != null)
            Text(
              state.error!,
              style: const TextStyle(color: Colors.red),
            )
          else
            const Text(
              '(comments not yet loaded)',
              style: TextStyle(color: Colors.gray),
            ),
        ],
      ),
    );
  }

  Component _buildStatusBar(LazyHackerNewsState state) {
    return Container(
      color: Colors.blue.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              _categoryTab('1', 'Top', state.category == FeedType.top),
              _categoryTab('2', 'New', state.category == FeedType.new_),
              _categoryTab('3', 'Ask', state.category == FeedType.ask),
              _categoryTab('4', 'Show', state.category == FeedType.show),
              _categoryTab('5', 'Jobs', state.category == FeedType.jobs),
              const Spacer(),
              const Text(
                'r:refresh  q:quit',
                style: TextStyle(color: Colors.gray),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Component _categoryTab(String key, String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text(
        '[$key]$label',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.gray,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  String _categoryLabel(FeedType category) {
    switch (category) {
      case FeedType.top:
        return 'Top';
      case FeedType.new_:
        return 'New';
      case FeedType.ask:
        return 'Ask';
      case FeedType.show:
        return 'Show';
      case FeedType.jobs:
        return 'Jobs';
      case FeedType.best:
        return 'Best';
    }
  }
}
