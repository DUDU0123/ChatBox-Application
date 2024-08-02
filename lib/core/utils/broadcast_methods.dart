// import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
// import 'package:chatbox/core/enums/enums.dart';
// import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
// import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
// import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';

// import '../../features/data/models/message_model/message_model.dart';

// class BroadcastMethods {
//   sendBroadCastMessages({
//     required String messageContent,
//     required MessageBloc messageBloc,
//     required List<ContactModel>? selectedContactList,
//     required ChatModel chatModel,
    
//   }) {
//     for (var contact in selectedContactList!) {
//       final MessageModel message = MessageModel(
//         messageId: DateTime.now().millisecondsSinceEpoch.toString(),
//         message: messageContent,
//         isDeletedMessage: false,
//         isEditedMessage: false,
//         isPinnedMessage: false,
//         isStarredMessage: false,
//         messageStatus: MessageStatus.sent,
//         messageTime: DateTime.now().toString(),
//         messageType: MessageType.text,
//         receiverID: contact.chatBoxUserId,
//         senderID: firebaseAuth.currentUser?.uid,
//       );
//       messageBloc.add(MessageSentEvent(
//         chatModel: chatModel,
//         receiverID: contact.chatBoxUserId!,
//         currentUserId: firebaseAuth.currentUser!.uid,
//         receiverContactName: receiverModel?.contactName ??
//             receiverModel?.userName ??
//             receiverModel?.phoneNumber ??
//             '',
//         message: message,
//         isGroup: false,
//       ));
//     }
//   }
// }
