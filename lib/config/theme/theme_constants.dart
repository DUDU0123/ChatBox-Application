import 'package:chatbox/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: kWhite,
  splashColor: kTransparent,
  highlightColor: kTransparent,
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
      fontSize: 18.sp,
      color: kBlack,
      fontWeight: FontWeight.bold,
    ),
    
    titleSmall:  TextStyle(
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
);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkScaffoldColor,
  splashColor: kTransparent,
  highlightColor: kTransparent,
  radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(kWhite)),
  textTheme: TextTheme(
    labelSmall: TextStyle(
      fontSize: 18.sp,
      color: kWhite,
      fontWeight: FontWeight.bold,
    ),
    titleSmall:  TextStyle(
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
);
