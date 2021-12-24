import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heremaps/base/extensions/context_extensions.dart';
import 'package:heremaps/base/init/location_manager.dart';
import 'package:heremaps/screens/home/cubit/home_cubit.dart';
import 'package:heremaps/screens/home/service/home_service.dart';
import 'package:heremaps/screens/home/subviews/position_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
          service: HomeService(
              locationManager: LocationManager.instance, dio: Dio())),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          Position? position = BlocProvider.of<HomeCubit>(context).position;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Home Page"),
            ),
            body: Container(
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
                  Padding(
                    padding: Helpers.padding,
                    child: ElevatedButton.icon(
                        onPressed: () =>
                            BlocProvider.of<HomeCubit>(context).getLocation(),
                        icon: const Icon(Icons.gps_fixed),
                        label: const Text("Find My Location")),
                  ),
                  if (position != null) PositionWidget(position: position)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
