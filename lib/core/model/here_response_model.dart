import 'package:heremaps/core/model/address_model.dart';
import 'package:heremaps/core/model/location_model.dart';
import 'package:heremaps/core/model/map_view_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'here_response_model.g.dart';

@JsonSerializable()
class HereResponseModel {
  final String? title;
  final String? id;
  final String? resultType;
  final String? localityType;
  final AddressModel? address;
  final LocationModel? position;
  final MapViewModel? mapView;

  HereResponseModel(this.title, this.id, this.resultType, this.localityType,
      this.address, this.position, this.mapView);

  factory HereResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HereResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$HereResponseModelToJson(this);
}
