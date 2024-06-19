import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
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

Widget commonAnimationWidget({required BuildContext context, bool? isTextNeeded = true}) {
    return Center(
      child: SizedBox(
        width: 200.w,
        height: screenHeight(context: context) / 2.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(isTextNeeded!=null)
           isTextNeeded? TextWidgetCommon(
              text: "Creating Otp...",
              textColor: buttonSmallTextColor.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontSize: 30.sp,
            ):zeroMeasureWidget,
            Lottie.network(
              'https://lottie.host/8d23344c-f904-4f4d-b66c-9193441547b9/1PlShH1AmG.json',
            ),
          ],
        ),
      ),
    );
  }