import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/app_bar_icon_list_messaging_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({
    super.key,
    required this.pageType,
    required this.appBarTitle,
    this.userStatus, this.userProfileImage,
  });
  final PageTypeEnum pageType;
  final String appBarTitle;
  final String? userStatus;
  final String? userProfileImage;

  @override
  Widget build(BuildContext context) {
    final bool isPhotoNeededPage =
        (pageType == PageTypeEnum.oneToOneChatInsidePage ||
            pageType == PageTypeEnum.groupMessageInsidePage);
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: isPhotoNeededPage ? false : true,
      title: isPhotoNeededPage
          ? Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                kWidth5,
                CircleAvatar(
                  backgroundColor: kBlack,
                  backgroundImage:userProfileImage!=null? NetworkImage(userProfileImage!):AssetImage(contact),
                ),
                kWidth5,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidgetCommon(
                        overflow: TextOverflow.ellipsis,
                        text: appBarTitle,
                        fontSize: 18.sp,
                      ),
                       TextWidgetCommon(
                        overflow: TextOverflow.ellipsis,
                        text: userStatus??'Last seen 10:00am',
                        fontSize: 11.sp,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : TextWidgetCommon(
              text: appBarTitle,
            ),
      actions: !(pageType == PageTypeEnum.settingsPage)
          ? appBarIconListMessagingPage(
              pageType: pageType,
              context: context,
            )
          : [],
    );
  }
}
