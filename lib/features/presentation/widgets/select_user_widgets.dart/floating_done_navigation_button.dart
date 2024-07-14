import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingDoneNavigateButton extends StatelessWidget {
  const FloatingDoneNavigateButton({
    super.key,
    required this.chatModel,
    required this.selectedContactList,
  });

  final ChatModel chatModel;
  final List<ContactModel>? selectedContactList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedContactList != null
            ? context.read<MessageBloc>().add(
                  ContactMessageSendEvent(
                    contactListToSend: selectedContactList!,
                    chatModel: chatModel,
                  ),
                )
            : null;
        Navigator.pop(context);
      },
      child: Container(
        height: 50.h,
        width: 60.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            darkLinearGradientColorOne,
            darkLinearGradientColorTwo,
          ]),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 30.sp,
            color: kWhite,
          ),
        ),
      ),
    );
  }
}
