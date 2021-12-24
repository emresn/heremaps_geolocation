import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double dynamicWidth(double val) => MediaQuery.of(this).size.width * val;
  double dynamicHeight(double val) => MediaQuery.of(this).size.height * val;
  BoxDecoration gradientBackground() => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.indigo.shade400,
            Colors.indigo.shade800,
          ],
        ),
      );

  TextStyle h1() => Theme.of(this).textTheme.headline1!;
  TextStyle h2() => Theme.of(this).textTheme.headline2!;
  TextStyle h3() => Theme.of(this).textTheme.headline3!;
  TextStyle h4() => Theme.of(this).textTheme.headline4!;
  TextStyle h5() => Theme.of(this).textTheme.headline5!;
  TextStyle h6() => Theme.of(this).textTheme.headline6!;
  TextStyle b1() => Theme.of(this).textTheme.bodyText1!;
  TextStyle b2() => Theme.of(this).textTheme.bodyText2!;
  TextStyle cap() => Theme.of(this).textTheme.caption!;

  Orientation orientation() => MediaQuery.of(this).orientation;
  Orientation landscape() => Orientation.landscape;
}

class Helpers {
  static const padding = EdgeInsets.all(8);
  static const paddingSmall = EdgeInsets.all(4);
  static const paddingLarge = EdgeInsets.all(12);
  static const paddingHorizontal = EdgeInsets.symmetric(horizontal: 8);
  static const paddingVertical = EdgeInsets.symmetric(vertical: 8);
  static const double spaceLarge = 40;
  static const double space = 30;
  static const double spaceSmall = 20;
  static const double fontsizeLarge = 20;
  static const double fontsize = 14;
  static const double fontsizeSmall = 13;
}

class FontSizeValue {}
