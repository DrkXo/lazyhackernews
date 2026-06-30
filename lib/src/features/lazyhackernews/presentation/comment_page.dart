import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:nocterm/nocterm.dart';

import '../data/models/models.dart';
import '../domain/usecases/fetch_comments_usecase.dart';
import 'widgets/comments/comment_row.dart';
import 'widgets/comments/comment_utils.dart';

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
    final visible = visibleIndices(_comments, _collapsed);
    if (visible.isEmpty) return;
    double cum = 0;
    for (final idx in visible) {
      final lines = commentLines(_comments, idx, _collapsed, _termWidth);
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

  void _selectIndex(int index) {
    final visible = visibleIndices(_comments, _collapsed);
    final pos = visible.indexOf(index);
    if (pos < 0) return;
    setState(() => _selectedIndex = index);
    _internalScroll = true;
    _scrollController.jumpTo(
      offsetForPos(pos, visible, _comments, _collapsed, _termWidth),
    );
    _internalScroll = false;
  }

  void _selectNext() {
    final visible = visibleIndices(_comments, _collapsed);
    if (visible.isEmpty) return;
    final currentPos = visible.indexOf(_selectedIndex);
    final nextPos = (currentPos + 1).clamp(0, visible.length - 1);
    _selectIndex(visible[nextPos]);
  }

  void _selectPrevious() {
    final visible = visibleIndices(_comments, _collapsed);
    if (visible.isEmpty) return;
    final currentPos = visible.indexOf(_selectedIndex);
    final prevPos = (currentPos - 1).clamp(0, visible.length - 1);
    _selectIndex(visible[prevPos]);
  }

  void _toggleCollapse() {
    if (!hasChildren(_comments, _selectedIndex)) return;
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
        if (key == LogicalKey.keyJ || key == LogicalKey.arrowDown) {
          _selectNext();
          return true;
        }
        if (key == LogicalKey.keyK || key == LogicalKey.arrowUp) {
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
            '\u2191/\u2193/j/k:nav  Space:collapse  r:refresh  q/\u2190:back',
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

    final visible = visibleIndices(_comments, _collapsed);

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
          final hc = hasChildren(_comments, index);
          final isCollapsed = _collapsed.contains(comment.id);
          final prefix = threadPrefix(_comments, index);
          final hiddenCount = isCollapsed
              ? countHiddenReplies(_comments, index)
              : 0;
          final indent = 2 + prefix.length + (hc ? 4 : 3);

          return CommentRow(
            comment: comment,
            prefix: prefix,
            isSelected: isSelected,
            hasChildren: hc,
            isCollapsed: isCollapsed,
            hiddenCount: hiddenCount,
            textIndent: indent,
            onTap: () => _selectIndex(index),
          );
        },
      ),
    );
  }
}
