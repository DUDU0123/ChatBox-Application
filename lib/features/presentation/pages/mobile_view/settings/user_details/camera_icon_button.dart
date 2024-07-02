import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/presentation/widgets/settings/profile_image_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CameraIconButton extends StatelessWidget {
  const CameraIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [
            darkLinearGradientColorTwo,
            darkLinearGradientColorOne,
          ])),
      child: Center(
        child: IconButton(
          onPressed: () {
            profileImageSelectorBottomSheet(context: context);
          },
          icon: SvgPicture.asset(
            cameraIcon,
            height: 30.h,
            width: 30.w,
            colorFilter: ColorFilter.mode(
              kWhite,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
