import 'package:chatbox/core/constants/app_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AttachmentListContainerVertical extends StatelessWidget {
  const AttachmentListContainerVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: screenHeight(context: context) / 3.h,
      width: 50.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiary,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.sp),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          itemCount: attachmentIcons.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    attachmentIcons[index].colorOne,
                    attachmentIcons[index].colorTwo,
                  ],
                ),
              ),
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  attachmentIcons[index].icon,
                  height: 24.h,
                  width: 24.h,
                  colorFilter: ColorFilter.mode(
                    kBlack,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => kHeight5,
        ),
      ),
    );
  }
}
