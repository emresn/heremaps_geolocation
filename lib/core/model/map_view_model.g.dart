// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapViewModel _$MapViewModelFromJson(Map<String, dynamic> json) => MapViewModel(
      (json['west'] as num?)?.toDouble(),
      (json['south'] as num?)?.toDouble(),
      (json['east'] as num?)?.toDouble(),
      (json['north'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MapViewModelToJson(MapViewModel instance) =>
    <String, dynamic>{
      'west': instance.west,
      'south': instance.south,
      'east': instance.east,
      'north': instance.north,
    };
