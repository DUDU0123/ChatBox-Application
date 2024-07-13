import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget messageStatusShowWidget({
  required MessageModel message,
}) {
  return Positioned(
    bottom: 6.h,
    right: 18.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextWidgetCommon(
          text: DateProvider.take24HourTimeFromTimeStamp(
            timeStamp: message.messageTime.toString(),
          ),
          fontSize: 10.sp,
          textColor: kBlack,
        ),
        kWidth2,
        Icon(
          Icons.done,
          color: kBlack,
          size: 12.sp,
        ),
        kWidth2,
        Icon(
          Icons.push_pin_rounded,
          color: kBlack,
          size: 12.sp,
        ),
        kWidth2,
        Icon(
          Icons.star,
          color: kBlack,
          size: 12.sp,
        ),
        kWidth2,
        Icon(
          Icons.done_all,
          color: kBlack,
          size: 12.sp,
        )
      ],
    ),
  );
}