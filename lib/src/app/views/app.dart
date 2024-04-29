import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wework_challenge/src/app/bloc/app_bloc.dart';
import 'package:wework_challenge/src/app/helpers/app_router.dart';
import 'package:wework_challenge/src/app/misc/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc(),
      child: MaterialApp(
        theme: AppTheme.defaultTheme,
        initialRoute: '/splash',
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
