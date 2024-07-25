import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

List<Widget> appBarIconListMessagingPage({
  required PageTypeEnum pageType,
  required BuildContext context,
  required GroupModel? groupModel,
  required ChatModel? chatModel,
  required bool isGroup,
}) {
  final selectedMessagesId =
      context.watch<MessageBloc>().state.selectedMessageIds;

  return [
    selectedMessagesId!.isEmpty
        ? IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              videoCall,
              width: 30.w,
              height: 30.h,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
            ),
          )
        : IconButton(
            onPressed: () async{
             final MessageModel? message =  await CommonDBFunctions.getOneMessageByItsId(
                messageID: selectedMessagesId.first,
                isGroup: isGroup,
                chatModel: chatModel,
                groupModel: groupModel,
              );
              String? currentUserId = firebaseAuth.currentUser?.uid;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const TextWidgetCommon(text: "Delete Message"),
                    actions: [
                      selectedMessagesId
                                  .length <=
                              1
                          ? 
                           commonTextButton(
                              onPressed: () {
                                Provider.of<MessageBloc>(context, listen: false)
                                    .add(
                                  MessageDeleteForEveryOneEvent(
                                    isGroup: isGroup,
                                    messageID: selectedMessagesId.first,
                                    chatModel: chatModel,
                                    groupModel: groupModel,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              text: "Delete for Everyone",
                            )
                          : zeroMeasureWidget,
                      commonTextButton(
                        onPressed: () {
                          Provider.of<MessageBloc>(context, listen: false).add(
                            MessageDeleteForOne(
                              userID: Provider.of<MessageBloc>(context, listen: false).state.messagemodel!.senderID!,
                              isGroup: isGroup,
                              messageIdList: selectedMessagesId.toList(),
                              groupModel: groupModel,
                              chatModel: chatModel,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        text: "Delete for me",
                      ),
                      commonTextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: "Cancel",
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
    IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        call,
        width: 30.w,
        height: 23.h,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onPrimary,
          BlendMode.srcIn,
        ),
      ),
    ),
    PopupMenuButton(
      onSelected: (value) {},
      itemBuilder: (context) {
        if (pageType == PageTypeEnum.oneToOneChatInsidePage) {
          return [
            const PopupMenuItem(child: Text("View contact")),
            const PopupMenuItem(child: Text("Media,links and docs")),
            const PopupMenuItem(child: Text("Search")),
            const PopupMenuItem(child: Text("Mute notifications")),
            const PopupMenuItem(child: Text("Wallpaper")),
            const PopupMenuItem(child: Text("Clear chat")),
            const PopupMenuItem(child: Text("Report")),
            const PopupMenuItem(child: Text("Block")),
          ];
        }
        if (pageType == PageTypeEnum.groupMessageInsidePage) {
          return [
            const PopupMenuItem(child: Text("Group info")),
            const PopupMenuItem(child: Text("Group media")),
            const PopupMenuItem(child: Text("Search")),
            const PopupMenuItem(child: Text("Mute notifications")),
            const PopupMenuItem(child: Text("Wallpaper")),
            const PopupMenuItem(child: Text("Clear chat")),
          ];
        }
        // if (pageType == PageTypeEnum.broadCastMessageInsidePage)
        return [
          const PopupMenuItem(child: Text("Broadcast list info")),
          const PopupMenuItem(child: Text("Broadcast list media")),
          const PopupMenuItem(child: Text("Search")),
          const PopupMenuItem(child: Text("Wallpaper")),
          const PopupMenuItem(child: Text("Clear chat")),
        ];
      },
    )
  ];
}

Widget commonTextButton({
  required String text,
  required void Function()? onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    child: TextWidgetCommon(
      text: text,
      textColor: buttonSmallTextColor,
    ),
  );
}
