import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wework_challenge/src/app/misc/app_textstyles.dart';
import 'package:wework_challenge/src/data/models/movie_item_model.dart';
import 'package:wework_challenge/src/modules/home/controllers/home_bloc.dart';
import 'package:wework_challenge/src/modules/home/widgets/dots_indicator.dart';
import 'package:wework_challenge/src/modules/home/widgets/empty_list_widget.dart';
import 'package:wework_challenge/src/modules/home/widgets/now_playing_clipper.dart';
import 'package:wework_challenge/src/modules/home/widgets/title_widget.dart';
import 'package:wework_challenge/src/utils/utils.dart';

class NowPlayingSection extends StatelessWidget {
  final HomeBloc homeBloc;
  const NowPlayingSection({
    super.key,
    required this.homeBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc,
      buildWhen: (previous, current) =>
          current is NowPlayingLoading ||
          current is NowPlayingLoadingMore ||
          current is NowPlayingLoaded,
      builder: (context, state) {
        final listHeight = MediaQuery.of(context).size.height / 2.5;
        if (state is NowPlayingLoading) {
          return const _NowPlayingLoadingWidget();
        } else if (state is NowPlayingLoadingMore) {
          return _moviesListing(
            listHeight: listHeight,
            imageBaseUrl: state.imageBaseUrl,
            model: state.movieResponseModel,
            isLoadingMore: true,
            scrollController: homeBloc.nowPlayingScrollController,
          );
        } else if (state is NowPlayingLoaded) {
          return _moviesListing(
            listHeight: listHeight,
            imageBaseUrl: state.imageBaseUrl,
            model: state.movieResponseModel,
            isLoadingMore: false,
            scrollController: homeBloc.nowPlayingScrollController,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _moviesListing({
    required String imageBaseUrl,
    required MovieResponseModel model,
    required double listHeight,
    required ScrollController scrollController,
    bool isLoadingMore = false,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NowPlayingInfoWidget(
            nowPlayingCount: model.movies.length,
          ),
          const TitleWidget(title: "NOW PLAYING"),
          if (model.movies.isEmpty) const EmptyListWidget(),
          if (model.movies.isNotEmpty)
            SizedBox(
              height: listHeight,
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.only(right: 16),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: model.movies.length + 1,
                itemBuilder: (context, index) {
                  if (index < model.movies.length) {
                    final item = model.movies.elementAt(index);
                    return _MovieTile(
                      movie: item,
                      imageBaseUrl: imageBaseUrl,
                    );
                  } else {
                    if (isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: _ItemShimmer(),
                      );
                    } else if (model.page < model.totalPages) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: TextButton.icon(
                          onPressed: () {
                            homeBloc.add(NowplayingFetchMore());
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Fetch More"),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                },
              ),
            ),
          if (model.movies.isNotEmpty)
            DotsIndicator(
              moviesList: model.movies,
              controller: scrollController,
            ),
        ],
      );
}

class _MovieTile extends StatelessWidget {
  final String imageBaseUrl;
  final MovieItemModel movie;
  const _MovieTile({
    required this.movie,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final tileWidth = MediaQuery.of(context).size.width * 0.75;
    // final tileHeight = MediaQuery.of(context).size.height * 0.5;
    return AspectRatio(
      aspectRatio: 3 / 3.2,
      child: Container(
        width: tileWidth,
        padding: const EdgeInsets.only(left: 16.0),
        child: Stack(
          fit: StackFit.loose,
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipPath(
                clipBehavior: Clip.hardEdge,
                clipper: NowPlayingClipper(),
                child: CachedNetworkImage(
                  width: tileWidth,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  imageUrl: "$imageBaseUrl${movie.posterPath}",
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: _startsInfo(),
            ),
            Align(
              alignment: Alignment.topRight,
              child: _statsRow(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _movieInfo(tileWidth),
            )
          ],
        ),
      ),
    );
  }

  Widget _startsInfo() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              movie.voteAverage.toStringAsFixed(2),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.star,
              size: 24,
              color: Colors.amber.shade700,
            ),
          ],
        ),
      );

  Widget _statsRow() => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade500.withOpacity(0.4),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  movie.voteCount.toString(),
                  style: AppTextStyles.regular12NS(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade500.withOpacity(0.4),
            ),
            child: const Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      );

  Widget _movieInfo(double width) => ClipPath(
        clipper: NowPlayingClipper(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 32, 16),
            // alignment: Alignment.bottomCenter,
            // constraints: BoxConstraints(maxHeight: width / 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withOpacity(0.8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: width * 0.45),
                    const Icon(
                      Icons.place_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      getLanguageName(movie.originalLanguage),
                      style: AppTextStyles.regular12NS(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  movie.title,
                  style: AppTextStyles.medium12NS(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      getLocalSvg("calendar_white"),
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        movie.overview,
                        style: AppTextStyles.regular10NS(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${movie.voteCount} Votes",
                  style: AppTextStyles.regular16NS(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
}

class _NowPlayingInfoWidget extends StatelessWidget {
  final int nowPlayingCount;
  const _NowPlayingInfoWidget({
    required this.nowPlayingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          ClipPath(
            clipBehavior: Clip.hardEdge,
            clipper: NowPlayingClipper(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 48, 48, 16),
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xffaa9ba5),
                    Color(0xffa2919e),
                  ],
                  center: Alignment.center,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We Movies",
                    style: AppTextStyles.medium20NS(),
                  ),
                  Text(
                    "$nowPlayingCount Movies are loaded in now playing",
                    style: AppTextStyles.regular12NS(),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Text(
                _getDate(),
                style: AppTextStyles.medium12NS(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDate() {
    final date = DateFormat("dd MMM yyyy").format(DateTime.now());
    String? ext;
    final lastDateDigit = int.parse(date.split(' ').first) % 10;
    switch (lastDateDigit) {
      case 1:
        ext = "st";
        break;
      case 2:
        ext = "nd";
        break;
      case 3:
        ext = "rd";
        break;
      default:
        ext = "th";
    }
    final dateToPrint = date.split(' ');
    dateToPrint[0] = "${dateToPrint[0]}$ext";
    return dateToPrint.join(' ').toUpperCase();
  }
}

class _NowPlayingLoadingWidget extends StatelessWidget {
  const _NowPlayingLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, index) => const _ItemShimmer(),
    );
  }
}

class _ItemShimmer extends StatelessWidget {
  const _ItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey.shade200,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
