import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Positioned messageBottomStatusIcons({required bool? isReadedMessage}) {
  return Positioned(
    bottom: 3.h,
    right: 10.w,
    child: Row(
      children: [
        Icon(
          Icons.push_pin_sharp,
          color: iconGreyColor,
          size: 10.sp,
        ),
        Icon(
          Icons.star,
          color: iconGreyColor,
          size: 10.sp,
        ),
        TextWidgetCommon(
          maxLines: 1,
          text: "10:00",
          textColor: kGrey,
          fontSize: 8.sp,
        ),
        SvgPicture.asset(
          isReadedMessage != null
              ? isReadedMessage
                  ? doubleTick
                  : singleTick
              : timer,
          width: isReadedMessage != null
              ? isReadedMessage
                  ? 20.w
                  : 10.w
              : 13.w,
          height: isReadedMessage != null
              ? isReadedMessage
                  ? 20.h
                  : 10.h
              : 13.h,
          colorFilter: ColorFilter.mode(
            isReadedMessage != null
                ? isReadedMessage
                    ? messageSeenColor
                    : kGrey
                : kGrey,
            BlendMode.srcIn,
          ),
        ),
      ],
    ),
  );
}
