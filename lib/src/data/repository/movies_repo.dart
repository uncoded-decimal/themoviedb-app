import 'package:wework_challenge/src/data/models/movie_item_model.dart';

abstract class MoviesRepository {
  /// Ensure this is called before any other repository methods
  /// are called.
  Future<void> fetchConfig();

  /// [forceFetchApiData] skips the check for api data in local
  /// storage and performs a fresh API call. When `false`, performs
  /// the check into local storage first.
  Future<MovieResponseModel?> fetchNowPlaying(
      {int page = 1, bool forceFetchApiData = false});

  /// [forceFetchApiData] skips the check for api data in local
  /// storage and performs a fresh API call. When `false`, performs
  /// the check into local storage first.
  Future<MovieResponseModel?> fetchTopRated(
      {int page = 1, bool forceFetchApiData = false});
}
