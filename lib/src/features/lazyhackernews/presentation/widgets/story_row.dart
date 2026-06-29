import 'package:nocterm/nocterm.dart';

import '../../data/models/models.dart';

Color _pointsColor(int points) {
  if (points > 100) return Colors.green;
  if (points > 50) return Colors.yellow;
  return Colors.gray;
}

class StoryRow extends StatelessComponent {
  final Story story;
  final int index;
  final bool isSelected;
  final VoidCallback? onTap;

  const StoryRow({
    required this.story,
    required this.index,
    required this.isSelected,
    this.onTap,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final theme = TuiTheme.of(context);
    final color = _pointsColor(story.points);

    final row = Container(
      color:
          isSelected ? theme.primary.withOpacity(0.3) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              Text(
                isSelected ? ' \u25B6 ' : '   ',
                style: TextStyle(
                  color: isSelected ? theme.primary : theme.outline,
                ),
              ),
              Expanded(
                child: Text(
                  '${index + 1}. ${story.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                ' ${story.points}pts',
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: row);
    }
    return row;
  }
}
