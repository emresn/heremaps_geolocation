import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heremaps/screens/home/service/home_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService service;
  HomeCubit({required this.service}) : super(InitialState());

  Position? position;

  void getLocation() async {
    position = await service.getDeviceLocation();
    emit(UpdatedState());
  }

  void removePosition() {
    position = null;
    emit(UpdatedState());
  }
}

abstract class HomeState {}

class InitialState extends HomeState {}

class UpdatedState extends HomeState {}
