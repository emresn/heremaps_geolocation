import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  final String? label;
  final String? countryCode;
  final String? countryName;
  final String? state;
  final String? county;
  final String? city;
  final String? district;
  final String? postalCode;

  AddressModel(this.label, this.countryCode, this.countryName, this.state,
      this.county, this.city, this.district, this.postalCode);

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
