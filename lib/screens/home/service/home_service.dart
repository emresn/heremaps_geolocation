import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heremaps/core/init/location_manager.dart';
import 'package:heremaps/core/model/location_model.dart';

abstract class IHomeService {
  final LocationManager locationManager;
  final Dio dio;

  IHomeService({required this.locationManager, required this.dio});

  Future<LocationModel> findLocation(String? address);
}

class HomeService extends IHomeService {
  HomeService({required LocationManager locationManager, required Dio dio})
      : super(locationManager: locationManager, dio: dio);

  @override
  Future<LocationModel> findLocation(String? address) async {
    String apiKey = dotenv.env['HERE_API'].toString();

    final response = await dio.get(
        "https://geocoder.ls.hereapi.com/6.2/geocode.json?apiKey={$apiKey}&searchtext=$address");

    if (response.statusCode == 200) {
      return LocationModel.fromJson(json.decode(response.data));
    } else {
      throw Exception('Failed to retrieve data');
    }
  }

  Future<Position> getDeviceLocation() async {
    Position position = await locationManager.determinePosition();

    return position;
  }

  double measureDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return distanceInMeters;
  }
}
