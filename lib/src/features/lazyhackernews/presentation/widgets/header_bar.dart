import 'package:nocterm/nocterm.dart';

import '../../data/models/models.dart';
import 'theme.dart';

class HeaderBar extends StatelessComponent {
  final FeedType category;

  const HeaderBar({required this.category, super.key});

  @override
  Component build(BuildContext context) {
    return Container(
      color: AppTheme.headerBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              Text(
                ' lazyhackernews ',
                style: TextStyle(
                  color: AppTheme.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                _categoryLabel(category),
                style: const TextStyle(color: AppTheme.accent),
              ),
              const SizedBox(width: 2),
              const Text(
                'j/k:nav  q:quit',
                style: TextStyle(color: AppTheme.muted),
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
