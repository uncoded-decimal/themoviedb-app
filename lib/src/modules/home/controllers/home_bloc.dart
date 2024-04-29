import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wework_challenge/src/data/local/local_storage.dart';
import 'package:wework_challenge/src/data/models/movie_item_model.dart';
import 'package:wework_challenge/src/data/repository/movies_repo.dart';
import 'package:wework_challenge/src/modules/splash/models/app_location_data_model.dart';

part 'home_events.dart';
part 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  double lat = 0, long = 0;
  final MoviesRepository moviesRepository;
  MovieResponseModel? nowPlayingMovies;
  MovieResponseModel? topRatedMovies;
  late ScrollController homeScrollController, nowPlayingScrollController;

  HomeBloc({
    required this.moviesRepository,
  }) : super(HomeInit()) {
    nowPlayingScrollController = ScrollController();
    homeScrollController = ScrollController();
    _setupScrollWidgets();

    on<SetupHome>(
        (event, emit) => _startHomeSetup(event.locationDataModel, emit));
    on<SearchKeyAdded>((event, emit) => _filterResultsByKey(event.key, emit));
    on<NowplayingFetchMore>(
      (event, emit) {
        int currentPage = nowPlayingMovies?.page ?? 0;
        if (currentPage + 1 < nowPlayingMovies!.totalPages) {
          return _fetchNowPlaying(page: currentPage + 1, emit: emit);
        }
      },
    );
    on<TopRatedFetchMore>(
      (event, emit) {
        int currentPage = topRatedMovies?.page ?? 0;
        if (currentPage + 1 < topRatedMovies!.totalPages) {
          return _fetchTopRated(page: currentPage + 1, emit: emit);
        }
      },
    );
    on<RefreshHomeData>((event, emit) async {
      emit(TopRatedLoading());
      emit(NowPlayingLoading());
      await _fetchNowPlaying(emit: emit, forceAPIFetch: true);
      await _fetchTopRated(emit: emit, forceAPIFetch: true);
    });
    on<ScrollSenseEvent>((event, emit) =>
        emit(ScrollSenseState(showScrollUp: event.hasScrolledOver)));
  }

  void _setupScrollWidgets() {
    homeScrollController.addListener(() {
      if (homeScrollController.offset > 1000) {
        add(const ScrollSenseEvent(hasScrolledOver: true));
      } else {
        add(const ScrollSenseEvent(hasScrolledOver: false));
      }
    });
  }

  Future<void> _startHomeSetup(
    LocationDataModel locationDataModel,
    Emitter<HomeState> emit,
  ) async {
    lat = locationDataModel.position.latitude;
    long = locationDataModel.position.longitude;
    emit(LocationDataSetupComplete(
      name: locationDataModel.placeName,
      address: locationDataModel.address,
    ));
    _fetchNowPlaying(emit: emit);
    _fetchTopRated(emit: emit);
  }

  Future<void> _filterResultsByKey(
    String key,
    Emitter<HomeState> emit,
  ) async {
    if (key.isNotEmpty) {
      log("FilterLog :: filtering results for $key");
      final filteredTopRatedMovies = topRatedMovies?.movies.where(
        (movie) {
          final searchKey = key.toLowerCase();
          final title = movie.title.toLowerCase();
          final originalTitle = movie.originalTitle.toLowerCase();
          return title.contains(searchKey) || originalTitle.contains(searchKey);
        },
      ).toList();
      final filteredNowPlayingMovies = nowPlayingMovies?.movies.where(
        (movie) {
          final searchKey = key.toLowerCase();
          final title = movie.title.toLowerCase();
          final originalTitle = movie.originalTitle.toLowerCase();
          return title.contains(searchKey) || originalTitle.contains(searchKey);
        },
      ).toList();
      emit(
        TopRatedLoaded(
          imageBaseUrl: LocalStorageHelper.getImageBaseUrl(),
          movieResponseModel: MovieResponseModel(
            page: 1,
            totalCount: filteredTopRatedMovies!.length,
            totalPages: 1,
            movies: filteredTopRatedMovies,
          ),
        ),
      );
      emit(
        NowPlayingLoaded(
          imageBaseUrl: LocalStorageHelper.getImageBaseUrl(),
          movieResponseModel: MovieResponseModel(
            page: 1,
            totalCount: filteredNowPlayingMovies!.length,
            totalPages: 1,
            movies: filteredNowPlayingMovies,
          ),
        ),
      );
    } else {
      emit(TopRatedLoaded(
        imageBaseUrl: LocalStorageHelper.getImageBaseUrl(),
        movieResponseModel: topRatedMovies!,
      ));
      emit(
        NowPlayingLoaded(
          imageBaseUrl: LocalStorageHelper.getImageBaseUrl(),
          movieResponseModel: nowPlayingMovies!,
        ),
      );
    }
  }

  Future<void> _fetchNowPlaying({
    int page = 1,
    bool forceAPIFetch = false,
    required Emitter<HomeState> emit,
  }) async {
    emit(page == 1
        ? NowPlayingLoading()
        : NowPlayingLoadingMore(
            movieResponseModel: nowPlayingMovies!,
            imageBaseUrl: LocalStorageHelper.getImageBaseUrl(),
          ));
    try {
      final response = await moviesRepository.fetchNowPlaying(
          page: page, forceFetchApiData: forceAPIFetch);
      if (response != null) {
        final moviesList = nowPlayingMovies?.movies ?? [];
        moviesList.addAll(response.movies);
        nowPlayingMovies = MovieResponseModel(
          page: response.page,
          totalCount: response.totalCount,
          totalPages: response.totalPages,
          movies: moviesList,
        );
      }
      emit(NowPlayingLoaded(
        imageBaseUrl: LocalStorageHelper.getImageBaseUrl(),
        movieResponseModel: nowPlayingMovies!,
      ));

      if (page > 1) {
        /// Helps rebuild the [DotsIndicator] and provides a good user
        /// experience by scrolling into the newly loaded content
        await Future.delayed(const Duration(milliseconds: 500));
        final positionToAnimateTo =
            nowPlayingScrollController.position.maxScrollExtent *
                (page - 1) /
                page;
        nowPlayingScrollController.animateTo(
          positionToAnimateTo + 30,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeIn,
        );
      }
    } on Exception catch (e) {
      emit(HomeAlert(
        text: "$e",
      ));
    }
  }

  Future<void> _fetchTopRated({
    int page = 1,
    bool forceAPIFetch = false,
    required Emitter<HomeState> emit,
  }) async {
    emit(page == 1
        ? TopRatedLoading()
        : TopRatedLoadingMore(
            imageBaseUrl: LocalStorageHelper.getImageBaseUrl(),
            movieResponseModel: topRatedMovies!,
          ));
    final response = await moviesRepository.fetchTopRated(
        page: page, forceFetchApiData: forceAPIFetch);
    if (response != null) {
      final moviesList = topRatedMovies?.movies ?? [];
      moviesList.addAll(response.movies);
      topRatedMovies = MovieResponseModel(
        page: response.page,
        totalCount: response.totalCount,
        totalPages: response.totalPages,
        movies: moviesList,
      );
    }
    emit(TopRatedLoaded(
      imageBaseUrl: LocalStorageHelper.getImageBaseUrl(),
      movieResponseModel: topRatedMovies!,
    ));
  }
}
