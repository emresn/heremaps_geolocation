import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heremaps/core/constants/hive_constants.dart';
import 'package:heremaps/core/extensions/context_extensions.dart';
import 'package:heremaps/core/init/cache_manager/location_cache_manager.dart';
import 'package:heremaps/core/init/location_manager.dart';
import 'package:heremaps/core/model/here_response_model.dart';
import 'package:heremaps/core/model/location_model.dart';
import 'package:heremaps/screens/home/cubit/home_cubit.dart';
import 'package:heremaps/screens/home/service/home_service.dart';
import 'package:heremaps/screens/home/subviews/here_location_widget.dart';
import 'package:heremaps/screens/home/subviews/position_widget.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
          formKey: formKey,
          addressController: addressController,
          cacheManager: LocationCacheManager(HiveConstants.locationCacheKey),
          service: HomeService(
              locationManager: LocationManager.instance, dio: Dio())),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is InitialState) {
            BlocProvider.of<HomeCubit>(context).getAllLocationsFromCache();
          }

          List<LocationModel> locationList =
              BlocProvider.of<HomeCubit>(context).locationList;

          List<HereResponseModel> hereResponses =
              BlocProvider.of<HomeCubit>(context).hereResponses;

          return Scaffold(
            appBar: AppBar(
              title: const Text("Home Page"),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: context.dynamicWidth(1),
                height: context.dynamicHeight(1),
                decoration: context.gradientBackground(),
                child: Wrap(
                  runSpacing: Helpers.spaceSmall,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.lime.shade300,
                          size: 52,
                        ),
                        Text(
                          "Geolocator",
                          style: TextStyle(color: Colors.lime.shade200),
                          textScaleFactor: 3,
                        ),
                      ],
                    ),
                    Form(
                      key: formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: context.dynamicWidth(0.7),
                            child: Padding(
                              padding: Helpers.paddingHorizontal,
                              child: TextFormField(
                                keyboardType: TextInputType.streetAddress,
                                controller: addressController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  filled: true,
                                  fillColor: Colors.white,
                                  label: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Padding(
                                      padding: Helpers.padding,
                                      child: Text(
                                        "Search an address",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: Center(
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  splashRadius: 24,
                                  onPressed: () {
                                    BlocProvider.of<HomeCubit>(context)
                                        .searchAddress(addressController.text);
                                  },
                                  color: Colors.black,
                                  icon: const Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hereResponses.isNotEmpty)
                      HereLocationWidget(hereResponses: hereResponses),
                    Padding(
                      padding: Helpers.padding,
                      child: ElevatedButton.icon(
                          onPressed: () =>
                              BlocProvider.of<HomeCubit>(context).getLocation(),
                          icon: const Icon(Icons.gps_fixed),
                          label: const Text("Find My Location")),
                    ),
                    Padding(
                      padding: Helpers.padding,
                      child: ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.of(context).pushNamed("/mapView"),
                          icon: const Icon(Icons.map),
                          label: const Text("Show Map")),
                    ),
                    if (locationList.isNotEmpty)
                      PositionWidget(
                          locationList:
                              BlocProvider.of<HomeCubit>(context).locationList)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
