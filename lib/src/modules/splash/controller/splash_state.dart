part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInit extends SplashState {}

class SplashToast extends SplashState {
  final String message;

  const SplashToast({required this.message});

  @override
  List<Object> get props => [message];
}

class DataSetupComplete extends SplashState {
  final LocationDataModel dataModel;

  const DataSetupComplete({
    required this.dataModel,
  });

  @override
  List<Object> get props => [dataModel];
}
