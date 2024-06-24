import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

Widget imageSelectionMediaWidgetCommon({
  required BuildContext context,
  required String mediaName,
  required IconData icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 80.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.sp),
          color: boxColorDark,
        ),
        child: Center(
          child: IconButton(
            onPressed: () {
              context.read<UserBloc>().add(
                    PickProfileImageFromDevice(
                      imageSource: mediaName == "Camera"
                          ? ImageSource.camera
                          : ImageSource.gallery,
                    ),
                  );
              Navigator.pop(context);
            },
            icon: Icon(
              icon,
              size: 40.sp,
              color: kWhite,
            ),
          ),
        ),
      ),
      kHeight2,
      TextWidgetCommon(
        text: mediaName,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        textColor: Theme.of(context).colorScheme.onPrimary,
      ),
    ],
  );
}
