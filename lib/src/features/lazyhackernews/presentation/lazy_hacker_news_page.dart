import 'dart:io';

import 'package:nocterm/nocterm.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import '../data/models/models.dart';
import 'cubit/lazy_hacker_news_cubit.dart';

class LazyHackerNews extends StatefulComponent {
  const LazyHackerNews({super.key});

  @override
  State<LazyHackerNews> createState() => _LazyHackerNewsState();
}

class _LazyHackerNewsState extends State<LazyHackerNews> {
  late final LazyHackerNewsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LazyHackerNewsCubit>();
  }

  bool _handleKeyEvent(KeyboardEvent event) {
    if (event.logicalKey == LogicalKey.escape ||
        (event.isControlPressed && event.logicalKey == LogicalKey.keyQ) ||
        (event.logicalKey == LogicalKey.keyQ && !event.isControlPressed)) {
      exit(0);
    }

    if (event.logicalKey == LogicalKey.keyJ ||
        event.logicalKey == LogicalKey.arrowDown) {
      _cubit.selectNext();
      return true;
    }
    if (event.logicalKey == LogicalKey.keyK ||
        event.logicalKey == LogicalKey.arrowUp) {
      _cubit.selectPrevious();
      return true;
    }

    if (event.logicalKey == LogicalKey.keyR) {
      _cubit.refresh();
      return true;
    }

    if (event.logicalKey == LogicalKey.digit1) {
      _cubit.setCategory(Category.top);
      return true;
    }
    if (event.logicalKey == LogicalKey.digit2) {
      _cubit.setCategory(Category.new_);
      return true;
    }
    if (event.logicalKey == LogicalKey.digit3) {
      _cubit.setCategory(Category.ask);
      return true;
    }
    if (event.logicalKey == LogicalKey.digit4) {
      _cubit.setCategory(Category.show);
      return true;
    }
    if (event.logicalKey == LogicalKey.digit5) {
      _cubit.setCategory(Category.jobs);
      return true;
    }

    return false;
  }

  @override
  Component build(BuildContext context) {
    return Focusable(
      focused: true,
      onKeyEvent: _handleKeyEvent,
      child: BlocBuilder<LazyHackerNewsCubit, LazyHackerNewsState>(
        builder: (context, state) {
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
      return const Center(
        child: Text(
          'No stories. Press r to refresh.',
          style: TextStyle(color: Colors.gray),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.stories.length,
      keyboardScrollable: false,
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

    return Container(
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
      return const Padding(
        padding: EdgeInsets.all(1),
        child: Text(
          'Select a story to view details',
          style: TextStyle(color: Colors.gray),
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
              _categoryTab('1', 'Top', state.category == Category.top),
              _categoryTab('2', 'New', state.category == Category.new_),
              _categoryTab('3', 'Ask', state.category == Category.ask),
              _categoryTab('4', 'Show', state.category == Category.show),
              _categoryTab('5', 'Jobs', state.category == Category.jobs),
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

  String _categoryLabel(Category category) {
    switch (category) {
      case Category.top:
        return 'Top';
      case Category.new_:
        return 'New';
      case Category.ask:
        return 'Ask';
      case Category.show:
        return 'Show';
      case Category.jobs:
        return 'Jobs';
    }
  }
}
