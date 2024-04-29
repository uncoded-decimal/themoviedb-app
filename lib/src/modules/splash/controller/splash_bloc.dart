import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wework_challenge/src/data/repository/movies_repo.dart';
import 'package:wework_challenge/src/modules/splash/models/app_location_data_model.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final MoviesRepository moviesRepository;
  SplashBloc({
    required this.moviesRepository,
  }) : super(SplashInit()) {
    on<AppReady>(
      (event, emit) => _fetchLocation(emit),
    );
  }

  Future<bool?> _checkLocationPermissionAndServiceStatus(
      Emitter<SplashState> emit) async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        emit(const SplashToast(
          message:
              'Location Service is disabled. Please turn it on to continue using the app.',
        ));
        await Future.delayed(const Duration(seconds: 2));
        return _checkLocationPermissionAndServiceStatus(emit);
      }

      final permissionStatus = await Geolocator.requestPermission();
      if (permissionStatus == LocationPermission.always ||
          permissionStatus == LocationPermission.whileInUse) {
        /// will have no issues access device location
        return true;
      } else if (permissionStatus == LocationPermission.denied) {
        emit(const SplashToast(
          message: 'Location Permission is Needed to access our services',
        ));
        await Future.delayed(const Duration(seconds: 2));
        return _checkLocationPermissionAndServiceStatus(emit);
      } else if (permissionStatus == LocationPermission.deniedForever) {
        emit(const SplashToast(
          message:
              'Location Permission is Needed to access our services. Please go to App Settings and enable Location',
        ));
      } else {
        emit(const SplashToast(
          message:
              'There was an error fetching location. Please try again later.',
        ));
      }
    } on Exception catch (e) {
      log("SplashLog :: Exception on `_checkLocationPermissionAndServiceStatus` :: $e");
      emit(const SplashToast(
        message:
            'There was an error fetching location. Please try again later.',
      ));
    }
    return false;
  }

  Future<(String, String, Position)?> _performLocationInfoFetch(
      Emitter<SplashState> emit) async {
    try {
      final currentLocation = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        currentLocation.latitude,
        currentLocation.longitude,
      );
      log("SplashLog :: Found Placemark => ${placemarks.first.toJson()}");
      final String placeName = placemarks.first.name ?? "<...>";
      final String placeAddress =
          "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality} - ${placemarks.first.postalCode}";
      return (placeName, placeAddress, currentLocation);
    } on Exception catch (e) {
      log("SplashLog :: Exception on `_performLocationInfoFetch` :: $e");
      emit(const SplashToast(
        message:
            'There was an error fetching location. Please try again later.',
      ));
      return null;
    }
  }

  Future<void> _fetchLocation(Emitter<SplashState> emit) async {
    final allGood =
        await _checkLocationPermissionAndServiceStatus(emit) ?? false;
    if (allGood) {
      final response = await _performLocationInfoFetch(emit);
      if (response != null) {
        await _setupMoviesData(emit);
        emit(
          DataSetupComplete(
            dataModel: LocationDataModel(
              position: response.$3,
              placeName: response.$1,
              address: response.$2,
            ),
          ),
        );
      }
    } else {
      log('SplashLog :: Couldn\'t establish location service usage.');
    }
  }

  Future<void> _setupMoviesData(Emitter<SplashState> emit) async {
    await moviesRepository.fetchConfig();
    try {
      await moviesRepository.fetchNowPlaying(forceFetchApiData: true);
      await moviesRepository.fetchTopRated(forceFetchApiData: true);
    } on Exception catch (e) {
      emit(SplashToast(
        message: "$e",
      ));
    }
  }
}
