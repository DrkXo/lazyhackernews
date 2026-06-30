import 'package:nocterm/nocterm.dart';

import '../../../data/models/models.dart';

class StatusBar extends StatelessComponent {
  final FeedType category;

  const StatusBar({required this.category, super.key});

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
              _tab(context, '1', 'Top', category == FeedType.top),
              _tab(context, '2', 'New', category == FeedType.new_),
              _tab(context, '3', 'Ask', category == FeedType.ask),
              _tab(context, '4', 'Show', category == FeedType.show),
              _tab(context, '5', 'Jobs', category == FeedType.jobs),
              const Spacer(),
              Text(
                'r:refresh  q:quit',
                style: TextStyle(color: theme.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Component _tab(BuildContext context, String key, String label, bool isActive) {
    final theme = TuiTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text(
        '[$key]$label',
        style: TextStyle(
          color: isActive ? theme.primary : theme.outline,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
