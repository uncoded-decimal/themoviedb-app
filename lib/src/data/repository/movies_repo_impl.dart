import 'dart:developer';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wework_challenge/src/data/local/local_storage.dart';
import 'package:wework_challenge/src/data/models/movie_item_model.dart';
import 'package:wework_challenge/src/data/remote/movies_remote_source_impl.dart';
import 'package:wework_challenge/src/data/repository/movies_repo.dart';
import 'package:wework_challenge/src/utils/utils.dart';

class MoviesRepositoryImpl extends MoviesRepository {
  final _moviesSource = MoviesRemoteSourceImpl();

  @override
  Future<MovieResponseModel?> fetchNowPlaying({
    int page = 1,
    bool forceFetchApiData = false,
  }) async {
    if (!forceFetchApiData && page == 1) {
      final locallySavedInfo = LocalStorageHelper.getNowPlayingPage1Data();
      if (locallySavedInfo != null) {
        return locallySavedInfo;
      }
    }
    final connected = await isConnected();
    if (connected) {
      final nowPlayingResponse =
          await _moviesSource.fetchNowPlaying(page: page);
      if (nowPlayingResponse != null && page == 1) {
        LocalStorageHelper.setNowPlayingPage1Data(nowPlayingResponse);
        for (final item in nowPlayingResponse.movies.getRange(0, 2)) {
          await _precacheImage(item.posterPath);
        }
      }
      return nowPlayingResponse;
    } else {
      throw Exception("No Internet Connection");
    }
  }

  @override
  Future<MovieResponseModel?> fetchTopRated({
    int page = 1,
    bool forceFetchApiData = false,
  }) async {
    if (!forceFetchApiData && page == 1) {
      final locallySavedInfo = LocalStorageHelper.getTopRatedPage1Data();
      if (locallySavedInfo != null) {
        return locallySavedInfo;
      }
    }
    final connected = await isConnected();
    if (connected) {
      final topRatedResponse = await _moviesSource.fetchTopRated(page: page);
      if (topRatedResponse != null && page == 1) {
        LocalStorageHelper.setTopRatedPage1Data(topRatedResponse);
        for (final item in topRatedResponse.movies.getRange(0, 2)) {
          await _precacheImage(item.posterPath);
        }
      }
      return topRatedResponse;
    } else {
      throw Exception('No Internet Connection');
    }
  }

  @override
  Future<void> fetchConfig() async {
    final configResponse = await _moviesSource.fetchConfig();
    if (configResponse != null) {
      LocalStorageHelper.setImageBaseUrl(
          "${configResponse.secureImageBaseUrl}${configResponse.posterSizes.elementAt(configResponse.posterSizes.length - 2)}");
    }
  }

  ///Pre-cache for a smooth loading experience
  Future<void> _precacheImage(String posterPath) async {
    final path = "${LocalStorageHelper.getImageBaseUrl()}$posterPath";
    try {
      log("Pre-CachingLog :: Attempt at pre-caching $path");
      await DefaultCacheManager().downloadFile(path);
    } catch (e) {
      log("Pre-CachingLog :: Attempted caching of $path threw Exception - $e");
    }
  }
}
