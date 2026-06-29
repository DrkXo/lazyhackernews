import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/models.dart';

abstract class HackerNewsRepository {
  Future<Either<Failure, List<Story>>> fetchStories(FeedType feed);
}
