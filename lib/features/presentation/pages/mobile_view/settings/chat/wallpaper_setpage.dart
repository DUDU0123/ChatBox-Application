import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WallpaperSetPage extends StatelessWidget {
  const WallpaperSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(
          text: "Chat Wallpaper",
        ),
      ),
      body: SizedBox(
        width: screenWidth(context: context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenHeight(context: context) / 1.8,
              width: screenWidth(context: context) / 1.5,
              decoration: BoxDecoration(
                // border: Border.all(
                //   color: kBlack,
                // ),
                image: const DecorationImage(
                  image: AssetImage("assets/chatPreviewPhoto.png"),
                  fit: BoxFit.cover,
                ),
                // color: buttonSmallTextColor,
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
            kHeight15,
            TextButton(
              onPressed: () {},
              child: TextWidgetCommon(
                text: "Change",
                textColor: buttonSmallTextColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
