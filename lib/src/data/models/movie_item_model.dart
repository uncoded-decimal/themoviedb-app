class MovieResponseModel {
  final int page;
  final int totalCount;
  final int totalPages;
  final List<MovieItemModel> movies;

  MovieResponseModel({
    required this.page,
    required this.totalCount,
    required this.totalPages,
    required this.movies,
  });

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) {
    final moviesMapList =
        (json['results'] as List<dynamic>).map((e) => Map.from(e)).toList();
    final movies = moviesMapList
        .map((Map e) => MovieItemModel.fromJson(e.cast<String, dynamic>()))
        .toList();
    return MovieResponseModel(
      page: json["page"],
      totalCount: json['total_results'],
      totalPages: json['total_pages'],
      movies: movies,
    );
  }

  Map<String, dynamic> toJson() => {
        "page": page,
        "total_results": totalCount,
        "total_pages": totalPages,
        "results": movies.map((e) => e.toJson()).toList(),
      };
}

class MovieItemModel {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  MovieItemModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieItemModel.fromJson(Map<String, dynamic> json) => MovieItemModel(
        adult: json['adult'],
        backdropPath: json['backdrop_path'] ?? "",
        genreIds: json['genre_ids'].cast<int>(),
        id: json['id'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        popularity: json['popularity'],
        posterPath: json['poster_path'],
        releaseDate: json['release_date'],
        title: json['title'],
        video: json['video'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    data['genre_ids'] = genreIds;
    data['id'] = id;
    data['original_language'] = originalLanguage;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['release_date'] = releaseDate;
    data['title'] = title;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}
