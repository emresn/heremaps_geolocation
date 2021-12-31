import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heremaps/core/components/snackbar_widget.dart';
import 'package:heremaps/core/extensions/context_extensions.dart';
import 'package:heremaps/core/model/here_response_model.dart';
import 'package:heremaps/screens/home/cubit/home_cubit.dart';

class HereLocationWidget extends StatelessWidget {
  final List<HereResponseModel> hereResponses;

  const HereLocationWidget({
    Key? key,
    required this.hereResponses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${hereResponses.length} address",
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          height: context.dynamicHeight(0.4),
          child: ListView.builder(
            itemCount: hereResponses.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: Helpers.padding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildAllRows(index, context),
                      buildButtons(index, context)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column buildButtons(int index, BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              if (hereResponses[index].position != null) {
                Clipboard.setData(ClipboardData(
                    text:
                        "Latitude: ${hereResponses[index].position!.latitude}, Longitude: ${hereResponses[index].position!.longitude}"));
                SnackBarWidget(context).show("success", "Copied");
              }
            },
            icon: const Icon(Icons.copy)),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.place,
              color: Colors.indigo.shade600,
            )),
        IconButton(
            onPressed: () {
              BlocProvider.of<HomeCubit>(context)
                  .removeHereResponseFromList(index);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
            ))
      ],
    );
  }

  Expanded buildAllRows(int index, BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (hereResponses[index].position != null)
            buildRow(context, "Latitude: ",
                hereResponses[index].position!.latitude.toStringAsFixed(3)),
          if (hereResponses[index].position != null)
            buildRow(context, "Longitude: ",
                hereResponses[index].position!.longitude.toStringAsFixed(3)),
          if (hereResponses[index].address != null)
            buildRow(
                context,
                "Address ",
                hereResponses[index].address!.label ??
                    hereResponses[index].address!.label ??
                    ""),
          if (hereResponses[index].address != null)
            buildRow(context, "Postal Code: ",
                hereResponses[index].address!.postalCode.toString()),
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
        Flexible(
            child: Text(
          value.toString(),
          textAlign: TextAlign.right,
        )),
      ],
    );
  }
}
