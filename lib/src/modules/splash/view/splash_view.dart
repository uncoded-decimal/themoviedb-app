import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wework_challenge/src/app/helpers/intent_helper.dart';
import 'package:wework_challenge/src/modules/splash/controller/splash_bloc.dart';
import 'package:wework_challenge/src/modules/splash/widgets/we_loader.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final splashBloc = BlocProvider.of<SplashBloc>(context)..add(AppReady());
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        bloc: splashBloc,
        listener: (_, state) {
          if (state is SplashToast) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is DataSetupComplete) {
            IntentHelper.goToHome(
              context: context,
              data: state.dataModel,
            );
          }
        },
        child: const Center(
          child: WeLoadingWidget(),
        ),
      ),
    );
  }
}
