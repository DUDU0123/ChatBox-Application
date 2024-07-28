import 'package:chatbox/config/common_provider/common_provider.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/status/status_home_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

List<StoryItem?> buildStatusItems({
  required StoryController controller,
  required StatusModel statusModel,
  required BuildContext context,
}) {
  return statusModel.statusList!
      .map((status) {
        switch (status.statusType) {
          case StatusType.video:
            return StoryItem.pageVideo(
              status.statusContent ?? "",
              controller: controller,
              caption:
                  //  TextWidgetCommon(
                  //   text: status.statusCaption ?? '',
                  //   textAlign: TextAlign.center,
                  //   textColor: kWhite,
                  //   fontWeight: FontWeight.w400,
                  //   fontSize: 18.sp,
                  // ),
                  statusCaptionWidget(
                context: context,
                commonProvider:
                    Provider.of<CommonProvider>(context, listen: true),
                textToShow: status.statusCaption ?? '',
                noOfLinesToShowDefault: 2,
              ),
            );
          case StatusType.image:
            return StoryItem.pageImage(
              url: status.statusContent ?? '',
              controller: controller,
              imageFit: BoxFit.contain,
              caption: Text(
                status.statusCaption ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kWhite,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          case StatusType.text:
            return StoryItem.text(
              title: status.statusContent ?? '',
              backgroundColor: status.textStatusBgColor ?? kBlack,
            );
          default:
            return null;
        }
      })
      .where((item) => item != null)
      .toList();
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
