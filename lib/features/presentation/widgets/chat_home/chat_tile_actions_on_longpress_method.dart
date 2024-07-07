import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> chatTileActionsOnLongPressMethod({
  required BuildContext context,
  required ChatModel chatModel,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: TextWidgetCommon(
          text: "Do Some Actions",
          fontSize: 18.sp,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            chatTileActionButtonWidget(
              buttonName: "Delete Chat",
              buttonIcon: Icons.delete,
              context: context,
              chatModel: chatModel,
            ),
            chatTileActionButtonWidget(
              context: context,
              chatModel: chatModel,
              buttonName: "Clear Chat",
              buttonIcon: Icons.remove_circle,
            ),
          ],
        ),
        actions: [
          cancelCenteredTextButton(
            context: context,
          ),
        ],
      );
    },
  );
}

Widget cancelCenteredTextButton({
  required BuildContext context,
}) {
  return Center(
    child: TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: TextWidgetCommon(
        text: "Cancel",
        textColor: buttonSmallTextColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget chatTileActionButtonWidget({
  required BuildContext context,
  required ChatModel chatModel,
  required String buttonName,
  required IconData buttonIcon,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    decoration: BoxDecoration(
        color: kBlack, borderRadius: BorderRadius.circular(20.sp)),
    height: 80.h,
    child: Column(
      children: [
        IconButton(
          onPressed: () {
            switch (buttonName) {
              case "Delete Chat":
                context.read<ChatBloc>().add(
                      DeletAChatEvent(chatModel: chatModel),
                    );
                break;
              case "Clear Chat":
                // clear chat function
                break;
              default:
            }
            Navigator.pop(context);
          },
          icon: Icon(
            buttonIcon,
            color: buttonSmallTextColor,
          ),
        ),
        TextWidgetCommon(
          text: buttonName,
          textColor: Theme.of(context).colorScheme.onPrimary,
        )
      ],
    ),
  );
}
