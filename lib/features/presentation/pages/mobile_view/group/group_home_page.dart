import 'dart:developer';

import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
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
                if (snapshot.hasError || snapshot.data == null) {
                  log(snapshot.error.toString());
                  
                  return commonErrorWidget(
                    message: "Something went wrong",
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return commonErrorWidget(
                    message: "No groups",
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final GroupModel group = snapshot.data![index];
                    return ChatListTileWidget(
                      userProfileImage: group.groupProfileImage,
                      userName: group.groupName!=null? group.groupName!.isNotEmpty?group.groupName!:'ChatBox Group':'ChatBox Group',
                      isGroup: true,
                      messageStatus: MessageStatus.read,
                      chatModel: const ChatModel(),
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
