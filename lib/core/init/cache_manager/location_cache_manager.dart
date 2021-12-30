import 'package:heremaps/core/constants/hive_constants.dart';
import 'package:heremaps/core/model/location_model.dart';
import 'package:hive_flutter/adapters.dart';

import 'i_cache_manager.dart';

class LocationCacheManager extends ICacheManager<LocationModel> {
  LocationCacheManager(String key) : super(key);

  @override
  Future<void> addItems(List<LocationModel> items) async {
    await box?.addAll(items);
  }

  @override
  LocationModel? getItem(String key) {
    return box?.get(key);
  }

  @override
  List<LocationModel>? getValues({String options = ""}) {
    List<LocationModel>? locationList = box?.values.toList();

    locationList?.sort((a, b) {
      DateTime dateA = a.timestamp;
      DateTime dateB = b.timestamp;

      return dateA.compareTo(dateB);
    });

    return locationList;
  }

  @override
  Future<void> putItem(String key, LocationModel item) async {
    await box?.put(key, item);
  }

  @override
  Future<void> putItems(List<LocationModel> items) async {
    await box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e.id, e))));
  }

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveConstants.locationModelId)) {
      Hive.registerAdapter(LocationModelAdapter());
    }
  }

  @override
  Future<void> removeItem(String key) async {
    await box?.delete(key);
  }
}
