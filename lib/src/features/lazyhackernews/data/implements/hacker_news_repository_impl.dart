import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/hacker_news_repository.dart';
import '../models/models.dart';
import '../sources/hacker_news_remote_data_source.dart';

class HackerNewsRepositoryImpl implements HackerNewsRepository {
  final HackerNewsRemoteDataSource _dataSource;

  HackerNewsRepositoryImpl({required this._dataSource});

  @override
  Future<Either<Failure, List<Story>>> fetchStories(FeedType feed) async {
    try {
      final ids = await _dataSource.fetchFeedIds(feed);
      final items = await _dataSource.fetchItems(ids.take(30).toList());
      final stories = items.map(_toStory).toList();
      return Right(stories);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on DataFormattingException catch (e) {
      return Left(DataParsingFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> fetchComments(int storyId) async {
    try {
      final story = await _dataSource.fetchItem(storyId);
      if (story.kids.isEmpty) return const Right([]);
      final comments = await _buildTree(story.kids, 0, 50);
      return Right(comments);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on DataFormattingException catch (e) {
      return Left(DataParsingFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  Future<List<Comment>> _buildTree(List<int> ids, int depth, int max) async {
    if (ids.isEmpty || depth > 5 || max <= 0) return [];
    final items = await _dataSource.fetchItems(ids.take(max).toList());
    final results = <Comment>[];
    var remaining = max;
    for (final item in items) {
      if (remaining <= 0) break;
      results.add(Comment(
        id: item.id,
        author: item.by ?? '?',
        text: item.text ?? '',
        time: item.time ?? 0,
        points: item.score ?? 0,
        depth: depth,
        isDeleted: item.deleted,
        isDead: item.dead,
      ));
      remaining--;
      if (item.kids.isNotEmpty && depth < 5) {
        final kids = await _buildTree(item.kids, depth + 1, remaining);
        results.addAll(kids);
        remaining -= kids.length;
      }
    }
    return results;
  }

  Story _toStory(Item item) {
    final uri = item.url != null ? Uri.tryParse(item.url!) : null;
    return Story(
      id: item.id,
      title: item.title ?? '(no title)',
      points: item.score ?? 0,
      author: item.by ?? 'anonymous',
      commentCount: item.descendants ?? 0,
      url: item.url,
      domain: uri?.host,
    );
  }
}
