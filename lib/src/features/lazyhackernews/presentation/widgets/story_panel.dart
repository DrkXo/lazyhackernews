import 'package:nocterm/nocterm.dart';

import '../../../../core/services/scroll_service.dart';
import '../cubit/lazy_hacker_news_cubit.dart';
import 'simmer_loading.dart';
import 'story_row.dart';

class StoryPanel extends StatelessComponent {
  final LazyHackerNewsState state;
  final ScrollService scrollService;
  final void Function(int index) onStoryTap;

  const StoryPanel({
    required this.state,
    required this.scrollService,
    required this.onStoryTap,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final theme = TuiTheme.of(context);
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(context, ' Stories '),
          Expanded(child: _body(context, theme)),
        ],
      ),
    );
  }

  Component _sectionHeader(BuildContext context, String title) {
    final theme = TuiTheme.of(context);
    return Container(
      color: theme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: SizedBox(
        height: 1,
        child: Text(
          title,
          style: TextStyle(
            color: theme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Component _body(BuildContext context, TuiThemeData theme) {
    if (state.isLoading) {
      return const SimmerLoading();
    }

    if (state.stories.isEmpty) {
      return Center(
        child: Text(
          state.error ?? 'No stories. Press r to refresh.',
          style: state.error != null
              ? TextStyle(color: theme.error)
              : TextStyle(color: theme.outline),
        ),
      );
    }

    return ListView.builder(
      controller: scrollService.controller,
      keyboardScrollable: false,
      itemCount: state.stories.length,
      itemBuilder: (context, index) {
        final story = state.stories[index];
        return StoryRow(
          story: story,
          index: index,
          isSelected: index == state.selectedIndex,
          onTap: () => onStoryTap(index),
        );
      },
    );
  }
}
