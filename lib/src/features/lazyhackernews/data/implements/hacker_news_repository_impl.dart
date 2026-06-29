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
