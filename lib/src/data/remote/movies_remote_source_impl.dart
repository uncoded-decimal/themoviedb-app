import 'package:wework_challenge/src/app/misc/api_constants.dart';
import 'package:wework_challenge/src/data/models/config_model.dart';
import 'package:wework_challenge/src/data/models/movie_item_model.dart';
import 'package:wework_challenge/src/data/remote/movies_remote_source.dart';
import 'package:wework_challenge/src/rest/rest_client.dart';

class MoviesRemoteSourceImpl implements MoviesRemoteSource {
  @override
  Future<MovieResponseModel?> fetchNowPlaying({int page = 1}) async {
    final response = await RestClient.get(
      nowPlayingPath,
      queryParams: {
        "language": "en-US",
        "page": page,
      },
    );
    if (response != null) {
      return MovieResponseModel.fromJson(response);
    }
    return null;
  }

  @override
  Future<MovieResponseModel?> fetchTopRated({int page = 1}) async {
    final response = await RestClient.get(
      topRatedPath,
      queryParams: {
        "language": "en-US",
        "page": page,
      },
    );
    if (response != null) {
      return MovieResponseModel.fromJson(response);
    }
    return null;
  }

  @override
  Future<ConfigModel?> fetchConfig() async {
    final response = await RestClient.get(configPath);
    if (response != null) {
      return ConfigModel.fromJson(response);
    }
    return null;
  }
}
