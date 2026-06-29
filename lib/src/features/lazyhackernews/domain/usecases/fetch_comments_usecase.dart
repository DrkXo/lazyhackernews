import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/models.dart';
import '../repositories/hacker_news_repository.dart';

class FetchCommentsUseCase {
  final HackerNewsRepository _repository;

  FetchCommentsUseCase({required this._repository});

  Future<Either<Failure, List<Comment>>> call(int storyId) {
    return _repository.fetchComments(storyId);
  }
}
