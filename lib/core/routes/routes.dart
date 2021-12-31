import 'package:flutter/material.dart';
import 'package:heremaps/screens/home/view/home_view.dart';
import 'package:heremaps/screens/map/map_view.dart';

class Routes {
  BuildContext context;
  Routes({required this.context});

  Map<String, WidgetBuilder> namedRoutes() {
    return {
      "/": (BuildContext context) => HomeView(),
      "/mapView": (BuildContext context) => const MapView(),
    };
  }
}
