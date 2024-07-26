import 'package:chatbox/config/common_provider/common_provider.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/readmore_button_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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

class StatusShowPage extends StatelessWidget {
  const StatusShowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final commonProvider = Provider.of<CommonProvider>(context, listen: true);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight(context: context),
            width: screenWidth(context: context),
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(appLogo))),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 35.h, left: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: kWhite,
                        size: 28.sp,
                      ),
                      kWidth10,
                      // userProfileImageShowWidget(
                      //     context: context, imageUrl: "", radius: 20),
                      CircleAvatar(
                        radius: 24.sp,
                      ),
                      kWidth10,
                      TextWidgetCommon(
                        text: "Username",
                        textColor: kWhite,
                        fontSize: 20.sp,
                      ),
                    ],
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: readMoreWidget(
              noOfLinesToShowDefault: 2,
              textToShow:
                  "BJKBJHBj dvkjvajbv kjvabva  svjabvj ajvhabvjabdvbakjvavda vhjbavnv xvnzxnvm,zxn dufhsljg asbmasbvknadjvbks hello how are you asfvsabcjkBJcvsvbjBSCbvhchzvjds",
              context: context,
              commonProvider: commonProvider,
              color: kBlack.withOpacity(0.1),
            ),
          )
        ],
      ),
    );
  }
}

Widget readMoreWidget({
  required BuildContext context,
  required CommonProvider commonProvider,
  required String textToShow,
  Color? color,
  required int noOfLinesToShowDefault,
  double? fontSize,
}) {
  return Container(
    padding: EdgeInsets.only(bottom: 40.h, left: 20.w, right: 20.w),
    alignment: Alignment.bottomCenter,
    color: color ?? kTransparent,
    width: screenWidth(context: context),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 1.3,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: TextWidgetCommon(
              maxLines:
                  !commonProvider.isExpanded ? noOfLinesToShowDefault : null,
              overflow: !commonProvider.isExpanded
                  ? TextOverflow.ellipsis
                  : TextOverflow.visible,
              text: textToShow,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        readMoreButton(
          commonProvider: commonProvider,
          context: context,
          isInMessageList: false,
         fontSize:   fontSize,
        ),
      ],
    ),
  );
}
