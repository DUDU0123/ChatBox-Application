import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//function for creating a new chat with chatid if the user tap on a contact, which is not in their chat list
void chatOpen(
    {required String receiverId,
    required String recieverContactName,
    required BuildContext context}) {
  context.read<ChatBloc>().add(CreateANewChatEvent(
        receiverId: receiverId,
        recieverContactName: recieverContactName,
      ));
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) =>
  //         ChatRoomPage(isGroup: false, userName: recieverContactName),
  //   ),
  // );
}

// function for sorting the contact list to find the chatbox users and to show them first to the list
void sortContactsToShowChatBoxUsersFirst({
  required List<ContactModel> contactList,
}) {
  return contactList.sort(
    (a, b) {
      if (a.isChatBoxUser! && !b.isChatBoxUser!) {
        return -1; // a comes before b
      } else if (!a.isChatBoxUser! && b.isChatBoxUser!) {
        return 1; // b comes before a
      } else {
        return 0; // a and b are equivalent
      }
    },
  );
}
