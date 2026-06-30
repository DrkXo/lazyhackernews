import 'package:nocterm/nocterm.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import 'src/core/config/injection.dart';
import 'src/core/routes/routes.dart';
import 'src/features/lazyhackernews/data/models/models.dart';
import 'src/features/lazyhackernews/presentation/comment_page.dart';
import 'src/features/lazyhackernews/presentation/dashboard/dashboard_cubit.dart';
import 'src/features/lazyhackernews/presentation/dashboard_page.dart';

Future<void> main() async {
  await configureDependencies();

  runApp(
    BlocProvider(
      create: (context) => getIt<DashboardCubit>(),
      child: NoctermApp(
        title: 'Lazy Hacker News',
        theme: TuiThemeData.dark,
        iconName: 'assets/favicon.ico',
        home: const DashboardPage(),
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
