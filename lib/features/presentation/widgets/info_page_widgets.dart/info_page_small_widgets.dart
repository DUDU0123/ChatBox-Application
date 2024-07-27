import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/widgets/chat/icon_container_widget_gradient_color.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/group_description_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget userProfileImageShowWidget({
  required BuildContext context,
  required String imageUrl,
  double? radius,
  void Function()? onTap
}) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      radius: radius?.sp ?? 20.sp,
      backgroundImage: NetworkImage(
        imageUrl,
      ),
    ),
  );
}

Widget chatDescriptionOrAbout({
  required bool isGroup,
  String? receiverAbout,
  String? groupDescription,
  required BuildContext context,
  required GroupModel? groupData,
}) {
  return StreamBuilder<GroupModel?>(
    stream:groupData!=null? CommonDBFunctions.getOneGroupDataByStream(userID: firebaseAuth.currentUser!.uid, groupID: groupData.groupID!): null,
    builder: (context, snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              isGroup
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupDescriptionAddPage(groupModel: snapshot.data!,),
                      ))
                  : null;
            },
            child: TextWidgetCommon(
              text: !isGroup ? "About" : "Add Group Description",
              textColor: buttonSmallTextColor,
              overflow: TextOverflow.ellipsis,
              fontSize: 18.sp,
            ),
          ),
          TextWidgetCommon(
            text: !isGroup
                ? receiverAbout ?? ''
                : snapshot.data?.groupDescription ?? 'No description',
            overflow: TextOverflow.ellipsis,
            fontSize: 14.sp,
            textColor: iconGreyColor,
            maxLines: !isGroup?1:2,
          ),
        ],
      );
    }
  );
}

Widget infoPageActionIconsBlueGradient({required bool isGroup}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      iconContainerWidgetGradientColor(
        size: 75.sp,
        subtitle: "Audio",
        icon: Icons.call,
        onTap: () {},
      ),
      kWidth10,
      iconContainerWidgetGradientColor(
        size: 75.sp,
        subtitle: !isGroup ? "Video" : "Chat",
        icon: !isGroup ? Icons.videocam_outlined : Icons.chat_outlined,
        onTap: () {},
      ),
      kWidth10,
    ],
  );
}
