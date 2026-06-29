import 'package:nocterm/nocterm.dart';

import '../../data/models/models.dart';
import 'theme.dart';

class StatusBar extends StatelessComponent {
  final FeedType category;

  const StatusBar({required this.category, super.key});

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
              _tab('1', 'Top', category == FeedType.top),
              _tab('2', 'New', category == FeedType.new_),
              _tab('3', 'Ask', category == FeedType.ask),
              _tab('4', 'Show', category == FeedType.show),
              _tab('5', 'Jobs', category == FeedType.jobs),
              const Spacer(),
              const Text(
                'r:refresh  q:quit',
                style: TextStyle(color: AppTheme.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Component _tab(String key, String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text(
        '[$key]$label',
        style: TextStyle(
          color: isActive ? AppTheme.tabActive : AppTheme.tabInactive,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
