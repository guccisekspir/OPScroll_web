import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opscroll_web_example/helpers/sizeHelper.dart';

class ThemeHelper {
  Color backgroundColor = const Color(0XFF121212);
  Color surfaceColor = const Color(0XFF242424);
  Color lightSurfaceColor = const Color(0XFF303030);
  Color primaryColor = const Color(0XFFFf0062);
  Color secondaryColor = const Color(0XFFa523ff);
  Color onBackground = Colors.white;
  Color onSurface = Colors.white;
  Color onSurfaceLight = Colors.white54;
  Color onPrimary = Colors.white;
  Color onSecondary = Colors.white;

  Color land1Purp = const Color(0XFFA932F0);
  Color land2Turq = const Color(0XFF10EDEF);
  Color lan3dAmber = const Color(0XFFF0C606);
  Color land4Spring = const Color(0XFF13EEB9);

  BuildContext? ccontext;
  ThemeData? themeData;
  Sizes sizes = Sizes();

  SizeHelper sizeHelper = SizeHelper();

  static final ThemeHelper _themeHelper = ThemeHelper._internal();

  ThemeHelper._internal();

  factory ThemeHelper({BuildContext? fetchedContext}) {
    //LnadPage'de context'i verdiğimiz için sonraki yerlerde
    //tekrar tekrar çağırmamak için bunu yapıyoruz
    if (fetchedContext != null) {
      _themeHelper.ccontext = fetchedContext;

      _themeHelper.themeData ??
          ThemeData(
              textTheme: TextTheme(
                  button: GoogleFonts.roboto(
                      fontSize: 24, fontWeight: FontWeight.bold)));
    }

    return _themeHelper;
  }
}

class Sizes {
  SizeHelper sizeHelper = SizeHelper();

  //* In Place //

}
