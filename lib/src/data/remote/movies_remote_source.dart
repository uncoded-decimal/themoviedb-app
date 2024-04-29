import 'package:wework_challenge/src/data/models/config_model.dart';
import 'package:wework_challenge/src/data/models/movie_item_model.dart';

abstract class MoviesRemoteSource {
  Future<MovieResponseModel?> fetchNowPlaying({int page = 1});
  Future<MovieResponseModel?> fetchTopRated({int page = 1});
  Future<ConfigModel?> fetchConfig();
}
