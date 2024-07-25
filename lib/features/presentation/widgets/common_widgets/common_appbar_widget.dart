import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/app_bar_icon_list_messaging_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({
    super.key,
    required this.pageType,
    required this.appBarTitle,
    this.userStatus,
    this.userProfileImage, this.onTap, this.groupModel, this.chatModel,  this.isGroup,
  });
  final PageTypeEnum pageType;
  final String appBarTitle;
  final String? userStatus;
  final String? userProfileImage;
  final void Function()? onTap;
  final GroupModel? groupModel;final ChatModel? chatModel; final bool? isGroup;

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
                  backgroundImage: userProfileImage != null
                      ? NetworkImage(userProfileImage!)
                      : const AssetImage(contact),
                ),
                kWidth5,
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidgetCommon(
                          overflow: TextOverflow.ellipsis,
                          text: appBarTitle,
                          fontSize: 18.sp,
                        ),
                      pageType!=PageTypeEnum.groupMessageInsidePage?  TextWidgetCommon(
                          overflow: TextOverflow.ellipsis,
                          text: userStatus ?? 'Last seen 10:00am',
                          fontSize: 10.sp,
                        ):zeroMeasureWidget,
                      ],
                    ),
                  ),
                ),
              ],
            )
          : TextWidgetCommon(
              text: appBarTitle,
            ),
      actions: !(pageType == PageTypeEnum.settingsPage)
          ? appBarIconListMessagingPage(
            chatModel: chatModel,groupModel: groupModel,isGroup: isGroup??false,
              pageType: pageType,
              context: context,
            )
          : [],
    );
  }
}
