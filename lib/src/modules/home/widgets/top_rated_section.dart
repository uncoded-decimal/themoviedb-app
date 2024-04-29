import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wework_challenge/src/app/misc/app_textstyles.dart';
import 'package:wework_challenge/src/data/models/movie_item_model.dart';
import 'package:wework_challenge/src/modules/home/controllers/home_bloc.dart';
import 'package:wework_challenge/src/modules/home/widgets/empty_list_widget.dart';
import 'package:wework_challenge/src/modules/home/widgets/title_widget.dart';
import 'package:wework_challenge/src/utils/utils.dart';

class TopRatedSection extends StatelessWidget {
  final HomeBloc homeBloc;
  const TopRatedSection({
    super.key,
    required this.homeBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const TitleWidget(title: "TOP RATED"),
        Flexible(
          child: BlocBuilder<HomeBloc, HomeState>(
            bloc: homeBloc,
            buildWhen: (previous, current) =>
                current is TopRatedLoading ||
                current is TopRatedLoadingMore ||
                current is TopRatedLoaded,
            builder: (context, state) {
              if (state is TopRatedLoading) {
                return const _TopRatedLoadingWidget();
              } else if (state is TopRatedLoadingMore) {
                return _getListing(
                  state.imageBaseUrl,
                  state.movieResponseModel,
                  isLoadingMore: true,
                );
              } else if (state is TopRatedLoaded) {
                return _getListing(
                  state.imageBaseUrl,
                  state.movieResponseModel,
                  isLoadingMore: false,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _getListing(
    String imageBaseUrl,
    MovieResponseModel model, {
    bool isLoadingMore = false,
  }) {
    if (model.movies.isEmpty) {
      return const EmptyListWidget();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: model.movies.length + 1,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index < model.movies.length) {
          return _MovieItem(
            imageBaseUrl: imageBaseUrl,
            movie: model.movies.elementAt(index),
          );
        } else {
          if (isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
              child: _ItemShimmer(),
            );
          } else if (model.page < model.totalPages) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton.icon(
                onPressed: () {
                  homeBloc.add(TopRatedFetchMore());
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
    );
  }
}

class _MovieItem extends StatelessWidget {
  final String imageBaseUrl;
  final MovieItemModel movie;
  const _MovieItem({
    required this.imageBaseUrl,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _posterSection()),
              Expanded(child: _infoSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _posterSection() => Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: "$imageBaseUrl${movie.posterPath}",
              width: double.infinity,
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade600.withOpacity(0.8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.visibility_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  Text(
                    NumberFormat.compact()
                        .format(movie.voteCount)
                        .toUpperCase(),
                    style: AppTextStyles.regular10NS(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _infoSection() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              movie.title,
              style: AppTextStyles.semiBold14NS(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(
                  getLocalSvg("calendar_grey"),
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    movie.overview,
                    style:
                        AppTextStyles.medium10NS(color: Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${NumberFormat.compact().format(movie.voteCount)} Votes | ${movie.voteAverage.toStringAsFixed(2)}",
                  style:
                      AppTextStyles.semiBold16NS(color: Colors.grey.shade600),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.star,
                  size: 24,
                  color: Colors.amber.shade700,
                ),
              ],
            ),
          ],
        ),
      );
}

class _TopRatedLoadingWidget extends StatelessWidget {
  const _TopRatedLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      shrinkWrap: true,
      children: const [
        _ItemShimmer(),
        SizedBox(height: 8),
        _ItemShimmer(),
      ],
    );
  }
}

class _ItemShimmer extends StatelessWidget {
  const _ItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
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
