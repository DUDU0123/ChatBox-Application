import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/widgets/settings/image_selection_media_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> profileImageSelectorBottomSheet(
    {required BuildContext context}) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50.sp),
        topRight: Radius.circular(50.sp),
      ),
    ),
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(top: 20.h),
        height: screenHeight(context: context) / 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.sp),
            topRight: Radius.circular(50.sp),
          ),
          color: Theme.of(context).popupMenuTheme.color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageSelectionMediaWidgetCommon(
              context: context,
              mediaName: "Gallery",
              icon: Icons.photo,
            ),
            kWidth15,
            imageSelectionMediaWidgetCommon(
              context: context,
              mediaName: "Camera",
              icon: Icons.camera_alt_outlined,
            ),
          ],
        ),
      );
    },
  );
}
