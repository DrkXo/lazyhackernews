import 'package:nocterm/nocterm.dart';

import '../../data/models/models.dart';
import '../cubit/lazy_hacker_news_cubit.dart';

class DetailPanel extends StatelessComponent {
  final LazyHackerNewsState state;

  const DetailPanel({required this.state, super.key});

  @override
  Component build(BuildContext context) {
    final theme = TuiTheme.of(context);
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(context, ' Details '),
          Expanded(child: _content(context, theme)),
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

  Component _content(BuildContext context, TuiThemeData theme) {
    if (state.stories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(1),
        child: Text(
          state.error ?? 'Select a story to view details',
          style: state.error != null
              ? TextStyle(color: theme.error)
              : TextStyle(color: theme.outline),
        ),
      );
    }

    final story = state.stories[state.selectedIndex];
    final commentCount = state.comments.length;

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
            style: TextStyle(color: theme.secondary),
          ),
          Text(
            '${story.points} points  |  ${story.commentCount} comments',
            style: TextStyle(color: theme.outline),
          ),
          if (story.url != null) ...[
            const SizedBox(height: 1),
            Text(
              story.url!,
              style: TextStyle(
                color: theme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
          const SizedBox(height: 1),
          Divider(height: 1, color: theme.outline),
          if (state.isLoadingComments)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                'Loading comments...',
                style: TextStyle(color: theme.outline),
              ),
            )
          else if (state.comments.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                state.error ?? 'No comments',
                style: state.error != null
                    ? TextStyle(color: theme.error)
                    : TextStyle(color: theme.outline),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: ListView.builder(
                  keyboardScrollable: false,
                  itemCount: commentCount,
                  itemBuilder: (context, index) {
                    final comment = state.comments[index];
                    return _commentRow(comment, theme);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Component _commentRow(Comment comment, TuiThemeData theme) {
    final indent = '  ' * comment.depth;
    final prefix = comment.isDeleted || comment.isDead
        ? '[removed]'
        : '${comment.author} (${comment.points})';
    final text = comment.isDeleted || comment.isDead
        ? ''
        : comment.oneLineText;
    return Container(
      height: 1,
      child: Row(
        children: [
          Text(
            indent,
            style: TextStyle(color: theme.outline),
          ),
          Text(
            prefix,
            style: TextStyle(
              color: comment.isDeleted || comment.isDead
                  ? theme.outline
                  : theme.secondary,
            ),
          ),
          if (text.isNotEmpty) ...[
            const Text(' '),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.outline),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
