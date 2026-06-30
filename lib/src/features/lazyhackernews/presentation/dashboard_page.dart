import 'package:get_it/get_it.dart';
import 'package:nocterm/nocterm.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import '../../../core/routes/routes.dart';
import '../../../core/services/input_service.dart';
import '../../../core/services/mouse_service.dart';
import '../../../core/services/scroll_service.dart';
import '../data/models/models.dart';
import 'dashboard/dashboard_cubit.dart';
import 'widgets/dashboard/detail_panel.dart';
import 'widgets/dashboard/header_bar.dart';
import 'widgets/dashboard/status_bar.dart';
import 'widgets/dashboard/story_panel.dart';

class DashboardPage extends StatefulComponent {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashboardPage> {
  late final DashboardCubit _cubit;
  final _inputService = GetIt.I<InputService>();
  final _scrollService = GetIt.I<ScrollService>();
  final _mouseService = GetIt.I<MouseService>();
  int _prevSelectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<DashboardCubit>();

    _mouseService.onStoryTap = (index) => _cubit.selectAt(index);
    _scrollService.controller.addListener(_onScroll);

    _inputService.registerAll([
      KeyBinding(
        key: LogicalKey.escape,
        action: () {
          shutdownApp();
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.keyQ,
        predicate: (e) => !e.isControlPressed,
        action: () {
          shutdownApp();
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.keyQ,
        predicate: (e) => e.isControlPressed,
        action: () {
          shutdownApp();
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.keyC,
        predicate: (e) => e.isControlPressed,
        action: () {
          shutdownApp();
          return true;
        },
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
      KeyBinding(
        key: LogicalKey.enter,
        action: () {
          _openComments();
          return true;
        },
      ),
      KeyBinding(
        key: LogicalKey.arrowRight,
        action: () {
          _openComments();
          return true;
        },
      ),
    ]);
  }

  void _openComments() {
    final stories = _cubit.state.stories;
    if (stories.isEmpty) return;
    final story = stories[_cubit.state.selectedIndex];
    Navigator.of(context).pushNamed(Routes.comments, arguments: story);
  }

  void _onStateChanged(DashboardState state) {
    if (_prevSelectedIndex != state.selectedIndex) {
      _prevSelectedIndex = state.selectedIndex;
      _scrollService.scrollToIndex(state.selectedIndex);
    }
  }

  void _onScroll() {
    final state = _cubit.state;
    if (state.isLoadingMore || !state.hasMore) return;
    final controller = _scrollService.controller;
    if (controller.offset >= controller.maxScrollExtent - 5) {
      _cubit.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollService.controller.removeListener(_onScroll);
    _scrollService.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return Focusable(
      focused: true,
      onKeyEvent: (event) => _inputService.handle(event),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          _onStateChanged(state);
          final theme = TuiTheme.of(context);
          return Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: theme.outline),
            ),
            margin: const EdgeInsets.all(1),
            child: Column(
              children: [
                HeaderBar(category: state.category),
                Divider(height: 1, color: theme.outline),
                Expanded(
                  child: Row(
                    children: [
                      StoryPanel(
                        state: state,
                        scrollService: _scrollService,
                        onStoryTap: (i) => _cubit.selectAt(i),
                      ),
                      if (!state.isLoading && state.stories.isNotEmpty)
                        VerticalDivider(width: 1, color: theme.outline),
                      if (!state.isLoading && state.stories.isNotEmpty)
                        DetailPanel(state: state),
                    ],
                  ),
                ),
                Divider(height: 1, color: theme.outline),
                StatusBar(category: state.category),
              ],
            ),
          );
        },
      ),
    );
  }
}
