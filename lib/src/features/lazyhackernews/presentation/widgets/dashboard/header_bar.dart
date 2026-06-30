import 'package:nocterm/nocterm.dart';

import '../../../data/models/models.dart';

class HeaderBar extends StatelessComponent {
  final FeedType category;

  const HeaderBar({required this.category, super.key});

  @override
  Component build(BuildContext context) {
    final theme = TuiTheme.of(context);
    return Container(
      color: theme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              Text(
                ' lazyhackernews ',
                style: TextStyle(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                _categoryLabel(category),
                style: TextStyle(color: theme.secondary),
              ),
              const SizedBox(width: 2),
              Text(
                'j/k:nav  q:quit',
                style: TextStyle(color: theme.outline),
              ),
            ],
          ),
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
