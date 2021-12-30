import 'package:hive_flutter/hive_flutter.dart';

abstract class ICacheManager<T> {
  final String key;
  Box<T>? box;

  ICacheManager(this.key);
  Future<void> init() async {
    registerAdapters();
    if (!(box?.isOpen ?? false)) {
      box = await Hive.openBox(key);
    }
  }

  void registerAdapters();

  Future<void> addItems(List<T> items);
  Future<void> putItems(List<T> items);
  Future<void> putItem(String key, T item);
  T? getItem(String key);
  List<T>? getValues({String options = ""});

  Future<void> removeItem(String key);
  Future<void> clearAll() async {
    await box?.clear();
  }
}
