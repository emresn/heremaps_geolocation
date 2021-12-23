import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Location {
  final double? lng;
  final double? lat;

  Location({this.lng, this.lat});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lng: json['Response']['View'][0]['Result'][0]['Location']
          ['DisplayPosition']['Longitude'],
      lat: json['Response']['View'][0]['Result'][0]['Location']
          ['DisplayPosition']['Latitude'],
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<Location> findLocation(String? address) async {
  // You need to get API key from Here Maps https://developer.here.com/
  // Then replace {YOUR_API_KEY} from your key below.
  // For more information please visit:
  // https://developer.here.com/documentation/geocoder/dev_guide/topics/example-geocoding-partial-address.html

  String apiKey = dotenv.env['HERE_API'].toString();

  final response = await http.get(Uri.dataFromString(
      "https://geocoder.ls.hereapi.com/6.2/geocode.json?apiKey={$apiKey}&searchtext=$address"));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return Location.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to retrieve data');
  }
}

getDeviceLocation() async {
  Position position = await _determinePosition();

  return position;
}

measureDistance(double startLatitude, double startLongitude, double endLatitude,
    double endLongitude) {
  double distanceInMeters = Geolocator.distanceBetween(
      startLatitude, startLongitude, endLatitude, endLongitude);
  return distanceInMeters;
}
