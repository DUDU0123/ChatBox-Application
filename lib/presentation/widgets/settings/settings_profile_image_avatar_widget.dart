import 'package:chatbox/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsProfileImageAvatarWidget extends StatelessWidget {
  const SettingsProfileImageAvatarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80,
          child: SvgPicture.asset(contact),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  darkLinearGradientColorTwo,
                  darkLinearGradientColorOne,
                ])),
            child: Center(
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  cameraIcon,
                  height: 30.h,
                  width: 30.w,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
