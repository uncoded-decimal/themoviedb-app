class ConfigModel {
  final String secureImageBaseUrl;
  final List<String> posterSizes;

  ConfigModel({
    required this.secureImageBaseUrl,
    required this.posterSizes,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        secureImageBaseUrl: json['images']['secure_base_url'],
        posterSizes: (json['images']['poster_sizes'] as List).cast<String>(),
      );
}
