import 'package:get_it/get_it.dart';
import 'package:nocterm/nocterm.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/fetch_comments_usecase.dart';

class CommentPage extends StatefulComponent {
  final Story story;
  final VoidCallback onBack;

  const CommentPage({
    required this.story,
    required this.onBack,
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

  @override
  void initState() {
    super.initState();
    _story = component.story;
    _scrollController = ScrollController();

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
        setState(() {
          _comments = comments;
          _isLoading = false;
          _isFresh = true;
        });
      },
    );
  }

  void _selectNext() {
    if (_comments.isEmpty) return;
    final next = (_selectedIndex + 1).clamp(0, _comments.length - 1);
    setState(() => _selectedIndex = next);
    _scrollController.jumpTo(next.toDouble());
  }

  void _selectPrevious() {
    if (_comments.isEmpty) return;
    final prev = (_selectedIndex - 1).clamp(0, _comments.length - 1);
    setState(() => _selectedIndex = prev);
    _scrollController.jumpTo(prev.toDouble());
  }

  @override
  void dispose() {
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
          component.onBack();
          return true;
        }
        if (key == LogicalKey.arrowDown || key == LogicalKey.keyJ) {
          _selectNext();
          return true;
        }
        if (key == LogicalKey.arrowUp || key == LogicalKey.keyK) {
          _selectPrevious();
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
            'j/k:nav  r:refresh  q/\u2190:back',
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

    return ListView.builder(
      controller: _scrollController,
      keyboardScrollable: false,
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        final comment = _comments[index];
        final isSelected = index == _selectedIndex;
        return _commentRow(comment, isSelected, theme);
      },
    );
  }

  Component _commentRow(Comment comment, bool isSelected, TuiThemeData theme) {
    final indent = '  ' * comment.depth;
    final prefix = comment.isDeleted || comment.isDead
        ? '[removed]'
        : '${comment.author} (${comment.points})';
    final text = comment.isDeleted || comment.isDead
        ? ''
        : comment.oneLineText;

    final bgColor = isSelected ? theme.primary.withOpacity(0.2) : null;

    return Container(
      color: bgColor,
      height: 1,
      child: Row(
        children: [
          if (isSelected)
            Text(' \u25B6 ', style: TextStyle(color: theme.primary))
          else
            const Text('   '),
          Text(indent),
          Text(
            prefix,
            style: TextStyle(
              color: comment.isDeleted || comment.isDead
                  ? theme.outline
                  : theme.secondary,
            ),
          ),
          if (text.isNotEmpty) ...[
            const Text(' '),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.outline),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
