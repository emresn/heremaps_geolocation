import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heremaps/core/init/location_manager.dart';
import 'package:heremaps/core/model/here_response_model.dart';

abstract class IHomeService {
  final LocationManager locationManager;
  final Dio dio;

  IHomeService({required this.locationManager, required this.dio});

  Future<List<HereResponseModel>> findLocationWithAddress(String address);
}

class HomeService extends IHomeService {
  HomeService({required LocationManager locationManager, required Dio dio})
      : super(locationManager: locationManager, dio: dio);

  @override
  Future<List<HereResponseModel>> findLocationWithAddress(
      String address) async {
    String addrressMerged = address.replaceAll(" ", "+").trim();
    String apiKey = dotenv.env['HERE_API'].toString();

    final response = await dio.get(
        "https://geocode.search.hereapi.com/v1/geocode?q=$addrressMerged&apiKey=$apiKey");

    if (response.statusCode == 200) {
      final responseData = response.data["items"] as List;
      List<HereResponseModel> hereResponses = [];

      for (var i = 0; i < responseData.length; i++) {
        hereResponses.add(HereResponseModel.fromJson(responseData[i]));
      }

      return hereResponses;
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
