import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:heremaps/core/extensions/context_extensions.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("osm"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.gps_fixed),
        onPressed: () {},
      ),
      body: Container(
          width: context.dynamicWidth(1),
          height: context.dynamicHeight(1),
          decoration: context.gradientBackground(),
          child: const SimpleOSM()),
    );
  }
}

class SimpleOSM extends StatefulWidget {
  const SimpleOSM({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SimpleOSMState();
}

class SimpleOSMState extends State<SimpleOSM>
    with AutomaticKeepAliveClientMixin {
  late MapController controller;

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      areaLimit: const BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west: 5.9559113,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        buildOSM(),
        buildButtons(context),
      ],
    );
  }

  Positioned buildButtons(BuildContext context) {
    return Positioned(
      bottom: context.dynamicHeight(0.1),
      right: 0,
      child: SizedBox(
        child: Card(
          child: Column(
            children: [
              IconButton(
                onPressed: () async {
                  await controller.zoomIn();
                },
                icon: const Icon(Icons.zoom_in),
              ),
              Divider(
                color: Colors.grey.shade900,
                thickness: 4,
              ),
              IconButton(
                onPressed: () async {
                  await controller.zoomOut();
                },
                icon: const Icon(Icons.zoom_out),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OSMFlutter buildOSM() {
    return OSMFlutter(
      controller: controller,
      trackMyPosition: false,
      initZoom: 12,
      stepZoom: 2.0,
      minZoomLevel: 2,
      maxZoomLevel: 17,
      userLocationMarker: UserLocationMaker(
        personMarker: const MarkerIcon(
          icon: Icon(
            Icons.location_history_rounded,
            color: Colors.red,
            size: 48,
          ),
        ),
        directionArrowMarker: const MarkerIcon(
          icon: Icon(
            Icons.double_arrow,
            size: 48,
          ),
        ),
      ),
      markerOption: MarkerOption(
          defaultMarker: const MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.blue,
          size: 56,
        ),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
