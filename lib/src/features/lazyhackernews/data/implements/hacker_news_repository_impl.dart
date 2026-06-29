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
  Future<Either<Failure, List<Story>>> fetchStories(FeedType feed, {int offset = 0, int limit = 15}) async {
    try {
      final ids = await _dataSource.fetchFeedIds(feed);
      final batch = ids.skip(offset).take(limit).toList();
      if (batch.isEmpty) return const Right([]);
      final items = await _dataSource.fetchItems(batch);
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
      final cache = <int, Item>{};
      final comments = await _buildTree(story.kids, 0, cache);
      return Right(comments.take(100).toList());
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

  Future<List<Comment>> _buildTree(List<int> ids, int depth, Map<int, Item> cache) async {
    if (ids.isEmpty || depth >= 10) return [];

    final toFetch = ids.where((id) => !cache.containsKey(id)).toList();
    if (toFetch.isNotEmpty) {
      final items = await _dataSource.fetchItems(toFetch);
      for (final item in items) {
        cache[item.id] = item;
      }
    }

    final comments = <Comment>[];
    final subtrees = <Future<List<Comment>>>[];

    for (final id in ids) {
      final item = cache[id];
      if (item == null || comments.length >= 100) continue;
      comments.add(Comment(
        id: item.id,
        author: item.by ?? '?',
        text: item.text ?? '',
        time: item.time ?? 0,
        points: item.score ?? 0,
        depth: depth,
        isDeleted: item.deleted,
        isDead: item.dead,
      ));
      if (item.kids.isNotEmpty && depth < 9) {
        subtrees.add(_buildTree(item.kids, depth + 1, cache));
      }
    }

    if (subtrees.isNotEmpty) {
      final children = await Future.wait(subtrees);
      for (final childList in children) {
        if (comments.length >= 100) break;
        comments.addAll(childList);
      }
    }

    return comments.take(100).toList();
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
