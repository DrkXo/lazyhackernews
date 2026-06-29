import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/models.dart';

abstract class HackerNewsRepository {
  Future<Either<Failure, List<Story>>> fetchStories(FeedType feed, {int offset = 0, int limit = 15});

  Future<Either<Failure, List<Comment>>> fetchComments(int storyId);
}
