import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Location {
  final double lng;
  final double lat;

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

Future<Location> findLocation(String address) async {
  // TODO
  // You need to get API key from Here Maps https://developer.here.com/
  // Then replace {YOUR_API_KEY} from your key below.
  // For more information please visit:
  // https://developer.here.com/documentation/geocoder/dev_guide/topics/example-geocoding-partial-address.html

  final response = await http.get(
      "https://geocoder.ls.hereapi.com/6.2/geocode.json?apiKey={YOUR_API_KEY}&searchtext=$address");

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
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return position;
}

measureDistance(double startLatitude, double startLongitude, double endLatitude,
    double endLongitude) {
  double distanceInMeters = Geolocator.distanceBetween(
      startLatitude, startLongitude, endLatitude, endLongitude);
  return distanceInMeters;
}
