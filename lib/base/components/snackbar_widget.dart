import 'package:flutter/material.dart';

class SnackBarWidget {
  final BuildContext context;

  SnackBarWidget(this.context);

  show(String type, String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: type == "success"
            ? Colors.indigo.shade100
            : type == "danger"
                ? Colors.red
                : Colors.white,
        content: Text(
          msg,
          style:
              TextStyle(color: type == "danger" ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
