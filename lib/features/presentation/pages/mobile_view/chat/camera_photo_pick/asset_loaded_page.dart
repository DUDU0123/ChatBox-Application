import 'dart:io';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetLoadedPage extends StatelessWidget {
  AssetLoadedPage({super.key});
  TextEditingController assetSubtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final val = ModalRoute.of(context)?.settings.arguments as File;
    return Scaffold(
      backgroundColor: kBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(val, fit: BoxFit.cover,),
            Padding(
              padding:  EdgeInsets.only(left: 15.w,right: 15.w, bottom: 15.h, top: 20.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.sp),
                        border: Border.all(color: iconGreyColor,),
                      ),
                      child: TextFieldCommon(
                        maxLines: 20,
                        border: InputBorder.none,
                        cursorColor: buttonSmallTextColor,
                        controller: assetSubtitleController,
                        textAlign: TextAlign.center,
                        hintText: "Add description",
                        style: TextStyle(color: kWhite),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      sendIcon,
                      width: 30.w,
                      height: 30.h,
                      colorFilter: ColorFilter.mode(
                        buttonSmallTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
