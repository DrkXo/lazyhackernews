import 'package:nocterm/nocterm.dart';

import '../../data/models/models.dart';
import 'theme.dart';

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
    final color = AppTheme.pointsColor(story.points);

    final row = Container(
      color: isSelected ? AppTheme.selection : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              Text(
                isSelected ? ' \u25B6 ' : '   ',
                style: TextStyle(
                  color: isSelected ? AppTheme.tabActive : AppTheme.muted,
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
