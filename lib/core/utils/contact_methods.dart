import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactMethods {
  static sendSelectedContactMessage(
      {required List<ContactModel>? selectedContactList,
      required String? receiverContactName,
      required BuildContext context,
      required bool isGroup,
      required GroupModel? groupModel,
      required ChatModel? chatModel}) {
    selectedContactList != null
        ? receiverContactName != null
            ? context.read<MessageBloc>().add(
                  ContactMessageSendEvent(
                    isGroup: isGroup,
                    groupModel: groupModel,
                    receiverID: chatModel?.receiverID,
                    receiverContactName: receiverContactName,
                    contactListToSend: selectedContactList,
                    chatModel: chatModel,
                  ),
                )
            : null
        : null;
    Navigator.pop(context);
  }
}
