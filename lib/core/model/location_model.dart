import 'package:geolocator/geolocator.dart';
import 'package:heremaps/core/constants/hive_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'location_model.g.dart';

@HiveType(typeId: HiveConstants.locationModelId)
@JsonSerializable()
class LocationModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double longitude;
  @HiveField(2)
  final double latitude;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final double? altitude;
  @HiveField(5)
  final double? accuracy;
  @HiveField(6)
  final double? speed;
  @HiveField(7)
  final double? speedAccuracy;

  LocationModel(
      {required this.id,
      required this.longitude,
      required this.latitude,
      required this.timestamp,
      this.altitude,
      this.accuracy,
      this.speed,
      this.speedAccuracy});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  factory LocationModel.fromPosition(Position position) {
    var uuid = const Uuid();

    return LocationModel(
        id: uuid.v1(),
        longitude: position.longitude,
        latitude: position.latitude,
        timestamp: position.timestamp ?? DateTime.now(),
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
        speedAccuracy: position.speedAccuracy);
  }
}
