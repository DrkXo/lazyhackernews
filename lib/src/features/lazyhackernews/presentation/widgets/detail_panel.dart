import 'package:nocterm/nocterm.dart';

import '../cubit/lazy_hacker_news_cubit.dart';
import 'theme.dart';

class DetailPanel extends StatelessComponent {
  final LazyHackerNewsState state;

  const DetailPanel({required this.state, super.key});

  @override
  Component build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(' Details '),
          Expanded(child: _content()),
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

  Component _content() {
    if (state.stories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(1),
        child: Text(
          state.error ?? 'Select a story to view details',
          style: state.error != null ? AppTheme.errorText : AppTheme.mutedText,
        ),
      );
    }

    final story = state.stories[state.selectedIndex];

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(story.title, style: AppTheme.bold),
          const SizedBox(height: 1),
          Text(
            'by ${story.author}',
            style: const TextStyle(color: AppTheme.author),
          ),
          Text(
            '${story.points} points  |  ${story.commentCount} comments',
            style: AppTheme.mutedText,
          ),
          if (story.url != null) ...[
            const SizedBox(height: 1),
            Text(story.url!, style: AppTheme.linkText),
          ],
          const SizedBox(height: 1),
          const Divider(height: 1, color: Colors.gray),
          const SizedBox(height: 1),
          const Text(
            'Comments',
            style: TextStyle(
              color: AppTheme.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          if (state.error != null)
            Text(state.error!, style: AppTheme.errorText)
          else
            const Text(
              '(comments not yet loaded)',
              style: TextStyle(color: AppTheme.muted),
            ),
        ],
      ),
    );
  }
}
