import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/data/models/user_model/user_model.dart';
import 'package:chatbox/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_butttons_common.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    this.fieldTypeSettings,
  });

  final String title;
  final String subTitle;
  final String icon;
  final PageTypeEnum pageType;
  final FieldTypeSettings? fieldTypeSettings;
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
                  fontWeight: !(pageType == PageTypeEnum.none ||
                          pageType == PageTypeEnum.settingEditProfilePage)
                      ? FontWeight.w500
                      : FontWeight.w400,
                  fontSize: !(pageType == PageTypeEnum.none ||
                          pageType == PageTypeEnum.settingEditProfilePage)
                      ? 16.5.sp
                      : 13.sp,
                  textColor: !(pageType == PageTypeEnum.none ||
                          pageType == PageTypeEnum.settingEditProfilePage)
                      ? kWhite
                      : iconGreyColor,
                ),
                kHeight2,
                subTitle.isEmpty
                    ? zeroMeasureWidget
                    : TextWidgetCommon(
                        fontSize: !(pageType == PageTypeEnum.none ||
                                pageType == PageTypeEnum.settingEditProfilePage)
                            ? 12.sp
                            : 18.sp,
                        fontWeight: !(pageType == PageTypeEnum.none ||
                                pageType == PageTypeEnum.settingEditProfilePage)
                            ? FontWeight.normal
                            : FontWeight.w500,
                        textColor: !(pageType == PageTypeEnum.none ||
                                pageType == PageTypeEnum.settingEditProfilePage)
                            ? iconGreyColor
                            : kWhite,
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
                    bottomSheetCommon(
                      controller: controller,
                      context: context,
                      fieldTitle: fieldTypeSettings == FieldTypeSettings.name
                          ? "Enter your name"
                          : "About",
                      hintText: fieldTypeSettings == FieldTypeSettings.name
                          ? "Enter name"
                          : "Enter about",
                          fieldTypeSettings: fieldTypeSettings,
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

  Future<dynamic> bottomSheetCommon({
    required BuildContext context,
    required String fieldTitle,
    required String hintText,
    TextEditingController? controller,
    required FieldTypeSettings? fieldTypeSettings,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20.sp,
            ),
          ),
          backgroundColor: darkGreyColor,
          child: Container(
            padding: EdgeInsets.only(top: 20.h, left: 30.w, right: 20.w, bottom: 10.h),
            height: screenHeight(context: context) / 4,
            decoration: BoxDecoration(
              color: darkGreyColor,
              borderRadius: BorderRadius.circular(
                20.sp,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgetCommon(
                  textColor: kWhite,
                  text: fieldTypeSettings == FieldTypeSettings.name
                          ? "Enter your name"
                          : "About",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
                if (controller != null)
                  SizedBox(
                    height: 50.h,
                    child: TextFieldCommon(
                      minLines: 1,
                    
                      maxLines: fieldTitle=="About"?5:1,
                      style: TextStyle(
                        color: kWhite,
                    
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: buttonSmallTextColor,)
                      ),
                      cursorColor: buttonSmallTextColor,
                      hintText: fieldTypeSettings == FieldTypeSettings.name
                          ? "Enter name"
                          : "Enter about",
                      controller: controller,
                      textAlign: TextAlign.start,
                    ),
                  ),
                 const Spacer(),
                TextButtonsCommon(
                  onPressed: () {
                 UserModel userModel = fieldTypeSettings == FieldTypeSettings.name?  UserModel(
                      userName: controller?.text
                    ): UserModel(
                      userAbout: controller?.text,
                    );
                    context.read<UserBloc>().add(EditCurrentUserData(userModel: userModel));
                  },
                  buttonName: "Save",
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
