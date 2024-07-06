import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_icon_button_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Widget countrySelectedShowWidget() {
  return Padding(
    padding: EdgeInsets.only(left: 10.w),
    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state.country != null
            ? TextWidgetCommon(
                text: (state.country!.flagEmoji + state.country!.phoneCode),
                fontWeight: FontWeight.w500,
                fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                textColor: Theme.of(context).colorScheme.onPrimary,
              )
            : Row(
                children: [
                  Image.asset(
                    indiaFlag,
                    scale: 18.sp,
                  ),
                  TextWidgetCommon(
                    text: "91",
                    fontWeight: FontWeight.w500,
                    fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                  )
                ],
              );
      },
    ),
  );
}

Widget commonAnimationWidget({required BuildContext context, bool? isTextNeeded = true, String? text, double? fontSize, String? lottie}) {
    return Center(
      child: SizedBox(
        width: 200.w,
        // height: screenHeight(context: context) / 2.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(isTextNeeded!=null)
           isTextNeeded? TextWidgetCommon(
            textAlign: TextAlign.center,
              text: text??"Creating Otp...",
              textColor: buttonSmallTextColor.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontSize: fontSize?? 26.sp,
            ):zeroMeasureWidget,
            Lottie.network(
             lottie?? 'https://lottie.host/8d23344c-f904-4f4d-b66c-9193441547b9/1PlShH1AmG.json',
            ),
          ],
        ),
      ),
    );
  }

  Widget searchButton(
    {required ThemeData theme, required void Function()? onPressed}) {
  return CommonIconButtonWidget(
    theme: theme,
    height: 22,
    width: 22,
    iconImage: search,
    onPressed: onPressed,
  );
}

Widget cameraButtonMainPage(
    {required ThemeData theme, required void Function()? onPressed}) {
  return CommonIconButtonWidget(
    theme: theme,
    height: 30,
    width: 30,
    iconImage: cameraIcon,
    onPressed: onPressed,
  );
}

Widget addChatButtonHome(
    {required ThemeData theme, required void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        CommonIconButtonWidget(
          theme: theme,
          height: 30,
          width: 30,
          iconImage: chatsIcon,
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.add,
            color: theme.colorScheme.onPrimary,
          ),
        )
      ],
    ),
  );
}

PopupMenuItem<dynamic> settingsNavigatorMenu(BuildContext context) {
  return PopupMenuItem(
    child: const Text("Settings"),
    onTap: () {
      Navigator.pushNamed(context, "/settings_page");
    },
  );
}

Widget emptyShowWidget(
      {required BuildContext context, required String text}) {
    return SizedBox(
      width: screenWidth(context: context),
      height: screenHeight(context: context),
      child: Center(
        child: SizedBox(
          width: 250.w,
          child: TextWidgetCommon(
            textAlign: TextAlign.center,
            text: text,
            textColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
