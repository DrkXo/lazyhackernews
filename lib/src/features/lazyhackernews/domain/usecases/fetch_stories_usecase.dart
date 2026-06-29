import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/models.dart';
import '../repositories/hacker_news_repository.dart';

class FetchStoriesUseCase {
  final HackerNewsRepository _repository;

  FetchStoriesUseCase({required this._repository});

  Future<Either<Failure, List<Story>>> call(FeedType feed, {int offset = 0, int limit = 15}) {
    return _repository.fetchStories(feed, offset: offset, limit: limit);
  }
}
