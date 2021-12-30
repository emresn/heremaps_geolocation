import 'package:flutter/material.dart';
import 'package:heremaps/core/extensions/context_extensions.dart';

final theme1 = ThemeData(
  appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.amber,
      sizeConstraints: BoxConstraints.expand(height: 40, width: 40),
      elevation: 4),
  cardTheme: CardTheme(margin: Helpers.padding, color: Colors.grey.shade200),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    primary: Colors.grey.shade200,
    minimumSize: const Size(double.maxFinite, double.minPositive),
    padding: Helpers.padding,
    onPrimary: Colors.black,
  )),
);
final theme1Dark = ThemeData(
  appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.amber,
      sizeConstraints: BoxConstraints.expand(height: 40, width: 40),
      elevation: 4),
  cardTheme: CardTheme(margin: Helpers.padding, color: Colors.grey.shade200),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    primary: Colors.grey.shade200,
    minimumSize: const Size(double.maxFinite, double.minPositive),
    padding: Helpers.padding,
    onPrimary: Colors.black,
  )),
);
