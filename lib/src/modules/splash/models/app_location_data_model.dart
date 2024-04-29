import 'package:geolocator/geolocator.dart';

class LocationDataModel {
  final Position position;
  final String placeName;
  final String address;

  LocationDataModel({
    required this.position,
    required this.placeName,
    required this.address,
  });
}
