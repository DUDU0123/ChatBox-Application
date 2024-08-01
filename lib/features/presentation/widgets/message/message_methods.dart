import 'dart:developer';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/core/utils/snackbar.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/message/delete_message_dialog_box.dart';
import 'package:chatbox/features/presentation/widgets/message/edit_message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageMethods {
  static copyMessage({
    required String textToCopy,
    required BuildContext context,
  }) async {
    await Clipboard.setData(
      ClipboardData(
        text: textToCopy,
      ),
    ).then((value) {
      return commonSnackBarWidget(
        contentText: "Message copied",
        context: context,
      );
    });
  }

  static Future<dynamic> messageActionMethods({
    required BuildContext context,
    required MessageModel? message,
    required bool isGroup,
    required Set<String> selectedMessagesId,
    required GroupModel? groupModel,
    required ChatModel? chatModel,
  }) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.sp),
          topRight: Radius.circular(25.sp),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 30.h, left: 15.w, right: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.sp),
              topRight: Radius.circular(25.sp),
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          width: screenWidth(context: context),
          // height: screenHeight(context: context) / 2,
          child: Column(
            children: [
              selectedMessagesId.length <= 1
                  ? message?.messageType == MessageType.text
                      ? listTileCommonWidget(
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          trailing: Icon(
                            Icons.copy,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          tileText: "Copy",
                          onTap: () {
                            context.read<MessageBloc>().add(
                                UnSelectEvent(messageId: message?.messageId));
                            if (message != null) {
                              if (message.message != null) {
                                MessageMethods.copyMessage(
                                    textToCopy: message.message!,
                                    context: context);
                              }
                            }

                            Navigator.pop(context);
                          },
                        )
                      : zeroMeasureWidget
                  : zeroMeasureWidget,
              selectedMessagesId.length <= 1
                  ? message?.senderID == firebaseAuth.currentUser?.uid
                      ? listTileCommonWidget(
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          trailing: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          tileText: "Edit",
                          onTap: () async {
                            Navigator.pop(context);
                            if (message != null) {
                              showModalBottomSheet<String>(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => EditMessageScreen(
                                  chatModel: chatModel,
                                  groupModel: groupModel,
                                  isGroup: isGroup,
                                  message: message,
                                ),
                              );
                            }
                          },
                        )
                      : zeroMeasureWidget
                  : zeroMeasureWidget,
              listTileCommonWidget(
                textColor: Theme.of(context).colorScheme.onPrimary,
                trailing: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                tileText: "Delete",
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DeleteMessage(
                        selectedMessagesId: selectedMessagesId,
                        isGroup: isGroup,
                        groupModel: groupModel,
                        chatModel: chatModel,
                        messageModel: message,
                      );
                    },
                  );
                },
              ),
              listTileCommonWidget(
                textColor: Theme.of(context).colorScheme.onPrimary,
                trailing: Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                tileText: "Forward",
                onTap: () {
                  context
                      .read<MessageBloc>()
                      .add(UnSelectEvent(messageId: message?.messageId));
                  Navigator.pop(context);
                },
              ),
              listTileCommonWidget(
                textColor: Theme.of(context).colorScheme.onPrimary,
                trailing: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                tileText: "Cancel",
                onTap: () {
                  context
                      .read<MessageBloc>()
                      .add(UnSelectEvent(messageId: message?.messageId));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
