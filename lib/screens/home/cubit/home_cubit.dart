import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heremaps/core/init/cache_manager/i_cache_manager.dart';
import 'package:heremaps/core/model/location_model.dart';
import 'package:heremaps/screens/home/service/home_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService service;
  final ICacheManager<LocationModel> cacheManager;

  Position? position;
  List<LocationModel> locationList = [];

  HomeCubit({required this.service, required this.cacheManager})
      : super(InitialState());

  void getAllLocationsFromCache() async {
    await cacheManager.init();
    locationList = cacheManager.getValues() ?? [];
    emit(UpdatedState());
  }

  void addPositionToLocationCacheList(LocationModel locationModel) async {
    await cacheManager.init();
    await cacheManager.putItem(locationModel.id, locationModel);
  }

  void addPositiontoList(Position? position) {
    if (position != null) {
      LocationModel locationModel = LocationModel.fromPosition(position);
      locationList.isEmpty
          ? locationList.add(locationModel)
          : locationList.insert(0, locationModel);
      addPositionToLocationCacheList(locationModel);
    }
  }

  void getLocation() async {
    position = await service.getDeviceLocation();
    addPositiontoList(position);
    emit(UpdatedState());
  }

  void removePosition(LocationModel locationModel) async {
    locationList.removeWhere((element) => element.id == locationModel.id);
    await cacheManager.init();
    await cacheManager.removeItem(locationModel.id);
    position = null;
    emit(UpdatedState());
  }
}

abstract class HomeState {}

class InitialState extends HomeState {}

class UpdatedState extends HomeState {}
