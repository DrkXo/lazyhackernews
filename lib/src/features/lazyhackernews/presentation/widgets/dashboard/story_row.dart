import 'package:nocterm/nocterm.dart';

import '../../../data/models/models.dart';

Color _pointsColor(int points) {
  if (points > 100) return Colors.green;
  if (points > 50) return Colors.yellow;
  return Colors.gray;
}

class StoryRow extends StatefulComponent {
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
  State<StoryRow> createState() => _StoryRowState();
}

class _StoryRowState extends State<StoryRow> {
  bool _isHovered = false;

  @override
  Component build(BuildContext context) {
    final theme = TuiTheme.of(context);
    final color = _pointsColor(component.story.points);
    final isSelected = component.isSelected;
    final isHovered = _isHovered && !isSelected;
    final highlighted = isSelected || isHovered;

    final row = Container(
      color: isSelected
          ? theme.primary.withOpacity(0.35)
          : isHovered
              ? const Color(0xFF333333)
              : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
          height: 1,
          child: Row(
            children: [
              Text(
                isSelected
                    ? ' \u25B6 '
                    : isHovered
                        ? ' \u2192 '
                        : '   ',
                style: TextStyle(
                  color: highlighted ? theme.primary : theme.outline,
                ),
              ),
              Expanded(
                child: Text(
                  '${component.index + 1}. ${component.story.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: highlighted ? FontWeight.bold : null,
                    color: highlighted ? const Color(0xFFFFFFFF) : null,
                  ),
                ),
              ),
              if (isSelected)
                Text(
                  ' ${component.story.points}pts \u2713',
                  style: TextStyle(color: color),
                )
              else
                Text(
                  ' ${component.story.points}pts',
                  style: TextStyle(color: color),
                ),
            ],
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: component.onTap != null
          ? GestureDetector(onTap: component.onTap, child: row)
          : row,
    );
  }
}
