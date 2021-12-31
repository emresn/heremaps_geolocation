// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'here_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HereResponseModel _$HereResponseModelFromJson(Map<String, dynamic> json) {
  Map<String, dynamic> position = json['position'];
  position['id'] = json['id'];
  position['longitude'] = json['position']['lng'];
  position['latitude'] = json['position']['lat'];
  position['timestamp'] = DateTime.now().toString();

  return HereResponseModel(
    json['title'] as String?,
    json['id'] as String?,
    json['resultType'] as String?,
    json['localityType'] as String?,
    json['address'] == null
        ? null
        : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    json['position'] == null ? null : LocationModel.fromJson(position),
    json['mapView'] == null
        ? null
        : MapViewModel.fromJson(json['mapView'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HereResponseModelToJson(HereResponseModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'resultType': instance.resultType,
      'localityType': instance.localityType,
      'address': instance.address,
      'position': instance.position,
      'mapView': instance.mapView,
    };
