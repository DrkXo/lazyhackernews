library;

import 'package:get_it/get_it.dart';

import '../services/http_service.dart';
import '../services/input_service.dart';
import '../services/mouse_service.dart';
import '../services/scroll_service.dart';
import '../../features/lazyhackernews/data/implements/hacker_news_repository_impl.dart';
import '../../features/lazyhackernews/data/sources/hacker_news_remote_data_source.dart';
import '../../features/lazyhackernews/domain/repositories/hacker_news_repository.dart';
import '../../features/lazyhackernews/domain/usecases/fetch_comments_usecase.dart';
import '../../features/lazyhackernews/domain/usecases/fetch_stories_usecase.dart';
import '../../features/lazyhackernews/presentation/cubit/lazy_hacker_news_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerSingleton<HttpService>(HttpService());
  getIt.registerSingleton<InputService>(InputService());
  getIt.registerSingleton<ScrollService>(ScrollService());
  getIt.registerSingleton<MouseService>(MouseService());

  getIt.registerSingleton<HackerNewsRemoteDataSource>(
    HackerNewsRemoteDataSource(http: getIt<HttpService>()),
  );

  getIt.registerSingleton<HackerNewsRepository>(
    HackerNewsRepositoryImpl(
      dataSource: getIt<HackerNewsRemoteDataSource>(),
    ),
  );

  getIt.registerSingleton<FetchStoriesUseCase>(
    FetchStoriesUseCase(repository: getIt<HackerNewsRepository>()),
  );

  getIt.registerSingleton<FetchCommentsUseCase>(
    FetchCommentsUseCase(repository: getIt<HackerNewsRepository>()),
  );

  getIt.registerSingleton<LazyHackerNewsCubit>(
    LazyHackerNewsCubit(
      fetchStories: getIt<FetchStoriesUseCase>(),
      fetchComments: getIt<FetchCommentsUseCase>(),
    ),
  );
}
