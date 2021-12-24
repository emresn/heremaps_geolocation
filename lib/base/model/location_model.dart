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
