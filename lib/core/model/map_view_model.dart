import 'package:json_annotation/json_annotation.dart';

part 'map_view_model.g.dart';

@JsonSerializable()
class MapViewModel {
  final double? west;
  final double? south;
  final double? east;
  final double? north;

  MapViewModel(this.west, this.south, this.east, this.north);

  factory MapViewModel.fromJson(Map<String, dynamic> json) =>
      _$MapViewModelFromJson(json);

  Map<String, dynamic> toJson() => _$MapViewModelToJson(this);
}
