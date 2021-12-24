import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heremaps/base/components/snackbar_widget.dart';
import 'package:heremaps/base/extensions/context_extensions.dart';
import 'package:heremaps/screens/home/cubit/home_cubit.dart';

class PositionWidget extends StatelessWidget {
  const PositionWidget({
    Key? key,
    required this.position,
  }) : super(key: key);

  final Position position;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: Helpers.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  buildRow(context, "Latitude: ",
                      position.latitude.toStringAsFixed(3)),
                  buildRow(context, "Longitude: ",
                      position.longitude.toStringAsFixed(3)),
                  buildRow(context, "Altitude: ", position.altitude.toString()),
                  buildRow(context, "Accuracy: ", position.accuracy.toString()),
                ],
              ),
            ),
            Padding(
              padding: Helpers.paddingHorizontal,
              child: Column(
                children: [
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text:
                                "Latitude: ${position.latitude}, Longitude: ${position.longitude}"));
                        SnackBarWidget(context).show("success", "Copied");
                      },
                      icon: const Icon(Icons.copy)),
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<HomeCubit>(context).removePosition();
                        SnackBarWidget(context).show("danger", "Removed");
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.red,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.b1(),
        ),
        Text(value.toString()),
      ],
    );
  }
}
