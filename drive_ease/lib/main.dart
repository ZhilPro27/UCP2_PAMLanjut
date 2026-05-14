import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/katalog_repository.dart';
import 'data/repositories/kategori_repository.dart';
import 'logic/bloc/auth/auth_bloc.dart';
import 'logic/bloc/auth/auth_event.dart';
import 'logic/bloc/katalog/katalog_bloc.dart';
import 'logic/bloc/kategori/kategori_bloc.dart';
import 'logic/debug/bloc_observer.dart';
import 'ui/core/app_router.dart';
import 'ui/core/app_theme.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => KatalogRepository()),
        RepositoryProvider(create: (context) => KategoriRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              repository: context.read<AuthRepository>(),
            )..add(AppStarted()),
          ),
          BlocProvider(
            create: (context) => KatalogBloc(
              repository: context.read<KatalogRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => KategoriBloc(
              repository: context.read<KategoriRepository>(),
            ),
          ),
        ],
        child: ShadApp(
          debugShowCheckedModeBanner: false,
          title: 'DriveEase',
          theme: AppTheme.theme,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: '/',
        ),
      ),
    );
  }
}
