import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_butttons_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
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
    this.controller,
  });

  final String title;
  final String subTitle;
  final String icon;
  final PageTypeEnum pageType;
  final TextEditingController? controller;

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
          kWidth10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidgetCommon(
                  text: title,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: !(pageType==PageTypeEnum.none || pageType==PageTypeEnum.settingEditProfilePage)?FontWeight.w500:FontWeight.w400,
                  fontSize:!(pageType==PageTypeEnum.none || pageType==PageTypeEnum.settingEditProfilePage)? 16.5.sp: 13.sp,
                  textColor: !(pageType==PageTypeEnum.none || pageType==PageTypeEnum.settingEditProfilePage)?kWhite:iconGreyColor,
                ),
                kHeight2,
                subTitle.isEmpty
                    ? zeroMeasureWidget
                    : TextWidgetCommon(
                      fontSize: !(pageType==PageTypeEnum.none || pageType==PageTypeEnum.settingEditProfilePage)?12.sp:18.sp,
                      fontWeight: !(pageType==PageTypeEnum.none || pageType==PageTypeEnum.settingEditProfilePage)?FontWeight.normal:FontWeight.w500,
                        textColor: !(pageType==PageTypeEnum.none || pageType==PageTypeEnum.settingEditProfilePage)? iconGreyColor:kWhite,
                        maxLines: 1,
                        text: subTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
          pageType == PageTypeEnum.settingEditProfilePage
              ? IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: screenHeight(context: context) / 4,
                          color: greyBlackColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidgetCommon(text: "Enter name"),
                              if (controller != null)
                                TextFieldCommon(
                                  controller: controller!,
                                  textAlign: TextAlign.start,
                                ),
                              TextButtonsCommon(
                                buttonName: "Save",
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
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

