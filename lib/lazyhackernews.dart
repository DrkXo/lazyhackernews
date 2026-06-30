import 'package:nocterm/nocterm.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import 'src/core/config/injection.dart';
import 'src/core/routes/routes.dart';
import 'src/features/lazyhackernews/data/models/models.dart';
import 'src/features/lazyhackernews/presentation/cubit/lazy_hacker_news_cubit.dart';
import 'src/features/lazyhackernews/presentation/lazy_hacker_news_page.dart';
import 'src/features/lazyhackernews/presentation/widgets/comment_page.dart';

Future<void> main() async {
  await configureDependencies();

  runApp(
    BlocProvider(
      create: (context) => getIt<LazyHackerNewsCubit>(),
      child: NoctermApp(
        title: 'Lazy Hacker News',
        theme: TuiThemeData.dark,
        iconName: 'assets/favicon.ico',
        home: const LazyHackerNews(),
        onGenerateRoute: (settings) {
          if (settings.name == Routes.comments) {
            final story = settings.arguments as Story;
            return PageRoute(
              builder: (context) => CommentPage(story: story),
              settings: settings,
            );
          }
          return null;
        },
      ),
    ),
  );
}
