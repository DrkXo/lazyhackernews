import 'package:nocterm/nocterm.dart';
import 'package:nocterm_bloc/nocterm_bloc.dart';

import 'src/features/lazyhackernews/presentation/cubit/lazy_hacker_news_cubit.dart';
import 'src/features/lazyhackernews/presentation/lazy_hacker_news_page.dart';

Future<void> main() async {
  runApp(
    BlocProvider(
      create: (context) => LazyHackerNewsCubit(),
      child: LazyHackerNews(),
    ),
  );
}
