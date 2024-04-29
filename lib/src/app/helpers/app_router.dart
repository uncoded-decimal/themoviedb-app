import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wework_challenge/src/data/repository/movies_repo_impl.dart';
import 'package:wework_challenge/src/modules/home/controllers/home_bloc.dart';
import 'package:wework_challenge/src/modules/home/views/home_view.dart';
import 'package:wework_challenge/src/modules/splash/controller/splash_bloc.dart';
import 'package:wework_challenge/src/modules/splash/view/splash_view.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case Routes.splash:
        return _splashRoute(settings: settings);
      case Routes.home:
        return _homeRoute(settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Container(
            alignment: Alignment.center,
            child: const Text(
              'Unknown Route',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute _splashRoute({
    required RouteSettings settings,
  }) =>
      MaterialPageRoute(
        builder: (_) => BlocProvider<SplashBloc>(
          create: (_) => SplashBloc(moviesRepository: MoviesRepositoryImpl()),
          child: const SplashView(),
        ),
        settings: settings,
      );

  static MaterialPageRoute _homeRoute({
    required RouteSettings settings,
  }) =>
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => HomeBloc(moviesRepository: MoviesRepositoryImpl()),
          child: const HomeView(),
        ),
        settings: settings,
      );
}

class Routes {
  static const String splash = "/splash";
  static const String home = "/home";
}
