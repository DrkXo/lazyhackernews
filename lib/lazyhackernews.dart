import 'package:nocterm/nocterm.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import 'src/features/lazyhackernews/data/implements/hacker_news_repository_impl.dart';
import 'src/features/lazyhackernews/data/sources/hacker_news_remote_data_source.dart';
import 'src/features/lazyhackernews/domain/usecases/fetch_stories_usecase.dart';
import 'src/features/lazyhackernews/presentation/cubit/lazy_hacker_news_cubit.dart';
import 'src/features/lazyhackernews/presentation/lazy_hacker_news_page.dart';

Future<void> main() async {
  final dataSource = HackerNewsRemoteDataSource();
  final repository = HackerNewsRepositoryImpl(dataSource: dataSource);
  final fetchStories = FetchStoriesUseCase(repository: repository);

  runApp(
    BlocProvider(
      create: (context) => LazyHackerNewsCubit(fetchStories: fetchStories),
      child: LazyHackerNews(),
    ),
  );
}
