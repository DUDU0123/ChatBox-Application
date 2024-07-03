import 'dart:developer';

import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/searchbar_chat_home.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatHomePage extends StatelessWidget {
  const ChatHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List chatList = [];
    return Scaffold(
      body: chatList.isNotEmpty
          ? emptyShowWidget(
              context: context,
              text:
                  "No Chats\nStart a chat by selecting a contact by click on above chat icon",
            )
          : CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SearchBarChatHome(),
                ),
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    // if (state is ChatLoadingState) {
                    //   return SliverToBoxAdapter(
                    //     child: commonAnimationWidget(
                    //       context: context,
                    //       isTextNeeded: false,
                    //       lottie: settingsLottie,
                    //     ),
                    //   );
                    // }
                    if (state is ChatErrorState) {
                      return SliverToBoxAdapter(
                          child: Center(
                        child: TextWidgetCommon(text: state.message),
                      ));
                    }
                    if (state is ChatSuccessState) {
                      log("Length: ${state.chatList.length}");

                      return StreamBuilder<List<ChatModel>>(
                        stream: state.chatList,
                        builder: (context, snapshot) {
                          if (state.chatList.length.toString() == '0') {
                            return SliverToBoxAdapter(
                              child: Center(
                                child: TextWidgetCommon(
                                  text: "No Chats",
                                  textColor: kBlack,
                                ),
                              ),
                            );
                          }

                          log("Hello inside");
                          return SliverList.separated(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              final chat = snapshot.data;
                              if (chat == null) {
                                return zeroMeasureWidget;
                              }
                              final lastMessage = chat[index].lastMessage;
                              return ChatListTileWidget(
                                messageStatus: chat[index].lastMessageStatus??MessageStatus.none,
                                isGroup: false,
                                // isOutgoing: true,
                                isMutedChat: chat[index].isMuted,
                                // isGone: true,
                                // isSeen: true,
                                lastMessage: lastMessage,
                                lastMessageTime: lastMessage==null||lastMessage.isEmpty?'': chat[index].lastMessageTime,
                                notificationCount: chat[index].notificationCount,
                                userName: chat[index].receiverName ?? '',
                                userProfileImage:
                                    chat[index].receiverProfileImage,
                                // message
                                // isAudio: false,
                                // isContact: false,
                                // isDocument: false,
                                // isIncomingMessage: false,
                                // isPhoto: false,
                                // isRecordedAudio: false,
                                // isTyping: false,
                                // isVoiceRecoding: false,
                              );
                            },
                            separatorBuilder: (context, index) => kHeight5,
                          );
                        },
                      );
                    }
                    return SliverToBoxAdapter(child: zeroMeasureWidget);
                  },
                ),
              ],
            ),
    );
  }
}
