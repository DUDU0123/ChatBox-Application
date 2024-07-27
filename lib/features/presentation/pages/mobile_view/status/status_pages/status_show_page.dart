import 'package:chatbox/config/common_provider/common_provider.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
          Positioned(
            // alignment: Alignment.topCenter,
            top: 0, left: 0, right: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 35.h, left: 10.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 28.sp,
                        ),
                      ),
                      kWidth10,
                      // userProfileImageShowWidget(
                      //     context: context, imageUrl: "", radius: 20),
                      CircleAvatar(
                        radius: 24.sp,
                      ),
                      kWidth10,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidgetCommon(
                            text: "Username",
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20.sp,
                          ),
                          TextWidgetCommon(
                            text: "6 minutes ago",
                            textColor: iconGreyColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 10.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      commonPopUpMenuItem(
                        context: context,
                        menuText: "Share",
                      ),
                      commonPopUpMenuItem(
                        context: context,
                        menuText: "Delete",
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: statusCaptionWidget(
              noOfLinesToShowDefault: 2,
              textToShow:
                  "BJKBJHBj dvkjvajbv kjvabva  svjabvj ajvhabvjabdvbakjvavda vhjbavnv xvnzxnvm,zxn dufhsljg asbmasbvknadjvbks hello how are you asfvsabcjkBJcvsvbjBSCbvhchzvjds",
              context: context,
              commonProvider: commonProvider,
              color: kBlack.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

Widget statusCaptionWidget({
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
          fontSize: fontSize,
        ),
      ],
    ),
  );
}
