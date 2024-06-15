import 'package:chatbox/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeConstants {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: kWhite,
    ),
    brightness: Brightness.light,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(color: kWhite),
      unselectedItemColor: kBlack,
      selectedItemColor: kBlack,
      selectedLabelStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: kBlack,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    ),
    scaffoldBackgroundColor: kWhite,
    splashColor: kTransparent,
    highlightColor: kTransparent,
    shadowColor: const Color.fromARGB(255, 84, 84, 84),
    radioTheme:
        RadioThemeData(fillColor: WidgetStateProperty.all(darkScaffoldColor)),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
        color: kBlack,
      ),
    ),
    textTheme: TextTheme(
      labelSmall: TextStyle(
        fontSize: 20.sp,
        color: kWhite,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: 10.sp,
        color: kGrey,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontSize: 25.sp,
        color: kBlack,
        fontWeight: FontWeight.w500,
      ),
    ),
    primaryColor: kBlack,
    iconTheme: IconThemeData(
      color: buttonSmallTextColor,
    ),
    colorScheme: const ColorScheme.light().copyWith(
        onPrimary: kBlack,
        onSecondary: onSecondaryColorLight,),
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: darkScaffoldColor,
    ),
    brightness: Brightness.dark,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(color: kWhite),
      unselectedItemColor: kWhite,
      selectedItemColor: kWhite,
      selectedLabelStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: kWhite,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    ),
    scaffoldBackgroundColor: darkScaffoldColor,
    splashColor: kTransparent,
    highlightColor: kTransparent,
    shadowColor: const Color.fromARGB(255, 5, 4, 11),
    radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(kWhite)),
    textTheme: TextTheme(
      labelSmall: TextStyle(
        fontSize: 20.sp,
        color: kWhite,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: 10.sp,
        color: kGrey,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontSize: 25.sp,
        color: kWhite,
        fontWeight: FontWeight.w500,
      ),
    ),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
        color: kWhite,
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      onPrimary: kWhite,
      onSecondary: onSecondaryColorDark,
    ),
    primaryColor: buttonSmallTextColor,
    iconTheme: IconThemeData(
      color: kWhite,
    ),
  );

  static ThemeData theme({required BuildContext context}) {
    return Theme.of(context);
  }
}
