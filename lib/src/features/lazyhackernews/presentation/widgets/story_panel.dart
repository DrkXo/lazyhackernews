import 'package:nocterm/nocterm.dart';

import '../../../../core/services/scroll_service.dart';
import '../cubit/lazy_hacker_news_cubit.dart';
import 'simmer_loading.dart';
import 'story_row.dart';
import 'theme.dart';

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
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(' Stories '),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Component _sectionHeader(String title) {
    return Container(
      color: AppTheme.headerBg,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: SizedBox(
        height: 1,
        child: Text(title, style: AppTheme.sectionTitle),
      ),
    );
  }

  Component _body() {
    if (state.isLoading) {
      return const SimmerLoading();
    }

    if (state.stories.isEmpty) {
      return Center(
        child: Text(
          state.error ?? 'No stories. Press r to refresh.',
          style: state.error != null ? AppTheme.errorText : AppTheme.mutedText,
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
