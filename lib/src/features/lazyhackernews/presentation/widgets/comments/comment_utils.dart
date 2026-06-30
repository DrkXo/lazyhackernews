import '../../../data/models/models.dart';

List<int> visibleIndices(List<Comment> comments, Set<int> collapsed) {
  final indices = <int>[];
  for (int i = 0; i < comments.length; i++) {
    indices.add(i);
    if (collapsed.contains(comments[i].id)) {
      final parentDepth = comments[i].depth;
      i++;
      while (i < comments.length && comments[i].depth > parentDepth) {
        i++;
      }
      i--;
    }
  }
  return indices;
}

int countHiddenReplies(List<Comment> comments, int index) {
  final parentDepth = comments[index].depth;
  int count = 0;
  for (int j = index + 1; j < comments.length; j++) {
    if (comments[j].depth <= parentDepth) break;
    count++;
  }
  return count;
}

bool hasChildren(List<Comment> comments, int index) {
  final d = comments[index].depth;
  return index + 1 < comments.length && comments[index + 1].depth > d;
}

bool hasMoreAtDepth(List<Comment> comments, int start, int level) {
  for (int j = start + 1; j < comments.length; j++) {
    final d = comments[j].depth;
    if (d == level) return true;
    if (d < level) return false;
  }
  return false;
}

String threadPrefix(List<Comment> comments, int index) {
  final depth = comments[index].depth;
  final buf = StringBuffer();
  for (int l = 0; l < depth; l++) {
    buf.write(hasMoreAtDepth(comments, index, l + 1) ? '\u2502 ' : '  ');
  }
  if (depth > 0 || index > 0) {
    buf.write(
      hasMoreAtDepth(comments, index, depth)
          ? '\u251c\u2500\u2500 '
          : '\u2514\u2500\u2500 ',
    );
  }
  return buf.toString();
}

int textLines(String text, int indent, int termWidth) {
  if (text.isEmpty) return 0;
  final w = termWidth - indent;
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

int commentLines(
    List<Comment> comments, int index, Set<int> collapsed, int termWidth) {
  final c = comments[index];
  if (c.isDeleted || c.isDead) return 1;
  if (collapsed.contains(c.id)) return 1;
  final indent = commentIndent(comments, index);
  return 1 + textLines(c.displayText, indent, termWidth);
}

int commentIndent(List<Comment> comments, int index) {
  final c = comments[index];
  final depth = c.depth;
  final buf = StringBuffer();
  for (int l = 0; l < depth; l++) {
    buf.write(hasMoreAtDepth(comments, index, l + 1) ? '\u2502 ' : '  ');
  }
  if (depth > 0 || index > 0) {
    buf.write(
      hasMoreAtDepth(comments, index, depth)
          ? '\u251c\u2500\u2500 '
          : '\u2514\u2500\u2500 ',
    );
  }
  final prefix = buf.toString();
  return 2 + prefix.length + (hasChildren(comments, index) ? 4 : 3);
}

double offsetForPos(
    int visiblePos, List<int> visible, List<Comment> comments,
    Set<int> collapsed, int termWidth) {
  double offset = 0;
  for (int i = 0; i < visiblePos && i < visible.length; i++) {
    offset += commentLines(comments, visible[i], collapsed, termWidth);
  }
  return offset;
}
