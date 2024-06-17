import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/chat/charbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_hold_container.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagingPage extends StatelessWidget {
  const MessagingPage({super.key, required this.isGroup, this.isReadedMessage});

  final bool isGroup;
  final bool? isReadedMessage;

  // final bool? isGone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(),
      ),
      body: Container(
        height: screenHeight(context: context),
        width: screenWidth(context: context),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("$bgImageDark"), fit: BoxFit.cover)),
        child: Stack(
          children: [
            ListView.separated(
              separatorBuilder: (context, index) => kHeight15,
              itemCount: 20,
              padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              itemBuilder: (context, index) {
                return MessageHoldContainer(isReadedMessage: isReadedMessage);
              },
            ),
            ChatBarWidget(),
          ],
        ),
      ),
    );
  }
}

