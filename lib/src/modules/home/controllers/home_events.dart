part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class SetupHome extends HomeEvent {
  final LocationDataModel locationDataModel;

  const SetupHome({
    required this.locationDataModel,
  });

  @override
  List<Object?> get props => [locationDataModel];
}

class SearchKeyAdded extends HomeEvent {
  final String key;

  const SearchKeyAdded({
    required this.key,
  });

  @override
  List<Object?> get props => [key];
}

class NowplayingFetchMore extends HomeEvent {}

class TopRatedFetchMore extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

class ScrollSenseEvent extends HomeEvent {
  final bool hasScrolledOver;
  const ScrollSenseEvent({required this.hasScrolledOver});

  @override
  List<Object?> get props => [hasScrolledOver];
}
