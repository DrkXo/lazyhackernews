import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:nocterm/nocterm.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/fetch_comments_usecase.dart';

class CommentPage extends StatefulComponent {
  final Story story;

  const CommentPage({
    required this.story,
    super.key,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  static final Map<int, List<Comment>> _cache = {};

  late final Story _story;
  late final ScrollController _scrollController;
  List<Comment> _comments = [];
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 0;
  int? _hoveredIndex;
  bool _isFresh = false;
  final Set<int> _collapsed = {};
  bool _internalScroll = false;

  int get _termWidth => stdout.hasTerminal ? stdout.terminalColumns : 80;

  @override
  void initState() {
    super.initState();
    _story = component.story;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    final cached = _cache[_story.id];
    if (cached != null) {
      _comments = cached;
      _isLoading = false;
      _isFresh = false;
    } else {
      _loadComments();
    }
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final useCase = GetIt.I<FetchCommentsUseCase>();
    final result = await useCase(_story.id);
    result.fold(
      (failure) {
        setState(() {
          _error = failure.message;
          _isLoading = false;
        });
      },
      (comments) {
        _cache[_story.id] = comments;
        _collapsed.clear();
        setState(() {
          _comments = comments;
          _isLoading = false;
          _isFresh = true;
        });
      },
    );
  }

  void _onScroll() {
    if (_internalScroll) return;
    final offset = _scrollController.offset;
    final visible = _visibleIndices();
    if (visible.isEmpty) return;
    double cum = 0;
    for (final idx in visible) {
      final lines = _commentLines(idx);
      if (offset >= cum - 0.5 && offset < cum + lines - 0.5) {
        if (_selectedIndex != idx) {
          _selectedIndex = idx;
          setState(() {});
        }
        break;
      }
      cum += lines;
    }
  }

  List<int> _visibleIndices() {
    final indices = <int>[];
    for (int i = 0; i < _comments.length; i++) {
      indices.add(i);
      if (_collapsed.contains(_comments[i].id)) {
        final parentDepth = _comments[i].depth;
        i++;
        while (i < _comments.length && _comments[i].depth > parentDepth) {
          i++;
        }
        i--;
      }
    }
    return indices;
  }

  int _countHiddenReplies(int index) {
    final parentDepth = _comments[index].depth;
    int count = 0;
    for (int j = index + 1; j < _comments.length; j++) {
      if (_comments[j].depth <= parentDepth) break;
      count++;
    }
    return count;
  }

  bool _hasChildren(int index) {
    final d = _comments[index].depth;
    return index + 1 < _comments.length && _comments[index + 1].depth > d;
  }

  bool _hasMoreAtDepth(List<Comment> comments, int start, int level) {
    for (int j = start + 1; j < comments.length; j++) {
      final d = comments[j].depth;
      if (d == level) return true;
      if (d < level) return false;
    }
    return false;
  }

  String _threadPrefix(List<Comment> comments, int index) {
    final depth = comments[index].depth;
    final buf = StringBuffer();
    for (int l = 0; l < depth; l++) {
      buf.write(_hasMoreAtDepth(comments, index, l + 1) ? '\u2502 ' : '  ');
    }
    if (depth > 0 || index > 0) {
      buf.write(
        _hasMoreAtDepth(comments, index, depth)
            ? '\u251c\u2500\u2500 '
            : '\u2514\u2500\u2500 ',
      );
    }
    return buf.toString();
  }

  int _textLines(String text, int indent) {
    if (text.isEmpty) return 0;
    final w = _termWidth - indent;
    if (w <= 0) return 1;
    final words = text.split(' ');
    int lines = 1;
    int cur = 0;
    for (final word in words) {
      if (cur + word.length + 1 > w) {
        lines++;
        cur = word.length;
      } else {
        cur += word.length + 1;
      }
    }
    return lines;
  }

  int _commentLines(int index) {
    final c = _comments[index];
    if (c.isDeleted || c.isDead) return 1;
    if (_collapsed.contains(c.id)) return 1;
    final indent = _commentIndent(index);
    return 1 + _textLines(c.displayText, indent);
  }

  int _commentIndent(int index) {
    final c = _comments[index];
    final depth = c.depth;
    final buf = StringBuffer();
    for (int l = 0; l < depth; l++) {
      buf.write(_hasMoreAtDepth(_comments, index, l + 1) ? '\u2502 ' : '  ');
    }
    if (depth > 0 || index > 0) {
      buf.write(
        _hasMoreAtDepth(_comments, index, depth)
            ? '\u251c\u2500\u2500 '
            : '\u2514\u2500\u2500 ',
      );
    }
    final prefix = buf.toString();
    return 2 + prefix.length + (_hasChildren(index) ? 4 : 3);
  }

  double _offsetForPos(int visiblePos, List<int> visible) {
    double offset = 0;
    for (int i = 0; i < visiblePos && i < visible.length; i++) {
      offset += _commentLines(visible[i]);
    }
    return offset;
  }

  void _selectIndex(int index) {
    final visible = _visibleIndices();
    final pos = visible.indexOf(index);
    if (pos < 0) return;
    setState(() => _selectedIndex = index);
    _internalScroll = true;
    _scrollController.jumpTo(_offsetForPos(pos, visible));
    _internalScroll = false;
  }

  void _selectNext() {
    final visible = _visibleIndices();
    if (visible.isEmpty) return;
    final currentPos = visible.indexOf(_selectedIndex);
    final nextPos = (currentPos + 1).clamp(0, visible.length - 1);
    _selectIndex(visible[nextPos]);
  }

  void _selectPrevious() {
    final visible = _visibleIndices();
    if (visible.isEmpty) return;
    final currentPos = visible.indexOf(_selectedIndex);
    final prevPos = (currentPos - 1).clamp(0, visible.length - 1);
    _selectIndex(visible[prevPos]);
  }

  void _toggleCollapse() {
    if (!_hasChildren(_selectedIndex)) return;
    setState(() {
      final id = _comments[_selectedIndex].id;
      if (_collapsed.contains(id)) {
        _collapsed.remove(id);
      } else {
        _collapsed.add(id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final theme = TuiTheme.of(context);
    return Focusable(
      focused: true,
      onKeyEvent: (event) {
        final key = event.logicalKey;
        if (key == LogicalKey.escape ||
            key == LogicalKey.keyQ ||
            key == LogicalKey.arrowLeft) {
          Navigator.of(context).pop();
          return true;
        }
        if (key == LogicalKey.keyJ) {
          _selectNext();
          return true;
        }
        if (key == LogicalKey.keyK) {
          _selectPrevious();
          return true;
        }
        if (key == LogicalKey.space || key == LogicalKey.enter) {
          _toggleCollapse();
          return true;
        }
        if (key == LogicalKey.keyR) {
          _cache.remove(_story.id);
          _loadComments();
          return true;
        }
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          border: BoxBorder.all(color: theme.outline),
        ),
        margin: const EdgeInsets.all(1),
        child: Column(
          children: [
            _header(theme),
            Divider(height: 1, color: theme.outline),
            Expanded(child: _body(theme)),
          ],
        ),
      ),
    );
  }

  Component _header(TuiThemeData theme) {
    return Container(
      color: theme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      height: 1,
      child: Row(
        children: [
          Text(
            ' Comments: ${_story.title} ',
            style: TextStyle(
              color: theme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _isFresh ? '' : ' (cached)',
            style: TextStyle(color: theme.success),
          ),
          const Spacer(),
          Text(
            'j/k:nav  Space:collapse  r:refresh  q/\u2190:back',
            style: TextStyle(color: theme.outline),
          ),
        ],
      ),
    );
  }

  Component _body(TuiThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Text(
          'Loading comments...',
          style: TextStyle(color: theme.outline),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: TextStyle(color: theme.error),
        ),
      );
    }

    if (_comments.isEmpty) {
      return Center(
        child: Text(
          'No comments',
          style: TextStyle(color: theme.outline),
        ),
      );
    }

    final visible = _visibleIndices();

    return SelectionArea(
      onSelectionCompleted: ClipboardManager.copy,
      selectionColor: theme.primary.withOpacity(0.25),
      child: ListView.builder(
        controller: _scrollController,
        keyboardScrollable: true,
        itemCount: visible.length,
        itemBuilder: (context, pos) {
          final index = visible[pos];
          final comment = _comments[index];
          final isSelected = index == _selectedIndex;
          final isHovered = index == _hoveredIndex;
          final hasChildren = _hasChildren(index);
          final isCollapsed = _collapsed.contains(comment.id);
          final prefix = _threadPrefix(_comments, index);
          final hiddenCount = isCollapsed ? _countHiddenReplies(index) : 0;

          return _commentRow(
            comment: comment,
            prefix: prefix,
            isSelected: isSelected,
            isHovered: isHovered,
            hasChildren: hasChildren,
            isCollapsed: isCollapsed,
            hiddenCount: hiddenCount,
            onTap: () => _selectIndex(index),
            onHoverEnter: () => setState(() => _hoveredIndex = index),
            onHoverExit: () => setState(() => _hoveredIndex = null),
            theme: theme,
          );
        },
      ),
    );
  }

  Component _commentRow({
    required Comment comment,
    required String prefix,
    required bool isSelected,
    required bool isHovered,
    required bool hasChildren,
    required bool isCollapsed,
    required int hiddenCount,
    required VoidCallback onTap,
    required VoidCallback onHoverEnter,
    required VoidCallback onHoverExit,
    required TuiThemeData theme,
  }) {
    final highlighted = isSelected || isHovered;
    final effectiveHover = isHovered && !isSelected;
    final selectMark = isSelected ? '\u25B6 ' : (isHovered ? '\u2192 ' : '  ');
    final collapseMark = hasChildren
        ? (isCollapsed ? ' \u25B6 ' : ' \u25BC ')
        : '   ';

    final nameColor = comment.isDeleted || comment.isDead
        ? theme.outline
        : (highlighted ? const Color(0xFFFFFFFF) : theme.secondary);

    final textIndent = 2 + prefix.length + (hasChildren ? 4 : 3);

    return MouseRegion(
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: isSelected
              ? theme.primary.withOpacity(0.3)
              : effectiveHover
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
                    prefix,
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
                isCollapsed
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Text(
                              prefix,
                              style: TextStyle(
                                color: highlighted
                                    ? const Color(0xFFFFFFFF)
                                    : theme.outline.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              '($hiddenCount replies)',
                              style: TextStyle(
                                color: theme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _buildText(comment.displayText, textIndent),
            ],
          ),
        ),
      ),
    );
  }

  Component _buildText(String text, int indent) {
    if (text.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.only(left: indent.toDouble()),
      child: Text(text),
    );
  }

}
