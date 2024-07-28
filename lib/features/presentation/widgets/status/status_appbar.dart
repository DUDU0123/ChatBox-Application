import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget statusAppBar(
    {required String userName,
    required String howHours,
    void Function()? shareMethod,
    void Function()? deleteMethod}) {
  return Padding(
    padding: EdgeInsets.only(top: 35.h, left: 10.w),
    child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.sp),
          color: kBlack.withOpacity(0.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.sp,
              ),
              kWidth10,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgetCommon(
                    text: userName,
                    textColor: kWhite,
                    fontSize: 20.sp,
                  ),
                  TextWidgetCommon(
                    text: howHours,
                    textColor: iconGreyColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 10.sp,
                  ),
                ],
              ),
            ],
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              commonPopUpMenuItem(
                context: context,
                menuText: "Share",
                onTap: shareMethod,
              ),
              commonPopUpMenuItem(
                context: context,
                menuText: "Delete",
                onTap: deleteMethod,
              ),
            ],
          )
        ],
      ),
    ),
  );
}
