import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/status/status_pages/status_show_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusHomePage extends StatelessWidget {
  const StatusHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          statusTileWidget(
            userName: "No name",
            isCurrentUser: true,
            context: context,
          ),
          kHeight15,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: smallGreyMediumBoldTextWidget(text: "Recent updates"),
          ),
          kHeight15,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: smallGreyMediumBoldTextWidget(text: "Viewed updates"),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return statusTileWidget(
                  userName: "Index $index",
                  context: context,
                );
              },
              separatorBuilder: (context, index) => kHeight15,
              itemCount: 100,
            ),
          )
        ],
      ),
    );
  }
}

Widget statusTileWidget({
  required String userName,
  bool? isCurrentUser = false,
  required BuildContext context,
}) {
  return ListTile(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatusShowPage(),
          ));
    },
    leading: Container(
      alignment: Alignment.bottomRight,
      height: 70.h,
      width: 70.w,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage(appLogo), fit: BoxFit.cover),
        shape: BoxShape.circle,
        color: darkGreyColor,
      ),
      child: isCurrentUser!
          ? Container(
              height: 25.h,
              width: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: darkSwitchColor,
              ),
              child: Icon(
                Icons.add,
                size: 20.sp,
              ),
            )
          : zeroMeasureWidget,
    ),
    title: TextWidgetCommon(
      text: isCurrentUser ? "My status" : userName,
      fontSize: 16.sp,
    ),
    trailing: TextWidgetCommon(
      text: !isCurrentUser ? "6 minutes ago" : "",
      textColor: iconGreyColor,
      fontWeight: FontWeight.normal,
      fontSize: 10.sp,
    ),
  );
}


