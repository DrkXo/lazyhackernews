import 'package:nocterm/nocterm.dart';

import '../../../data/models/models.dart';

class CommentRow extends StatefulComponent {
  final Comment comment;
  final String prefix;
  final bool isSelected;
  final bool hasChildren;
  final bool isCollapsed;
  final int hiddenCount;
  final int textIndent;
  final VoidCallback onTap;

  const CommentRow({
    required this.comment,
    required this.prefix,
    required this.isSelected,
    required this.hasChildren,
    required this.isCollapsed,
    required this.hiddenCount,
    required this.textIndent,
    required this.onTap,
    super.key,
  });

  @override
  State<CommentRow> createState() => _CommentRowState();
}

class _CommentRowState extends State<CommentRow> {
  bool _isHovered = false;

  @override
  Component build(BuildContext context) {
    final theme = TuiTheme.of(context);
    final comment = component.comment;
    final isSelected = component.isSelected;
    final isHovered = _isHovered && !isSelected;
    final highlighted = isSelected || isHovered;

    final selectMark =
        isSelected ? '\u25B6 ' : (isHovered ? '\u2192 ' : '  ');
    final collapseMark = component.hasChildren
        ? (component.isCollapsed ? ' \u25B6 ' : ' \u25BC ')
        : '   ';

    final nameColor = comment.isDeleted || comment.isDead
        ? theme.outline
        : (highlighted ? const Color(0xFFFFFFFF) : theme.secondary);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: component.onTap,
        child: Container(
          color: isSelected
              ? theme.primary.withOpacity(0.3)
              : isHovered
                  ? const Color(0xFF2A2A2A)
                  : null,
          padding: const EdgeInsets.only(bottom: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(selectMark, style: TextStyle(color: theme.primary)),
                  Text(
                    component.prefix,
                    style: TextStyle(
                      color: highlighted
                          ? const Color(0xFFFFFFFF)
                          : theme.outline.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    collapseMark,
                    style: TextStyle(
                      color: highlighted
                          ? const Color(0xFFFFFFFF)
                          : theme.outline,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          comment.isDeleted || comment.isDead
                              ? '[removed]'
                              : comment.author,
                          style: TextStyle(
                            color: nameColor,
                            fontWeight: highlighted ? FontWeight.bold : null,
                          ),
                        ),
                        if (!comment.isDeleted && !comment.isDead)
                          Text(
                            ' (${comment.points})',
                            style: TextStyle(
                              color: highlighted
                                  ? const Color(0xFFFFFFFF)
                                  : theme.outline,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!comment.isDeleted && !comment.isDead)
                component.isCollapsed
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Text(
                              component.prefix,
                              style: TextStyle(
                                color: highlighted
                                    ? const Color(0xFFFFFFFF)
                                    : theme.outline.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              '(${component.hiddenCount} replies)',
                              style: TextStyle(
                                color: theme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : CommentText(
                        text: comment.displayText,
                        indent: component.textIndent,
                      ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentText extends StatelessComponent {
  final String text;
  final int indent;

  const CommentText({
    required this.text,
    required this.indent,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    if (text.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.only(left: indent.toDouble()),
      child: Text(text),
    );
  }
}
