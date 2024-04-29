import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wework_challenge/src/app/misc/app_colors.dart';
import 'package:wework_challenge/src/app/misc/app_textstyles.dart';
import 'package:wework_challenge/src/modules/home/controllers/home_bloc.dart';
import 'package:wework_challenge/src/modules/home/widgets/now_playing_section.dart';
import 'package:wework_challenge/src/modules/home/widgets/top_rated_section.dart';
import 'package:wework_challenge/src/modules/splash/models/app_location_data_model.dart';
import 'package:wework_challenge/src/utils/utils.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as LocationDataModel;
    final homeBloc = BlocProvider.of<HomeBloc>(context)
      ..add(SetupHome(locationDataModel: routeArgs));
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.homeGradientStart,
            AppColors.homeGradientEnd,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _getAppBar(homeBloc),
        body: _getHomeBody(homeBloc),
        bottomNavigationBar: _getBottomNavBar(homeBloc),
        floatingActionButton: _getFAB(homeBloc),
      ),
    );
  }

  Widget _getHomeBody(HomeBloc homeBloc) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeAlert) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.text),
            ),
          );
        }
      },
      child: Column(
        children: [
          _searchBar(homeBloc),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                homeBloc.add(RefreshHomeData());
              },
              child: SingleChildScrollView(
                controller: homeBloc.homeScrollController,
                child: Column(
                  children: [
                    NowPlayingSection(homeBloc: homeBloc),
                    TopRatedSection(homeBloc: homeBloc),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar? _getAppBar(HomeBloc homeBloc) {
    return AppBar(
      surfaceTintColor: const Color(0xffaf96ac),
      automaticallyImplyLeading: false,
      title: BlocBuilder<HomeBloc, HomeState>(
        bloc: homeBloc,
        buildWhen: (previous, current) =>
            previous is HomeInit && current is LocationDataSetupComplete,
        builder: (_, state) {
          if (state is LocationDataSetupComplete) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.place_outlined,
                          size: 20,
                        ),
                      ),
                      TextSpan(
                        text: state.name,
                        style: AppTextStyles.bold16NS(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Text(
                  state.address,
                  style: AppTextStyles.regular12NS(color: Colors.grey.shade800),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: SvgPicture.asset(
            getLocalSvg('logo'),
            height: 40,
            width: 40,
          ),
        ),
      ],
    );
  }

  Widget _searchBar(HomeBloc homeBloc) {
    return Card(
      shape: const StadiumBorder(),
      margin: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          homeBloc.add(SearchKeyAdded(key: value));
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Search movies by name....",
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _getBottomNavBar(HomeBloc homeBloc) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc,
      buildWhen: (previous, current) =>
          current is HomeInit || current is LocationDataSetupComplete,
      builder: (context, state) {
        if (state is LocationDataSetupComplete) {
          return BottomNavigationBar(
            items: [
              {
                "graphic": "logo",
                "title": "We Movies",
              },
              {
                "graphic": "explore_grey",
                "title": "Explore",
              },
              {
                "graphic": "calendar_grey",
                "title": "Upcoming",
              }
            ]
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      height: 18,
                      fit: BoxFit.cover,
                      getLocalSvg(e["graphic"]!),
                    ),
                    label: e["title"],
                  ),
                )
                .toList(),
            currentIndex: 0,
            onTap: (v) {
              if (v != 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("We're working on that..."),
                  ),
                );
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _getFAB(HomeBloc homeBloc) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc,
      buildWhen: (previous, current) => current is ScrollSenseState,
      builder: (context, state) {
        if (state is ScrollSenseState && state.showScrollUp) {
          return FloatingActionButton(
            child: const Icon(
              Icons.keyboard_arrow_up,
            ),
            onPressed: () {
              homeBloc.homeScrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeIn,
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
