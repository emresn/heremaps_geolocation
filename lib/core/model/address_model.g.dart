// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      json['label'] as String?,
      json['countryCode'] as String?,
      json['countryName'] as String?,
      json['state'] as String?,
      json['county'] as String?,
      json['city'] as String?,
      json['district'] as String?,
      json['postalCode'] as String?,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'countryCode': instance.countryCode,
      'countryName': instance.countryName,
      'state': instance.state,
      'county': instance.county,
      'city': instance.city,
      'district': instance.district,
      'postalCode': instance.postalCode,
    };
