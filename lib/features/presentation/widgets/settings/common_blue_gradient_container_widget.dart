import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonBlueGradientContainerWidget extends StatelessWidget {
  const CommonBlueGradientContainerWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.pageType,
  });

  final String title;
  final String subTitle;
  final String icon;
  final PageTypeEnum pageType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.sp),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkLinearGradientColorOne,
            darkLinearGradientColorTwo,
          ],
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            height: (icon != keyIcon && icon != privacyIcon) ? 30.h : 35.h,
            width: 30.w,
            colorFilter: ColorFilter.mode(
              iconGreyColor,
              BlendMode.srcIn,
            ),
          ),
          kWidth5,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidgetCommon(
                  text: title,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.5.sp,
                ),
                kHeight2,
                subTitle.isEmpty
                    ? zeroMeasureWidget
                    : TextWidgetCommon(
                        textColor: iconGreyColor,
                        maxLines: 1,
                        text: subTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
          pageType == PageTypeEnum.settingEditProfilePage
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: kWhite,
                  ),
                )
              : zeroMeasureWidget,
        ],
      ),
    );
  }
}
