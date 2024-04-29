import 'package:hive/hive.dart';
import 'package:wework_challenge/src/data/local/storage_keys.dart';
import 'package:wework_challenge/src/data/models/movie_item_model.dart';

class LocalStorageHelper {
  static final _box = Hive.box('we_movies');

  static void setImageBaseUrl(String baseUrl) {
    _box.put(StorageKeys.imageBaseUrl, baseUrl);
  }

  static String getImageBaseUrl() {
    return _box.get(StorageKeys.imageBaseUrl);
  }

  static void setNowPlayingPage1Data(MovieResponseModel responseModel) {
    _box.put(StorageKeys.nowPlayingData, responseModel.toJson());
  }

  static void setTopRatedPage1Data(MovieResponseModel responseModel) {
    _box.put(StorageKeys.topRatedData, responseModel.toJson());
  }

  static MovieResponseModel? getNowPlayingPage1Data() {
    final Map? res = _box.get(StorageKeys.nowPlayingData);
    return res != null
        ? MovieResponseModel.fromJson(res.cast<String, dynamic>())
        : null;
  }

  static MovieResponseModel? getTopRatedPage1Data() {
    final Map? res = _box.get(StorageKeys.topRatedData);
    return res != null
        ? MovieResponseModel.fromJson(res.cast<String, dynamic>())
        : null;
  }
}
