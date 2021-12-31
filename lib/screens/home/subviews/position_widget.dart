import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heremaps/core/components/snackbar_widget.dart';
import 'package:heremaps/core/extensions/context_extensions.dart';
import 'package:heremaps/core/model/location_model.dart';
import 'package:heremaps/screens/home/cubit/home_cubit.dart';
import 'package:intl/intl.dart';

class PositionWidget extends StatelessWidget {
  final List<LocationModel> locationList;

  const PositionWidget({
    Key? key,
    required this.locationList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy hh:mm');

    return SizedBox(
      height: context.dynamicHeight(0.4),
      child: ListView.builder(
        itemCount: locationList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: Helpers.padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildAllRows(context, index, dateFormat),
                  buildButtons(index, context)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Column buildButtons(int index, BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(
                  text:
                      "Latitude: ${locationList[index].latitude}, Longitude: ${locationList[index].longitude}"));
              SnackBarWidget(context).show("success", "Copied");
            },
            icon: const Icon(Icons.copy)),
        IconButton(
            onPressed: () {
              BlocProvider.of<HomeCubit>(context)
                  .removePosition(locationList[index]);
              SnackBarWidget(context).show("danger", "Removed");
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
            ))
      ],
    );
  }

  Expanded buildAllRows(
      BuildContext context, int index, DateFormat dateFormat) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildRow(context, "Latitude: ",
              locationList[index].latitude.toStringAsFixed(3)),
          buildRow(context, "Longitude: ",
              locationList[index].longitude.toStringAsFixed(3)),
          buildRow(context, "Time: ",
              dateFormat.format(locationList[index].timestamp)),
        ],
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
