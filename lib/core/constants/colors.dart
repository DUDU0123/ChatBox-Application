import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:flutter/material.dart';

Color kWhite = Colors.white;
Color kBlack = Colors.black;
Color kTransparent = Colors.transparent;
Color kGrey = Colors.grey;
Color darkScaffoldColor = const Color.fromARGB(255, 22, 23, 28);
Color darkSmallTextColor = const Color.fromARGB(255, 5, 118, 251);
Color bottomNavIconBgColor = const Color.fromARGB(255, 0, 87, 255);
Color darkSwitchColor = const Color.fromARGB(255, 97, 111, 142);
Color voiceRecorderContainer = const Color.fromARGB(255, 89, 95, 255);
Color darkLinearGradientColorOne = const Color.fromARGB(255, 0, 47, 147);
Color darkLinearGradientColorTwo = const Color.fromARGB(255, 0, 14, 45);
Color lightLinearGradientColorOne = const Color.fromARGB(255, 0, 79, 249);
Color lightLinearGradientColorTwo = const Color.fromARGB(255, 0, 47, 147);
Color buttonSmallTextColor = const Color.fromARGB(255, 0, 79, 249);
Color onSecondaryColorDark = const Color.fromARGB(255, 45, 45, 45);
Color onSecondaryColorLight = const Color.fromARGB(255, 228, 228, 228);
TextStyle fieldStyle({required BuildContext context}) => TextStyle(
      fontSize:
          ThemeConstants.theme(context: context).textTheme.labelSmall?.fontSize,
      fontWeight: FontWeight.w500,
    );

TextStyle labelStyle({required BuildContext context}) => const TextStyle(
      fontSize:
          16,
      fontWeight: FontWeight.bold,
    );


// assets
const doubleTick = "assets/double_tick.svg";
const singleTick = "assets/one_tick.svg";
const search = "assets/search.svg";
const location = "assets/location.svg";
const mute = "assets/mute.png";
const qrcode = "assets/qrcode.svg";
const wallpaper = "assets/wallpaper.svg";
const timer = "assets/timer.svg";
