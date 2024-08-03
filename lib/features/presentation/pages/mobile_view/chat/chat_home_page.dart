import 'dart:developer';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/date_provider.dart';
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
    return Scaffold(
      body: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SearchBarChatHome(),
                ),
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoadingState) {
                      return SliverToBoxAdapter(
                        child: commonAnimationWidget(
                          context: context,
                          isTextNeeded: false,
                          lottie: settingsLottie,
                        ),
                      );
                    }
                    if (state is ChatErrorState) {
                      return SliverToBoxAdapter(
                          child: Center(
                        child: TextWidgetCommon(text: state.errormessage),
                      ));
                    }
                      return StreamBuilder<List<ChatModel>>(
                        stream: state.chatList,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            if (snapshot.data!.isEmpty) {
                              return SliverToBoxAdapter(
                                child: SizedBox(
                                  width: screenWidth(context: context),
                                  height: screenWidth(context: context),
                                  child: emptyShowWidget(
                                    context: context,
                                    text: noChatText,
                                  ),
                                ),
                              );
                            }
                          }
                          return SliverList.separated(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              final chat = snapshot.data;
                              if (chat == null) {
                                return zeroMeasureWidget;
                              }
                              return ChatListTileWidget(
                                isIncomingMessage: chat[index].isIncomingMessage,
                                chatModel: chat[index],
                                isGroup: false,
                                isMutedChat: chat[index].isMuted,
                                notificationCount:
                                    chat[index].notificationCount,
                                userName: chat[index].receiverName ?? '',
                                userProfileImage:
                                    chat[index].receiverProfileImage,
                              );
                            },
                            separatorBuilder: (context, index) => kHeight5,
                          );
                        },
                      );
                  },
                ),
              ],
            ),
    );
  }
}
