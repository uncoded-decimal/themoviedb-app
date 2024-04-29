part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInit extends HomeState {}

class HomeAlert extends HomeState {
  final String text;
  const HomeAlert({required this.text});
  @override
  List<Object?> get props => [text];
}

class LocationDataSetupComplete extends HomeState {
  final String name;
  final String address;

  const LocationDataSetupComplete({required this.name, required this.address});

  @override
  List<Object?> get props => [name, address];
}

class NowPlayingLoading extends HomeState {}

class NowPlayingLoadingMore extends HomeState {
  final String imageBaseUrl;
  final MovieResponseModel movieResponseModel;
  const NowPlayingLoadingMore(
      {required this.imageBaseUrl, required this.movieResponseModel});
  @override
  List<Object?> get props => [movieResponseModel];
}

class NowPlayingLoaded extends HomeState {
  final String imageBaseUrl;
  final MovieResponseModel movieResponseModel;
  const NowPlayingLoaded(
      {required this.imageBaseUrl, required this.movieResponseModel});
  @override
  List<Object?> get props => [movieResponseModel];
}

class TopRatedLoading extends HomeState {}

class TopRatedLoadingMore extends HomeState {
  final String imageBaseUrl;
  final MovieResponseModel movieResponseModel;
  const TopRatedLoadingMore(
      {required this.imageBaseUrl, required this.movieResponseModel});
  @override
  List<Object?> get props => [movieResponseModel];
}

class TopRatedLoaded extends HomeState {
  final String imageBaseUrl;
  final MovieResponseModel movieResponseModel;
  const TopRatedLoaded(
      {required this.imageBaseUrl, required this.movieResponseModel});
  @override
  List<Object?> get props => [movieResponseModel];
}

class ScrollSenseState extends HomeState {
  final bool showScrollUp;
  const ScrollSenseState({required this.showScrollUp});
  @override
  List<Object?> get props => [showScrollUp];
}
