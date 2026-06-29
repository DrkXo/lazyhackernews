import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:nocterm/nocterm.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import '../../../core/services/input_service.dart';
import '../../../core/services/mouse_service.dart';
import '../../../core/services/scroll_service.dart';
import '../data/models/models.dart';
import 'cubit/lazy_hacker_news_cubit.dart';
import 'widgets/detail_panel.dart';
import 'widgets/header_bar.dart';
import 'widgets/status_bar.dart';
import 'widgets/story_panel.dart';
import 'widgets/theme.dart';

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

    _mouseService.onStoryTap = (index) => _cubit.selectAt(index);

    _inputService.registerAll([
      KeyBinding(key: LogicalKey.escape, action: () => exit(0)),
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
      _scrollService.scrollToIndex(state.selectedIndex);
    }
  }

  @override
  void dispose() {
    _scrollService.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return Focusable(
      focused: true,
      onKeyEvent: (event) => _inputService.handle(event),
      child: BlocBuilder<LazyHackerNewsCubit, LazyHackerNewsState>(
        builder: (context, state) {
          _onStateChanged(state);
          return Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: AppTheme.border),
            ),
            margin: const EdgeInsets.all(1),
            child: Column(
              children: [
                HeaderBar(category: state.category),
                const Divider(height: 1, color: AppTheme.border),
                Expanded(
                  child: Row(
                    children: [
                      StoryPanel(
                        state: state,
                        scrollService: _scrollService,
                        onStoryTap: (i) => _cubit.selectAt(i),
                      ),
                      const VerticalDivider(width: 1, color: AppTheme.border),
                      DetailPanel(state: state),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppTheme.border),
                StatusBar(category: state.category),
              ],
            ),
          );
        },
      ),
    );
  }
}
