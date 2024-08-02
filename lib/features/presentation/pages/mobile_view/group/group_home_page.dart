import 'dart:developer';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/bloc/group/group_bloc.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupHomePage extends StatelessWidget {
  const GroupHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupErrorState) {
            return commonErrorWidget(
              message: state.message,
            );
          }
          if (state is GroupLoadingState) {
            return commonAnimationWidget(
              context: context,
              isTextNeeded: false,
            );
          }
          return StreamBuilder<List<GroupModel>?>(
              stream: state.groupList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return commonAnimationWidget(
                    context: context,
                    isTextNeeded: false,
                  );
                }
                if (snapshot.hasError) {
                  log("Snap Error: ${snapshot.error.toString()}");
                  return commonErrorWidget(
                    message: "Something went wrong: ${snapshot.error}",
                  );
                }
                if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                  return commonErrorWidget(
                    message: "No groups",
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final GroupModel group = snapshot.data![index];
                    log("Last : ${group.lastMessage}");
                    return ChatListTileWidget(
                      isMutedChat: group.isMuted,
                      lastMessage: group.lastMessage,
                      lastMessageTime: group.lastMessage == null || group.lastMessage!.isEmpty
                          ? ''
                          : DateProvider.formatMessageDateTime(
                              messageDateTimeString: group.lastMessageTime.toString()),
                      notificationCount: group.notificationCount,
                      isIncomingMessage: group.isIncomingMessage,
                      userProfileImage: group.groupProfileImage,
                      userName: group.groupName != null
                          ? group.groupName!.isNotEmpty
                              ? group.groupName!
                              : 'ChatBox Group'
                          : 'ChatBox Group',
                      isGroup: true,
                      groupModel: group,
                    );
                  },
                  separatorBuilder: (context, index) => kHeight5,
                );
              });
        },
      ),
    );
  }
}
